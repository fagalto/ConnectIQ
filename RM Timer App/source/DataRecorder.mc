using Toybox.Time;
using Toybox.Position;

class DataRecorder  {
var gpsQuality;

function initialize() {
	me.gpsQuality = Position.QUALITY_NOT_AVAILABLE;
}



	function receivedPosition(info) {
	//me.gpsQuality = info.accuracy;
		if(me.gpsQuality !=info.accuracy) {
			me.gpsQuality =info.accuracy;
			Application.getApp().gpsQualityChange();
			
		}
	
	}

}