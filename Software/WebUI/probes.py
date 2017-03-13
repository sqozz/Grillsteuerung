#!/usr/bin/env python3
import can
import math
import json
import threading
from functools import reduce

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

				if len(self.messages[msg.arbitration_id]) >= self.__queueLength:
					oldMessage = self.messages[msg.arbitration_id]
					newMessage = oldMessage[1:]
					self.messages[msg.arbitration_id] = newMessage

				self.messages[msg.arbitration_id].append(msg.data)


	def getMessageQueue(self):
		with self.__messages_sema:
			return self.messages

	def getMessageQueueFromSensor(self, sensorNr):
		sensorId = sensorNr + 3
		with self.__messages_sema:
			if sensorId in self.messages.keys():
				return self.messages[sensorId]
			else:
				return None


class Probes():
	def __init__(self):
		self.__canListenerThread = ThreadedCanListener("can0")
		self.__canListenerThread.start()
		pass


	def getTemperaturesJSON(self, onlyEnabledSensors):
		dataJson = []
		for sensorNr in range(1,7):
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
		sensorId = sensorNr + 3
		if sensorId in sensorQueue.keys():
			dataBytes = sensorQueue[sensorId][-10:]
			sensorResistances = list(map(lambda byteArray: int.from_bytes(byteArray, byteorder="big", signed=False), dataBytes))
			sensorAvgResistance = reduce(lambda x, y: x + y, sensorResistances) / len(sensorResistances)
			return sensorResistances[-1]
			return sensorAvgResistance
		else:
			return None


	def getTemperature(self, sensorNr):
		sensorId = sensorNr + 3
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
