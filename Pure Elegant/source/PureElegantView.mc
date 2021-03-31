using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time.Gregorian;
using Toybox.Application.Properties;
using Toybox.Application.Storage;

class PureElegantView extends WatchUi.WatchFace {

	var fullScreenRefresh;
	var is24hour;
	var tempUnits;
	var partialUpdatesAllowed;
	var screenWidth;
	var screenHeight;
	
	var clockFont;
	var dataFont;
	var tCoords;
	
	var barCoords;
	
	var dataCoords;
	
	public var hourColor;
	public var themeColor;
	public var bgColor;
	public	var fgColor;
	public var displaySeconds;

    function initialize() {
    
        fullScreenRefresh = true;
        is24hour = System.getDeviceSettings().is24Hour;
        tempUnits = System.getDeviceSettings().temperatureUnits ;
        partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
        WatchFace.initialize();

        
       
        
        
    }

    // Load your resources here
    function onLayout(dc) {
    
    
    	screenWidth = dc.getWidth();
		screenHeight = dc.getHeight();
		tCoords = getTimeCoords(screenWidth,screenHeight);
		 clockFont = Graphics.FONT_NUMBER_HOT;
		 dataFont = Graphics.FONT_XTINY;
		 barCoords = getBarCoords(dc,screenWidth,screenHeight,clockFont);
		 dataCoords = getDataCoords(dc,screenWidth,screenHeight,clockFont);
		 getColorSettings(me);
		 dc.setAntiAlias(true);
      
    }
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
			if(Storage.getValue("SettingsChanged") == true)
				{
				      		 getColorSettings(me);
					         Storage.setValue("SettingsChanged", false); 
				}        
        dc.setColor(fgColor,bgColor);
        dc.clear();
        
        var colors = [fgColor,bgColor,themeColor,hourColor, Graphics.COLOR_TRANSPARENT];

