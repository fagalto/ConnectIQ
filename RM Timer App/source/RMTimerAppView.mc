using Toybox.WatchUi;

class RMTimerAppView extends WatchUi.View {
    var currentTrainingId;
    var tSet;
    var recorder;
    var trainingSessionStatus; //0-notstrted//1-started//2-paused//3-resumed//4-stopped
    var BgColor;
    var ThemeColor; 
    var hdBgColor;  
    var FgColor; 
    var redrawTimer;
	var drawContext;   
	var sWidth;
	var sHeight; 
	var headerColors;

    function initialize(ts,rec) {
        View.initialize();
        me.tSet = ts;
        me.recorder = rec;
        trainingSessionStatus = 0;
         ThemeColor = 0xFF5500;
           BgColor = 0x000000;
		 FgColor = 0xFFFFFF;
		 
		 headerColors = [0xFF0000,0x00FF00];
		 hdBgColor = headerColors[0];
    	me.redrawTimer = new Timer.Timer();		         
       

    }
    function settingChanged(tse) {
    System.println("updated settings to "+tse.serializedObject);
    me.tSet = tse;
   // 
    }

    // Load your resources here
    function onLayout(dc) {
        me.sWidth = dc.getWidth();
        me.sHeight = dc.getHeight();
    }
    function refreshStatus() {
    //var start = tSet.getSessionStatus()==1?
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
   System.println("onshow");
 		 
    }

    // Update the view
    function onUpdate(dc) {

        View.onUpdate(dc);
         
        drawBackground(dc);
        dc.setColor(FgColor, me.hdBgColor);
        
       
        dc.drawText(me.sWidth/2, me.sHeight*0.05, Graphics.FONT_SYSTEM_SMALL, tSet.curStepName, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
 		dc.setColor(FgColor, Graphics.COLOR_TRANSPARENT);
      // dc.drawText(me.sWidth/2, me.sHeight*0.2, Graphics.FONT_SYSTEM_SMALL, "Time", Graphics.TEXT_JUSTIFY_RIGHT);
      dc.setColor(ThemeColor, Graphics.COLOR_TRANSPARENT);  
       dc.drawText(me.sWidth/2, me.sHeight*0.25, Graphics.FONT_NUMBER_HOT , tSet.elapsedIntervalTime.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
       dc.setColor(FgColor, Graphics.COLOR_TRANSPARENT);      

       dc.drawText(me.sWidth/2, me.sHeight*0.4, Graphics.FONT_SYSTEM_SMALL, tSet.stepInfo.get("Distance")+"m@"+tSet.stepInfo.get("GoalTime"), Graphics.TEXT_JUSTIFY_CENTER);   
       dc.drawText(me.sWidth/2, me.sHeight*0.5, Graphics.FONT_SYSTEM_SMALL, "Pace:", Graphics.TEXT_JUSTIFY_RIGHT);  
       dc.drawText(me.sWidth/2, me.sHeight*0.5, Graphics.FONT_SYSTEM_SMALL, tSet.stepInfo.get("StepPace"), Graphics.TEXT_JUSTIFY_LEFT);                  
        
        
           
       
       dc.drawText(me.sWidth/2, me.sHeight*0.6, Graphics.FONT_SYSTEM_SMALL, "NextStep: ", Graphics.TEXT_JUSTIFY_RIGHT);
       dc.drawText(me.sWidth/2, me.sHeight*0.6, Graphics.FONT_SYSTEM_SMALL, tSet.nextStepName, Graphics.TEXT_JUSTIFY_LEFT);
       
       
      // dc.drawText(120, 70, Graphics.FONT_SYSTEM_SMALL, "SetPace=:"+tSet.elapsedIntervalTime, Graphics.TEXT_JUSTIFY_CENTER);       
       // System.println("updating");
 
 	
        
        
    }
    

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
     redrawTimer.stop();//(method(:redrawCallback), 50, true);
    }
    function pause(){
    redrawTimer.stop();
    }
     function resume(){
    redrawTimer.start(method(:redrawCallback), 50, true);
    } 
	function gpsChange() {
	 System.println("GPS Changed to :"+me.recorder.gpsQuality);
	 me.hdBgColor = (me.recorder.gpsQuality>2)?(headerColors[1]):(headerColors[0]);
	 WatchUi.requestUpdate();
	} 
    function drawBackground(dc) {
     	//System.println("drawin full bg");

		dc.setColor(BgColor, BgColor);
		dc.clear();
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
   			dc.setColor(FgColor, BgColor);
 
    } 
    function redrawCallback(){
   		  WatchUi.requestUpdate();
    }

}

