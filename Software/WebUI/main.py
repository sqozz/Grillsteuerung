#!/usr/bin/env python3
from bottle import route, run, template, static_file, request
from wifi import Cell
import json
import socket, fcntl, struct
import subprocess
import probes as probesmod

# LOWEST VALUE FOR FAN: 0x00e0 ~6V

global counter
counter = 0

def getInterfaceIP(ifname):
	try:
		s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		ip = socket.inet_ntoa(fcntl.ioctl(
			s.fileno(),
			0x8915,  # SIOCGIFADDR
			struct.pack('256s', ifname.encode("utf-8")[:15])
		)[20:24])
		s.close()
		return ip
	except OSError:
		return 0

def getESSID():
	try:
		return subprocess.check_output(["/sbin/iwgetid", "-r"]).decode("utf-8", "ignore").strip()
	except:
		return ""

@route("/")
def index():
	return template("main", ip=getInterfaceIP("wlp3s0"), ssid=getESSID())

@route("/wifisetup")
def wifiSetup():
	return str(list(Cell.all("wlp3s0")))

@route("/main.css")
def stylesheet():
	return static_file("main.css", ".")

@route("/main.js")
def javascript():
	return static_file("main.js", ".")

@route("/plotly-latest.min.js")
def plotly():
	return static_file("plotly-latest.min.js", ".")

@route("/fanspeed")
def getFanspeed():
	global fan
	if "speed" in request.query:
		fan.setFanSpeed(0x0EB, request.query["speed"])
	else:
		return "{}".format(fan.getFanSpeed(0x0EB))

@route("/temperatures.json")
def temps():
	global probes
	onlyEnabledSensors = True if request.query["onlyConnected"] == "1" else False
	sensors = probes.getTemperaturesJSON(onlyEnabledSensors)
	return sensors

def setup():
	global probes
	probes = probesmod.Probes()
	global fan
	fan = probesmod.Fan()

setup()
run(host="0.0.0.0", port=8080, debug=True, reloader=True)

# vim:ts=2:sw=2:sts=2:noexpandtab:fileencoding=utf-8
