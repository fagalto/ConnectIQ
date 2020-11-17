using Toybox.Sensor;

class accelerationData
{
public var mSamplesX = null;
public var mSamplesY = null;
public var mSamplesZ = null;

// Initializes the view and registers for accelerometer data
function enableAccel() {
var maxSampleRate = Sensor.getMaxSampleRate();

// initialize accelerometer to request the maximum amount of data possible
var options = {:period => 1, :sampleRate => maxSampleRate, :enableAccelerometer => true};
	try {
	Sensor.registerSensorDataListener(method(:accelHistoryCallback), options);
	}
	catch(e) {
	System.println(e.getErrorMessage());
	}
}

// Prints acclerometer data that is recevied from the system
function accelHistoryCallback(sensorData) {
me.mSamplesX = sensorData.accelerometerData.x;
me.mSamplesY = sensorData.accelerometerData.y;
me.mSamplesZ = sensorData.accelerometerData.z;
}

function disableAccel() {
Sensor.unregisterSensorDataListener();
}
}