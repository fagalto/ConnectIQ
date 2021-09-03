using Toybox.WatchUi;

class RMTimerAppDelegate extends WatchUi.BehaviorDelegate {
var ts;

    function initialize(trainingSet) {
        BehaviorDelegate.initialize();
        ts = trainingSet;
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new RMTimerAppMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    function onBack() {
        	
        	Application.getApp().lapPressed();
        return true;
    }
 
    function onKey(keyEvent) {
       // System.println("Key was pressed : "+keyEvent.getKey());  // e.g. KEY_MENU = 7
        
        if(keyEvent.getKey()==4)
        	{
        	//sttart or stop Timers
			//System.println("status is:"+ts.getSessionStatus());
        	//var result = (ts.getSessionStatus()==1 || ts.getSessionStatus()==3)?(ts.sessionPause()):(ts.sessionResume());
        	switch( ts.getSessionStatus()) {
        	default:  break;
        	case 0: ts.sessionStart(); break;//if not started then start
        	case 1: ts.sessionPause(); break;//already started then pause
        	case 2: ts.sessionResume(); break;//paused, resume then
        	case 3: ts.sessionStop(); break;//stopped then stop
        	
        	}
        	
        	Application.getApp().changeStatus();
        	}
        if(keyEvent.getKey()==19)
        	{
        	//System.println("Lap was pressed");
        	Application.getApp().lapPressed();
        	}        	
        
        //System.println(keyEvent.getType()); // e.g. PRESS_TYPE_DOWN = 0
        return true;
    }    

}