		drawTime(dc,tCoords[0],tCoords[1],colors);
		drawBar(dc,barCoords,colors);
		drawData(dc,dataCoords,colors);
		


        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }
    
    function drawTime(dc,x,y,colors) {

        var timeFormat = "$1$ $2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min.format("%02d");
        if (!is24hour) {
	            if (hours > 12) {
	                hours = hours - 12;
	            }
        	} 
        //hours = "23";
        //minutes = "33";
          
        dc.setColor(colors[0], colors[4]);
        dc.drawText(x, y, clockFont , minutes, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        var xOffset = dc.getTextWidthInPixels(minutes, clockFont);
        dc.setColor(colors[3], colors[1]);
        dc.drawText(x-xOffset, y, clockFont, hours, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
       // System.println("drawin "+timeString+ "on coords "+x+","+y+" with font "+Graphics.FONT_NUMBER_HOT);
    
    }
    function drawBar(dc,coords,colors) {
   	dc.setPenWidth(3);
	dc.setColor(colors[2], colors[4]);
	dc.drawLine(coords[0], coords[1], coords[2], coords[3]);
    }
    
    function drawData(dc,coords,colors) {
    //given lef upper and lower corner in coords.
	var info = ActivityMonitor.getInfo();
	var cals = info.calories;
	var steps = info.steps;
	var	myStats = System.getSystemStats();
	var battery = myStats.battery.toNumber();	
	var rightMargin = screenWidth*0.93;
		var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT );
		var months = today.month;
		if(months<10)
			{
			months = "0"+months.toString();
			}
			months.toString();
		var daten =   today.day.toString()+"."+months;
		var dayOfWeek = dayOfWeek(today.day_of_week)+" ";
		var fontHeight = dc.getFontDescent(dataFont);
			
	dc.setColor(colors[0],colors[4]);
	dc.drawText(coords[0], coords[1]-fontHeight, dataFont, dayOfWeek, Graphics.TEXT_JUSTIFY_LEFT  );	
	var xyOffset = dc.getTextDimensions(dayOfWeek, dataFont); 
	dc.setColor(colors[3],colors[4]);
	//dc.drawText(coords[0]+xyOffset[0], coords[1]-fontHeight, dataFont, daten.toUpper(), Graphics.TEXT_JUSTIFY_LEFT);
	dc.drawText(rightMargin, coords[1]-fontHeight, dataFont, daten.toUpper(), Graphics.TEXT_JUSTIFY_RIGHT);

	dc.setColor(colors[0],colors[4]);
	xyOffset = dc.getTextDimensions(cals.toString(), dataFont);
	dc.drawText(coords[0], coords[1]+xyOffset[1]-fontHeight, dataFont, steps, Graphics.TEXT_JUSTIFY_LEFT);
	dc.setColor(colors[3],colors[4]);
	//dc.drawText(coords[0]+xyOffset[0],coords[1]+xyOffset[1]-fontHeight, dataFont, " kcal", Graphics.TEXT_JUSTIFY_LEFT  );	
	dc.drawText(rightMargin,coords[1]+xyOffset[1]-fontHeight, dataFont, " stps", Graphics.TEXT_JUSTIFY_RIGHT  );		

	dc.setColor(colors[0],colors[4]);
	xyOffset = dc.getTextDimensions(steps.toString(), dataFont);
	dc.drawText(coords[0], coords[1]+2*xyOffset[1]-fontHeight, dataFont, cals, Graphics.TEXT_JUSTIFY_LEFT);
	dc.setColor(colors[3],colors[4]);
	//dc.drawText(coords[0]+xyOffset[0],coords[1]+2*xyOffset[1]-fontHeight, dataFont, " steps", Graphics.TEXT_JUSTIFY_LEFT  );	
	dc.drawText(rightMargin,coords[1]+2*xyOffset[1]-fontHeight, dataFont, " kcal", Graphics.TEXT_JUSTIFY_RIGHT  );	
	
    }
    
    function getTimeCoords(width,height)
    {
    	return [width*0.62,height*0.5];
    }
    function getBarCoords(dc,width,height,font) {
    var xOff = 0.64;
    	var yOffset = dc.getTextDimensions("0", font);//i wanna height only
				var yOff = yOffset[1]/2;
    	return [width*xOff,height*0.5-yOff/2,width*xOff,height*0.5+yOff/2];
    }
    
    function getDataCoords(dc,width,height,font) {
    var xOff = 0.66;
    var yOffset = dc.getTextDimensions("012", font);//i wanna height only
    System.println("font dimensions are: "+yOffset);
     System.println("font height are: "+dc.getFontHeight(font));
      System.println("font descent are: "+dc.getFontDescent(font)); 

 				var yOff = yOffset[1]/2;
    	return [width*xOff,height*0.5-yOff/2,width*xOff,height*0.5+yOff/2];   
    }
    
	function dayOfWeek(day) {
	
	var days = [1, 2, 3, 4, 5, 6, 7, 8];
	days[0]=null;
	days[1]="Sunday";
	days[2]="Monday";
	days[3]="Tuesday";
	days[4]="Wednesday";
	days[5]="Thursday";
	days[6]="Friday";
	days[7]="Saturday";
	
	return days[day].substring(0,3);

	}	    

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    function onSettingsChanged(app) {
          		 app.getColorSettings(app); 
    }    

	public function getColorSettings(app) {
	if(app ==null)
		{
		app = PureElegantView;
		}
			
        if(Application.getApp().getProperty("BackgroundColor") != null)
        {
        app.bgColor = Application.getApp().getProperty("BackgroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("BackgroundColor", app.bgColor);
        	}
        	 
      	if(Application.getApp().getProperty("ForegroundColor") != null)
        {
        app.fgColor = Application.getApp().getProperty("ForegroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("ForegroundColor", app.fgColor);
        	}      
        if(Application.getApp().getProperty("ThemeColor") != null)
        {
        app.themeColor = Application.getApp().getProperty("ThemeColor");
        
        }   
        else
        	{
        	Application.getApp().setProperty("ThemeColor", app.themeColor);
        	}		
        if(Application.getApp().getProperty("HoursColor") != null)
        {
        app.hourColor = Application.getApp().getProperty("HoursColor");
        
        }   
        else
        	{
        	Application.getApp().setProperty("HoursColor", app.hourColor);
        	}        	
        if(Application.getApp().getProperty("displaySeconds") != null)
        {
        app.displaySeconds = Application.getApp().getProperty("displaySeconds");
        }   
        else
        	{
        	Application.getApp().setProperty("displaySeconds", app.displaySeconds);
        	}        	        	
	}


}
class ElegantViewDelegate extends WatchUi.WatchFaceDelegate {
    // The onPowerBudgetExceeded callback is called by the system if the
    // onPartialUpdate method exceeds the allowed power budget. If this occurs,
    // the system will stop invoking onPartialUpdate each second, so we set the
    // partialUpdatesAllowed flag here to let the rendering methods know they
    // should not be rendering a second hand.
    function onPowerBudgetExceeded(powerInfo) {
        System.println( "Average execution time: " + powerInfo.executionTimeAverage );
        System.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
        partialUpdatesAllowed = false;
    }
}
