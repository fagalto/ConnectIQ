using Toybox.Time;

class TrainingSet  {

var trainingObject;
var serializedObject;
var sessionStatus;//0-notstrted//1-started//2-paused//3-resumed//4-stopped
var sessionTimer;
var elapsedIntervalTime;
var setIntervalTime;
var currentSet;
var sessionSize;
var trainingArray;
var userVdot;
var intervalStartTime;
var intervalStopTime;
var restStartTime;
var currentStageInfo;
var curStepName;//run/rest
var nextStepName;//run/rest
var stepNames;
var stepInfo;

    function initialize(vDot) {
    me.trainingObject = {};
    me.sessionStatus =0;
    me.elapsedIntervalTime =0;
    me.sessionTimer = new Timer.Timer();
    me.currentSet = 0;
	me.userVdot = vDot;
	me.intervalStartTime = null;
	me.restStartTime = null;
	me.currentStageInfo = {};
	me.stepNames =["Run","Rest"];

    }


    
    
   	 function changeSessionValues(values) {
   	me.trainingObject = values;
   	 serializeTrainingObject();

    }
    function serializeTrainingObject() {
    me.serializedObject = {};
    
    var subsets = trainingObject["set"].keys().size();
   // System.println("TO size="+trainingObject["set"].keys().size());
   me.serializedObject.put("set0",WarmUpSplit());
    var j=1;
    trainingArray = new [trainingObject["repeats"]*subsets];
    for(var i=0; i<trainingObject["repeats"];i++) {
    	for(var k=0; k<subsets; k++) {
    		//System.println("Set "+i+"subset "+trainingObject["set"].get(k));
    		me.serializedObject.put("set"+j,trainingObject["set"].get(trainingObject["set"].keys()[k]));
    		trainingArray[j-1] = trainingObject["set"].get(trainingObject["set"].keys()[k]);
    		j++;
    	}
    me.sessionSize = me.serializedObject.keys().size();
    }
    me.serializedObject.put("set"+j,CoolDownSplit());
	me.curStepName = getStepInfo(0).get("StepName");
	me.nextStepName = getStepInfo(1).get("StepName");  
	me.stepInfo = getStepInfo(0);   
    return me.serializedObject;
    }
    
    //
    function getSessionStatus(){
    return me.sessionStatus;
     //System.println("Status is:"+me.sessionStatus);
    }
    function sessionStart() {
    me.sessionStatus =1;
    Application.getApp().start();   
    Application.getApp().resume();
    me.beginTrainingSession(me.currentSet);
   // System.println("Setting Session status to: "+ me.sessionStatus);
    return true;
    }
    function sessionStop() {
    me.sessionStatus =3;
    sessionTimer.stop();
    Application.getApp().pause();
 //   System.println("Setting Session status to: "+ me.sessionStatus);
    return true;
    }
    function sessionPause() {
    me.sessionStatus =2;
    sessionTimer.stop();//method(:timerCallback), 50, true); 
    Application.getApp().pause();
  //  System.println("Setting Session status to: "+ me.sessionStatus);
    return true; 
    }    
    function sessionResume() {
   sessionTimer.start(method(:timerCallback), 50, true); 
    Application.getApp().resume();
    me.sessionStatus =1;
 //	System.println("Setting Session status to: "+ me.sessionStatus);    
    return true;    
    } 
    
    
    
    /////////////////////////////////////////////////
    function lapKeyPressed() {
    	me.curStepName = me.nextStepName;
	me.nextStepName = getStepInfo(me.currentSet).get("StepName");     	
    if(me.intervalStartTime !=null){
   
    me.intervalStopTime = Time.now();
    me.sessionTimer.stop();
    if(me.restStartTime!=null)
    	{//we are on a break ;)//
    	System.println("Rest took time of "+me.elapsedIntervalTime+"seconds");
    	}
    	else
    	{
    		System.println("That lap took time of "+me.elapsedIntervalTime+"seconds");
    }
    //System.println("Thank of Timer hack we counted "+me.elapsedIntervalTime+"seconds");
    
    //if there was Rest time >0 begin rest interval
    me.elapsedIntervalTime =0;
    var currentStep = getStepInfo(currentSet);
    var restTime = currentStep.get("RestTime");
    if(restTime>0 and me.restStartTime==null)
    	{
    	System.println("Lets have a break for "+restTime+"seconds");
     		me.restStartTime = Time.now();
    		sessionTimer.start(method(:timerCallback), 50, true);    	
    	}
    	else {

    		me.restStartTime=null;
			me.currentSet++;
			 me.elapsedIntervalTime =0;
			   if(me.currentSet<me.sessionSize)
			   	{
			   	 me.beginTrainingSession(me.currentSet);
			   	}  
			   	else
			   		{
			   		//end of session
			   		System.println("Training Completed");
			   		//me.currentSet=0;
			   		    me.intervalStartTime = null;
		   				me.intervalStopTime = null; 
			   		}
			}
			   	
    }
    else
    	{
    	//System.println("StartTimeisNull,no Lapping");
    	}
    
    //empty timer variables to be ready to count next step.

    } 
    
    function timerCallback() {
   
    me.elapsedIntervalTime += 0.050000000;
	} 
	
	function beginTrainingSession(step) {
    		me.intervalStartTime = Time.now();
    		 me.stepInfo = getStepInfo(step);
				me.curStepName = stepInfo.get("StepName");
			var restTime = stepInfo.get("RestTime");
			me.nextStepName = (restTime>0)?"Rest":(getStepInfo(step+1).get("StepName"));    		
    		sessionTimer.start(method(:timerCallback), 50, true);    	
	}  
 	function WarmUpSplit() {
 	 	return {"Distance" =>3000,
 				"Intensity"=>"Easy",
 				"RestTime"=>0,
 				"StepName"=>"Warm Up"};
 	}
 	function CoolDownSplit() {
 	 	return {"Distance" =>3000,
 				"Intensity"=>"Easy",
 				"RestTime"=>0,
 				"StepName"=>"Cool Down"};
 	} 	
 	
 	function getStepInfo(step) {
 	
 			var currentStep = me.serializedObject.get(me.serializedObject.keys()[step]);
    		var restTime = currentStep.get("RestTime");
    		var stepHasName = currentStep.get("StepName");
    		var stepPace = userVdot.racePaces.get(currentStep.get("Intensity"));

    		var stepGoalTime = stepPace*currentStep.get("Distance").toNumber()/1000;
    		stepPace = userVdot.secondsToPace(stepPace);
    		stepGoalTime = stepGoalTime.format("%.1f");    		
    		 			
		return {
		"StepName"=>currentStep.get("StepName"),
		"StepPace"=>stepPace,
		"Distance"=>currentStep.get("Distance"),
		"RestTime"=>restTime,
		"GoalTime"=>stepGoalTime
		
		};
 	}
 	function setPosition(info) {
 	
 	System.println("received position object:"+info);
 	
 	}
    
 
}