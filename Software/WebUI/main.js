availableProbes = []

function updateTemperature(newTemperature, probeNr, enabled) {
	probeDataContainer = document.getElementById("probeDataContainer")
	probeContainer = document.getElementById("probe" + probeNr)

	if (probeContainer == null && enabled) {
		generateProbe(probeNr)
	}

	if ((probeContainer != null) && enabled == true) { // update if probe exists
		updateProbe(probeNr, newTemperature)
	}

	updateGraph(newTemperature, probeNr)
}

function probeInList(probeNr) {
	if (availableProbes[probeNr] != undefined) {
		return true
	} else {
		return false
	}
}

function updateProbe(probeNr, temperature) {
	var UNIT = "°C"
	if (probeInList(probeNr)) {
		temp = availableProbes[probeNr].querySelector(".temperature")
		temp.innerHTML = temperature + UNIT
	}
}

function removeProbe(probeNr) {
	if (probeInList(probeNr)) {
		availableProbes[probeNr].remove()
		availableProbes[probeNr] = undefined
	}
}

/*
 * Generates a new probe, appends it in HTML and
 * manages the available probes
 */
function generateProbe(probeNr) {
	probeContainer = generateProbeComponent(probeNr)
	probeDataContainer.appendChild(probeContainer)
	if (!probeInList(probeNr)) {
		availableProbes[probeNr] = probeContainer
	}
	sortGraphs()
}

/*
 * Method for cloning the hidden template
 * and returning it with modified parameters like
 * different id and removed templating classes
 *
 */
function generateProbeComponent(probeNr) {
	var newId = "probe" + probeNr
	var template = document.querySelectorAll(".probe.template")[0] // This is the template DOM element. NEVER modify this object here - make a clone beforehand!
	var probeDomElement = template.cloneNode(true) // true = do a deep-clone (recursive)

	probeDomElement.classList.remove("template") // remove templating class
	probeDomElement.id = newId // assign new id

	probeDomElement.querySelector(".name").innerHTML = "Sensor " + probeNr + ":"

	return probeDomElement
}

/*
 * Sort graphs displayed on screen by their id
 */
function sortGraphs() {
	ids = []
	childs = document.querySelectorAll("#probeDataContainer>*:not(.template)")

	for (var i = 0; i < childs.length; i++) {
		ids = ids.concat(childs[i].id)
	}
	ids = ids.sort()

	for (var i = 0; i < ids.length; i++) {
		probe = document.getElementById(ids[i])
		old_probe = probe
		probe.remove()
		document.getElementById("probeDataContainer").appendChild(old_probe)
	}
}

function createDataStub() {
	var dataStub = []
	dataStub[0] = new Object()
	dataStub[0].x = new Array()
	dataStub[0].y = new Array()
	dataStub[0].type = "markers"
	dataStub[0].line = new Object()
	dataStub[0].line.color = "rgb(0, 0, 0)"
	dataStub[0].width = 0.8

	return dataStub
}

data = []

xaxisShown = {
	showgrid: false,
	fixedrange: true,
	autorange: true,
	type: "date",
}

yaxisShown = {
	showgrid: false,
	fixedrange: true,
	gridwidth: 100,
	range: [0, 300]
},

xaxisHidden = {
	autorange: true,
	showgrid: false,
	zeroline: false,
	showline: false,
	autotick: true,
	ticks: '',
	showticklabels: false
}

yaxisHidden = xaxisHidden


layout = {
//	autosize: false,
//	hovermode: !1,
//	width: 900,
//	height: 130,
	margin: {
		l: 40,
		b: 40,
		r: 10,
		t: 10,
		pad: 4
	},
	xaxis: xaxisHidden,
	yaxis: yaxisShown,
	plot_bgcolor: "transparent",
	paper_bgcolor: "transparent"
};

function updateGraph(newTemperature, probeNr) {
	probeDataIndex = probeNr - 1
	if (data[probeDataIndex] == undefined) {
		data[probeDataIndex] = createDataStub()
	}
	if (data[probeDataIndex][0].x.length >= 20) {
		data[probeDataIndex][0].x = data[probeDataIndex][0].x.slice(1)
		data[probeDataIndex][0].y = data[probeDataIndex][0].y.slice(1)
	}
	time = new Date()

	graphDom = document.querySelectorAll("#probe" + probeNr + " .graph")[0]
	if (graphDom != undefined) {
		if (graphDom.classList.contains("js-plotly-plot")) {
			Plotly.extendTraces(graphDom, {x: [[time.getTime()]], y: [[newTemperature]]}, [0])
		} else {
			Plotly.newPlot(graphDom, data[probeDataIndex], layout, {displayModeBar: false, scrollZoom: false});
		}
	}
}

// Fetch temperatures.json every 500ms from server and process its data
setInterval(function(){
	var xhr = new XMLHttpRequest();
	xhr.open('get', "temperatures.json?onlyConnected=1", true);
	xhr.responseType = 'json';
	xhr.onload = function() {
		var status = xhr.status;
		if (status == 200) {
			sensorData = xhr.response;
			for (i=0; i < sensorData.length; i++) {
				//updateTemperature(sensorData[i].temperature, sensorData[i].sensor, sensorData[i].connected)
				updateProbe(sensorData[i].sensor, sensorData[i].temperature)
			}
		} else {
			console.log("HTTP-Status not 200. Got instead: " + status);
		}
	};
	xhr.send();
}, 500);

// Update the clock!
setInterval(function(){
	var time = new Date();
	timeDiv = document.getElementById("globalTime")
	timeDiv.innerHTML = ("0" + time.getHours()).slice(-2)   + ":" +
    ("0" + time.getMinutes()).slice(-2) + ":" +
    ("0" + time.getSeconds()).slice(-2)
}, 500);
