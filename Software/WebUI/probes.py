#!/usr/bin/env python3
import can
import math
import json
import threading
from functools import reduce

canListener = None
canInterface = "can0"

class ThreadedCanListener(threading.Thread):
	def __init__(self, interface, queueLength = 1):
		self.interface = interface
		self.messages = {}
		self.__messages_sema = threading.BoundedSemaphore()
		self.__queueLength = queueLength
		threading.Thread.__init__(self)
		self.__canBus = can.interface.Bus(channel=self.interface, bustype="socketcan_ctypes")

	def run(self):
		for msg in self.__canBus:
			with self.__messages_sema:
				if msg.arbitration_id not in self.messages.keys():
					self.messages[msg.arbitration_id] = []
					print("new id: {}".format(msg.arbitration_id))

				if len(self.messages[msg.arbitration_id]) >= self.__queueLength:
					oldMessage = self.messages[msg.arbitration_id]
					newMessage = oldMessage[1:]
					self.messages[msg.arbitration_id] = newMessage

				self.messages[msg.arbitration_id].append(msg.data)

	def getMessageQueue(self):
		with self.__messages_sema:
			return self.messages

	def getMessageQueueFromSensor(self, sensorNr):
		sensorId = sensorNr
		with self.__messages_sema:
			if sensorId in self.messages.keys():
				return self.messages[sensorId]
			else:
				return None

	def getMessagesQueueFromFan(self, fanId):
		with self.__messages_sema:
			if fanId in self.messages.keys():
				return self.messages[fanId]
			else:
				return None

	def sendMessage(self, targetId, message):
		message = can.Message(arbitration_id = targetId, data = message, extended_id = False)
		self.__canBus.send(message)

class Fan():
	MIN_VALUE = 0xE000
	MAX_VALUE = 0xFFFF
	RANGE = MAX_VALUE - MIN_VALUE

	def __init__(self):
		global canListener
		global canInterface
		if canListener is None:
			self.__canListenerThread = ThreadedCanListener(canInterface)
			self.__canListenerThread.start()
		else:
			self.__canListenerThread = canListener
		pass

	def __convertToPercent(self, rawNumber):
		print("RAW: {}  -  MIN_VALUE: {}  -  MAX_VALUE: {}".format(rawNumber, self.MIN_VALUE, self.MAX_VALUE))
		if rawNumber < self.MIN_VALUE:
			return 0
		else:
			return ((100 / self.RANGE) * (rawNumber - self.MIN_VALUE))

	def __convertToRaw(self, percent):
		percent = int(percent)
		print((self.RANGE / 100) * percent)
		if percent is 0:
			return 0
		else:
			return self.MIN_VALUE + int((self.RANGE / 100) * percent)

	def setFanSpeed(self, fanId, percent):
		print("Set speed to {}%".format(percent))
		intValue = self.__convertToRaw(percent)
		print("Set speed to raw {}".format(intValue))
		message = [intValue >> 8, intValue & 0xFF] + [0x0]*5 + [0x02]
		self.__canListenerThread.sendMessage(fanId - 1, message)

	def getFanSpeed(self, fanId):
		dataJson = []
		messageQueue = self.__canListenerThread.getMessageQueue()

		if fanId in messageQueue.keys() and len(messageQueue[fanId]) > 0:
			fanQueue = messageQueue[fanId]
			fanSpeed = fanQueue[-1][1] + (fanQueue[-1][0] << 8)
		else:
			fanSpeed = -1

		return self.__convertToPercent(fanSpeed)


class Probes():
	def __init__(self):
		global canListener
		global canInterface
		if canListener is None:
			self.__canListenerThread = ThreadedCanListener(canInterface)
			self.__canListenerThread.start()
		else:
			self.__canListenerThread = canListener
		pass


	def getTemperaturesJSON(self, onlyEnabledSensors):
		dataJson = []
		for sensorNr in range(1,7):
			sensorNr += 0x00B
			temperature = int(self.getTemperature(sensorNr))
			connected = self.checkIfConnected(sensorNr)
			if ((not onlyEnabledSensors) or connected):
				dataJson += [{
					"sensor" : sensorNr,
					"temperature" : str(temperature),
					"connected" : connected,
				}]
		return json.dumps(dataJson)
		pass


	def checkIfConnected(self, sensorNr):
		sensorResistance = self.__getSensorResistanceFromCan(sensorNr)
		connected = False
		if sensorResistance is None:
			connected = False #No messages from sensor on bus
		else:
			if sensorResistance <= 500000:
				connected = True
		return connected


	def __getSensorResistanceFromCan(self, sensorNr):
		sensorQueue = self.__canListenerThread.getMessageQueue()
		dataBytes = None
		sensorId = sensorNr
		if sensorId in sensorQueue.keys():
			dataBytes = sensorQueue[sensorId][-10:]
			sensorResistances = list(map(lambda byteArray: int.from_bytes(byteArray, byteorder="big", signed=False), dataBytes))
			sensorAvgResistance = reduce(lambda x, y: x + y, sensorResistances) / len(sensorResistances)
			return sensorResistances[-1]
			return sensorAvgResistance
		else:
			return None


	def getTemperature(self, sensorNr):
		sensorId = sensorNr
		messageQueue = self.__canListenerThread.getMessageQueue()
		temperatures = []
		est = -1

		if sensorId in messageQueue.keys():
			sensorQueue = messageQueue[sensorId]
			sensorQueue.reverse()
			for message in sensorQueue:
				sensorResistance = int.from_bytes(message, byteorder="big", signed=False)
				temperatures += [int(self.__calculateTemperature(sensorResistance))]
				if len(temperatures) >= 10:
					break
		if len(temperatures) > 0:
			#exponential smoothed temperature == est
			weight = 0.6
			temperatures.reverse()
			est = int(temperatures[0])
			for measurement in range(1, len(temperatures)):
				est = int(weight * temperatures[measurement] + (1-weight)*est)

			#temperatureAvg = reduce(lambda x, y: int(x + y), temperatures) / len(temperatures)
		return est

	def __calculateTemperature(self, sensorResistance):
		# Magic numbers; Don't touch them!
		STEINHART_HART_COEF_A = 2.3067434E-4
		STEINHART_HART_COEF_B = 2.3696596E-4
		STEINHART_HART_COEF_C = 1.2636414E-7

		#Steinhart-Hart-Equation
		shePart1 = STEINHART_HART_COEF_A
		shePart2 = STEINHART_HART_COEF_B * math.log(sensorResistance)
		shePart3 = STEINHART_HART_COEF_C * math.log(sensorResistance)**3
		temperature = 1 / (shePart1 + shePart2 + shePart3) #Kelvin
		temperature = temperature - 273.15 #And now in Celsius

		return temperature
