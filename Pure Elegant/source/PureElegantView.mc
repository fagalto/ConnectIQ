using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time.Gregorian;

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
	
	var hourColor;
	var themeColor;
	var bgColor;
	var fgColor;

    function initialize() {
    
        fullScreenRefresh = true;
        is24hour = System.getDeviceSettings().is24Hour;
        tempUnits = System.getDeviceSettings().temperatureUnits ;
        partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
        WatchFace.initialize();
        bgColor = Graphics.COLOR_BLACK;
        fgColor = Graphics.COLOR_WHITE;
        themeColor = Graphics.COLOR_RED;
        hourColor = Graphics.COLOR_DK_GRAY;
        
       
        
        
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
      
    }
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        
        dc.setColor(fgColor,bgColor);
        dc.clear();
        
        var colors = [fgColor,bgColor,themeColor,hourColor];

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
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        //hours = "23";
        //minutes = "33";
          
        dc.setColor(colors[0], colors[1]);
        dc.drawText(x, y, clockFont , minutes, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        var xOffset = dc.getTextWidthInPixels(minutes, Graphics.FONT_NUMBER_HOT);
        dc.setColor(colors[3], colors[1]);
        dc.drawText(x-xOffset, y, clockFont, hours, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
       // System.println("drawin "+timeString+ "on coords "+x+","+y+" with font "+Graphics.FONT_NUMBER_HOT);
    
    }
    function drawBar(dc,coords,colors) {
   	dc.setPenWidth(2);
	dc.setColor(colors[2], colors[1]);
	dc.drawLine(coords[0], coords[1], coords[2], coords[3]);
    }
    
    function drawData(dc,coords,colors) {
    //given lef upper and lower corner in coords.
	var info = ActivityMonitor.getInfo();
	var cals = info.calories;
	var steps = info.steps;
	var	myStats = System.getSystemStats();
	var battery = myStats.battery.toNumber();	
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
			
	dc.setColor(colors[0],colors[1]);
	dc.drawText(coords[0], coords[1]-fontHeight, dataFont, dayOfWeek, Graphics.TEXT_JUSTIFY_LEFT  );	
	var xyOffset = dc.getTextDimensions(dayOfWeek, dataFont); 
	dc.setColor(colors[3],colors[1]);
	dc.drawText(coords[0]+xyOffset[0], coords[1]-fontHeight, dataFont, daten.toUpper(), Graphics.TEXT_JUSTIFY_LEFT);

	dc.setColor(colors[0],colors[1]);
	xyOffset = dc.getTextDimensions(cals.toString(), dataFont);
	dc.drawText(coords[0], coords[1]+xyOffset[1]-fontHeight, dataFont, cals, Graphics.TEXT_JUSTIFY_LEFT);
	dc.setColor(colors[3],colors[1]);
	dc.drawText(coords[0]+xyOffset[0],coords[1]+xyOffset[1]-fontHeight, dataFont, " kcal", Graphics.TEXT_JUSTIFY_LEFT  );		

	dc.setColor(colors[0],colors[1]);
	xyOffset = dc.getTextDimensions(steps.toString(), dataFont);
	dc.drawText(coords[0], coords[1]+2*xyOffset[1]-fontHeight, dataFont, steps, Graphics.TEXT_JUSTIFY_LEFT);
	dc.setColor(colors[3],colors[1]);
	dc.drawText(coords[0]+xyOffset[0],coords[1]+2*xyOffset[1]-fontHeight, dataFont, " steps", Graphics.TEXT_JUSTIFY_LEFT  );	
	
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
    var yOffset = dc.getTextDimensions("0", font);//i wanna height only
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

}
