using Toybox.Application;
using Toybox.WatchUi;
using Toybox.ActivityRecording;
using Toybox.Position;

class RMTimerAppApp extends Application.AppBase {

var sParser;
var trainingSet;
var AppView;
var vDotCalc;
var session = null;
var recorder;

    function initialize() {
        AppBase.initialize();
         sParser =  new SettingsParser();
         vDotCalc = new VdotCalculator(62);
         trainingSet = new TrainingSet(vDotCalc);
         recorder = new DataRecorder();
    	var trainingSetObject = sParser.parseTrainingStringToTimerObject();
    	trainingSet.changeSessionValues(trainingSetObject) ;
    	AppView = new RMTimerAppView(trainingSet,recorder);
    	//System.println(VdotCalc.racePaces);
 
    }

    // onStart() is called on application start up
    function onStart(state) {
   		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));//enable GPS
    }
    function start() {
				
				
				   if (Toybox has :ActivityRecording) {                          // check device for activity recording
				       if ((session == null) || (session.isRecording() == false)) {
				           session = ActivityRecording.createSession({          // set up recording session
				                 :name=>"RM Timer Session",                              // set session name
				                 :sport=>ActivityRecording.SPORT_RUNNING,       // set sport type 
				           });
				           session.start();                                     // call start session
				       }
				       else if ((session != null) && session.isRecording()) {
				           session.stop();                                      // stop the session
				           session.save();                                      // save the session
				           session = null;                                      // set session control variable to null
				       }
				   }
				   return true;                                                 // return true for onSelect function
				}   

	function changeStatus() {
		AppView.refreshStatus();
	}
	function lapPressed() {
		trainingSet.lapKeyPressed();
	}	
	function pause() {
		AppView.pause();
	}	
	function resume() {
		AppView.resume();
	}		
	function fitSave() {
				if ((session != null) && session.isRecording()) {
							           session.stop();                                      // stop the session
							           session.save();                                      // save the session
							           session = null;                                      // set session control variable to null
							       }  
	}
    // onStop() is called when your application is exiting
    function onStop(state) {
    
    Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));

  
    }
    function onPosition(info) {
        recorder.receivedPosition(info);
    }    
    function gpsQualityChange() {
    AppView.gpsChange();
    }
    function onSettingsChanged() {
		sParser.onSettingsChanged();
    	var trainingSetObject = sParser.parseTrainingStringToTimerObject();
    	trainingSet.changeSessionValues(trainingSetObject) ;
    	AppView.settingChanged(trainingSet);
    }    

    // Return the initial view of your application here
    function getInitialView() {
        return [ AppView, new RMTimerAppDelegate(trainingSet) ];
    }

}
