<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Grillthermometer v0.1</title>
		<link rel="stylesheet" href="main.css">
		<script src="plotly-latest.min.js"></script>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	</head>
	<body>
		<div id="main">
			<div class="header">
				<div id="wifiStatus">Verbunden mit "{{ssid}}" ({{ip}})</div>
				<div id="globalTime">23:42 Uhr</div>
			</div>

			<div id="probeDataContainer">
				<!-- TEMPLATE -->
				<div class="probe template">
					<div id="left" class="container">
						<div class="name">TEMPLATE_NAME</div>
						<div class="temperature">TEMPLATE_TEMP</div>
					</div>
					<div class="graph"></div>
				</div>
				<!-- /TEMPLATE -->
			</div>
		</div>
		<div id="fanControl">
			<span id="description">Lüfter</span>
			<div id="buttons">
				<button id="up" value="up">up</button>
				<button id="down" value="down">down</button>
			</div>
		</div>
		<script src="main.js"></script>
	</body>
</html>
