using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Attention;
using Toybox.Timer;
using Toybox.Time;
using Toybox.Time.Gregorian;

class PickerView extends WatchUi.View {

public var timerRemainingTime;
public var timerElapsedTime;
public var timerStartedTime;
public var timerWillEndTime;


    function initialize() {
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));

        if(Application.getApp().getProperty("utime") == null) {
           Application.getApp().setProperty("utime", 25000);
        }
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This include
    //! loading resources into memory.
    function onShow() {
        var app = Application.getApp();

        // find and modify the labels based on what is in the object store

        var time = findDrawableById("time");
        var utime = findDrawableById("remainingTime");


       var prop = app.getProperty("time");
        if(prop != null) {
            time.setText(prop);
        }
        prop = app.getProperty("utime");
        if(prop != null) {
            utime.setText(prop.toString());
        }
        // set the color of each Text object
        prop = app.getProperty("color");
        if(prop != null) {
            time.setColor(prop);
        }
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
     function timerCallback() {
   	 
		// Play a predefined tone
		if (Attention has :playTone) {
		   Attention.playTone(Attention.TONE_LOUD_BEEP);
		}   	 
		if (Attention has :vibrate) {
			    var vibeData =
			    [
			        new Attention.VibeProfile(50, 1000), // On for two seconds
			        new Attention.VibeProfile(0, 1000),  // Off for two seconds
			    ];
			    Attention.vibrate(vibeData);
			}
	}     
      function onStartTimers() {
            var myTimer = new Timer.Timer();
            var interval = Application.getApp().getProperty("utime");

		    myTimer.start( method(:timerCallback), interval, true);
		  //  timerStartedTime = Time.now().value();
			 var timerWillEndTime =  interval/1000.0f;
			System.println("timer will end at: "+timerWillEndTime);
		return true;    
		    
    }   

     

}

class PickerDelegate extends WatchUi.BehaviorDelegate {

var pickerShown = false;
    function initialize() {
        BehaviorDelegate.initialize();
    }



    function onKey(evt) {
        var key = evt.getKey();
        System.println("another key pressed: "+key);
        if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) {
           if( pickerShown ==true ) {
           		return onMenu();
           }else	{ }
        }  
        else {
        
        return false;
        }   
        return false;

    }
    function onSelect() {
        //return pushPicker();

        System.println("another key pressed: ");
        PickerView.onStartTimers();
        return true;
    }
    function onMenu() {
        return pushPicker();
    }    
 
    function pushPicker() {
    pickerShown = true;
       WatchUi.pushView(new TimePicker(), new TimePickerDelegate(pickerShown), WatchUi.SLIDE_IMMEDIATE);
       
    }
   
     function timerCallback() {
   	 
		// Play a predefined tone
		if (Attention has :playTone) {
		   Attention.playTone(Attention.TONE_LOUD_BEEP);
		}   	 
		if (Attention has :vibrate) {
			    var vibeData =
			    [
			        new Attention.VibeProfile(50, 1000), // On for two seconds
			        new Attention.VibeProfile(0, 1000),  // Off for two seconds
			    ];
			    Attention.vibrate(vibeData);
			}
	}    
}