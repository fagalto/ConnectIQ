
//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.

// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Application;
using Toybox.SensorHistory;


var partialUpdatesAllowed = false;

// This implements an analog watch face
// Original design by Austen Harbour
class SliderView extends WatchUi.WatchFace
{
    var font1;
    var font_min;
    var font_min1;
    var font_min2;
    var font_max;
    var isAwake;
    var screenShape;
    var dndIcon;
    var offscreenBuffer;
    var dateBuffer;
    var curClip;
    var screenCenterPoint;
   // var screenHalfPoint;
    var fullScreenRefresh;
    var is24hour;
    var tempUnits;
    	var fontSize;
    	var rungdn;
    	var bargdn;

    // Initialize variables for this view
    function initialize() {
        WatchFace.initialize();
        screenShape = System.getDeviceSettings().screenShape;
        fullScreenRefresh = true;
        partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
    }

    // Configure the layout of the watchface for this device
    function onLayout(dc) {

        // Load the custom font we use for drawing the 3, 6, 9, and 12 on the watchface.
       // font1 = WatchUi.loadResource(Rez.Fonts.mari_font);
        font_min1 = WatchUi.loadResource(Rez.Fonts.mari_font_min);
        font_min2 = WatchUi.loadResource(Rez.Fonts.mari_font_min2);
        font_max = WatchUi.loadResource(Rez.Fonts.steelfish);
       // rungdn = new WatchUi.Bitmap({:rezId=>Rez.Drawables.RunGdnIcon});
         rungdn = WatchUi.loadResource(Rez.Drawables.RunGdnIcon);
          bargdn = WatchUi.loadResource(Rez.Drawables.BarGdn);
        //font_max = WatchUi.loadResource(Rez.Fonts.teko);

        // If this device supports the Do Not Disturb feature,


        // If this device supports BufferedBitmap, allocate the buffers we use for drawing
        if(Toybox.Graphics has :BufferedBitmap) {
            // Allocate a full screen size buffer with a palette of only 4 colors to draw
            // the background image of the watchface.  This is used to facilitate blanking
            // the second hand during partial updates of the display
            offscreenBuffer = new Graphics.BufferedBitmap({
                :width=>dc.getWidth(),
                :height=>dc.getHeight(),
                :palette=> [
                    Graphics.COLOR_DK_GRAY,
                    Graphics.COLOR_LT_GRAY,
                    Graphics.COLOR_BLACK,
                    Graphics.COLOR_WHITE
                ]
            });

            // Allocate a buffer tall enough to draw the date into the full width of the
            // screen. This buffer is also used for blanking the second hand. This full
            // color buffer is needed because anti-aliased fonts cannot be drawn into
            // a buffer with a reduced color palette
            dateBuffer = new Graphics.BufferedBitmap({
                :width=>dc.getWidth(),
                :height=>Graphics.getFontHeight(Graphics.FONT_MEDIUM)
            });
        } else {
            offscreenBuffer = null;
        }

        curClip = null;

        screenCenterPoint = [dc.getWidth()/2, dc.getHeight()/2];
    }

    // This function is used to generate the coordinates of the 4 corners of the polygon
    // used to draw a watch hand. The coordinates are generated with specified length,
    // tail length, and width and rotated around the center point at the provided angle.
    // 0 degrees is at the 12 o'clock position, and increases in the clockwise direction.


    // Draws the clock tick marks around the outside edges of the screen.


    // Handle the update event
    function onUpdate(dc) {
        var width;
        var height;
        var screenWidth = dc.getWidth();
        var clockTime = System.getClockTime();
        var minuteHandAngle;
        var hourHandAngle;
        var secondHand;
        var targetDc = null;
        var Barcolor = 0xFF0000;
        var ShowBatteryBar = false; 
        var ShowActivityBar = false;
        is24hour = System.getDeviceSettings().is24Hour;
         tempUnits = System.getDeviceSettings().temperatureUnits ;
    
        var Bg = 0x000000;
		var Fg = 0xFFFFFF;
		var ThemeColor = 0x555555; //Application.getApp().getProperty("DotColor");
		var StepCals = 1;//cals
        if(Application.getApp().getProperty("BackgroundColor") != null)
        {
        Bg = Application.getApp().getProperty("BackgroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("BackgroundColor", Bg);
        	}
      	if(Application.getApp().getProperty("ForegroundColor") != null)
        {
        Fg = Application.getApp().getProperty("ForegroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("ForegroundColor", Fg);
        	}      
      	if(Application.getApp().getProperty("ThemeColor") != null)
        {
        ThemeColor = Application.getApp().getProperty("ThemeColor");
        }
        else
        	{
        	Application.getApp().setProperty("ThemeColor", ThemeColor);
        	}  

       	       	        	    
        // We always want to refresh the full screen when we get a regular onUpdate call.
        fullScreenRefresh = true;

        if(0)//null != offscreenBuffer) 
		{
            dc.clearClip();
            curClip = null;
            // If we have an offscreen buffer that we are using to draw the background,
            // set the draw context of that buffer as our target.
            targetDc = offscreenBuffer.getDc();
        } else {
            targetDc = dc;
        }

        // Fill the entire background with Black.
        targetDc.setColor(Bg, Bg);

		targetDc.clear();
		// targetDc.setColor(Graphics.COLOR_RED, Bg);
		dc.setPenWidth(2);

	

		drawMinutes(targetDc,Bg,Fg);
		drawRungdn(targetDc,Bg,Fg,ThemeColor);
		
		//drawVerticalBar(dc,Fg);


        if( partialUpdatesAllowed ) {
            // If this device supports partial updates and they are currently
            // allowed run the onPartialUpdate method to draw the second hand.
          //  onPartialUpdate( dc );
        } else if ( isAwake ) {
            // Otherwise, if we are out of sleep mode, draw the second hand
            // directly in the full update method.
           // dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
           // secondHand = (clockTime.sec / 60.0) * Math.PI * 2;
        }

        fullScreenRefresh = false;
    }

    // Draw the date string into the provided buffer at the specified location


	

	
	 //dc.drawLine(dc.getWidth()/2, BbarY, 168 ,BbarY);
	
	function drawMinutes(dc,Background,Foreground)	{
	//height = 30/170
	var hcoord= 120/170f;
	var step = dc.getWidth()/120f;//rozpi�to�� to 120 min, step to 5 minut -->2px
	
	dc.setColor(Foreground , Graphics.COLOR_TRANSPARENT);

	var font =  font_max;
	var corr = dc.getFontHeight(font);
	var timeX = dc.getWidth()/2;
	var timeY = dc.getHeight()/2-corr;//poprzedni font by�o podzielone przez /1.1
	//var h = Graphics.getFontHeight(17);
	////	
	var hours = System.getClockTime().hour.format("%02d");
	var minutes = System.getClockTime().min.format("%02d");
	var mark=":";
	dc.drawText(timeX, timeY , font,hours+":"+minutes  , Graphics.TEXT_JUSTIFY_CENTER);	
	//dc.drawText(timeX, dc.getHeight()/2+corr/2 , font,minutes , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);		

	}
	
	function drawRungdn(dc,Background,Foreground,ThemeColor)	{
	//height = 30/170
	var x =  dc.getWidth()/2-1.2*rungdn.getWidth();
	var y = dc.getHeight()/2; //bitmap fixed height
    
    var fonth = dc.getFontHeight(font_min2)*0.8;
     
   	var txtx = dc.getWidth()/2;
   	var txty = dc.getHeight()/2;
   //var txty2 = dc.getHeight()/2+fonth;
   	var left = calcDeadLine();
   	var linetxt = "#RUNGDN#RUNGDN#RUNGDN#RUNGDN";//"#  R    U    N    G    D    N
   //	linetxt = "5.GDN MARATHON #RUNGDN";
/*dc.setColor(Background, ThemeColor);
   	dc.drawText(txtx, txty+dc.getFontHeight(font_min2)/3, 0, linetxt, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);	
 	*/
  dc.drawBitmap(0, txty-7, bargdn);
  dc.setColor(Foreground, Background); 
 txty +=5;
 

 
		dc.drawBitmap(txtx-1.5*rungdn.getWidth(), txty+fonth, rungdn);
   	
	dc.drawText(txtx, txty+fonth, font_min2, left[0], Graphics.TEXT_JUSTIFY_RIGHT);	
	dc.drawText(txtx, txty+2*fonth, font_min2, left[1], Graphics.TEXT_JUSTIFY_RIGHT);	
	dc.drawText(txtx, txty+3*fonth, font_min2,  left[2], Graphics.TEXT_JUSTIFY_RIGHT);
	var mintext = "Minut";
	
	var mindecpart = Math.floor(left[2]/10);
	var minpart = left[2]-10*mindecpart;
if( mindecpart<1)
	{
	switch(minpart) {
    case 1: mintext = "Minuta"; break;
    case 2: mintext = "Minuty"; break;
    case 3: mintext = "Minuty"; break;
    case 4: mintext = "Minuty"; break;
    default: mintext = "Minut"; break;
    }
		
	
	}
else if( mindecpart<2)
	{
	mintext = "Minut";
	}
	else
	 {
	switch(minpart) {
    case 2: mintext = "Minuty"; break;
    case 3: mintext = "Minuty"; break;
    case 4: mintext = "Minuty"; break;
    default: mintext = "Minut"; break;
    }	 
	 }
	var hourtxt = "Godzin";
	switch(left[1]) {
    case 1: hourtxt = "Godzina"; break;
    case 2: hourtxt = "Godziny"; break;
    case 3: hourtxt = "Godziny"; break;
    case 4: hourtxt = "Godziny"; break;
    case 22: hourtxt = "Godziny"; break;
    case 23: hourtxt = "Godziny"; break;
    case 24: hourtxt = "Godziny"; break;
    default: hourtxt = "Godzin"; break;
    }
    	
	   	dc.setColor(ThemeColor, Graphics.COLOR_TRANSPARENT);
	dc.drawText(txtx+5, txty+fonth, font_min2, "Dni", Graphics.TEXT_JUSTIFY_LEFT);	
	dc.drawText(txtx+5, txty+2*fonth, font_min2, hourtxt , Graphics.TEXT_JUSTIFY_LEFT);	
	dc.drawText(txtx+5, txty+3*fonth, font_min2,  mintext, Graphics.TEXT_JUSTIFY_LEFT);	

 	
	

	}
	function calcDeadLine() {

		var options = {
		    :year   => 2020,
		    :month  => 4, // 3.x devices can also use :month => Gregorian.MONTH_MAY
		    :day    => 19,
		    :hour   => 9,
		    :minute   => 00
		};
		var eventDate = Gregorian.moment(options);
		
		var offset = System.getClockTime().timeZoneOffset;

		var secs = eventDate.subtract(Time.now()).value()-offset;
			var days = 0;
			var hours = 0;
			var mins = 0;			
		if(secs>0)
		{
		//System.print(secs);
		var s2 = secs;
		 days = Math.floor(secs/(24*60*60));
		secs = secs - days*24*60*60;
		 hours = Math.floor(secs/(60*60));
		secs = secs - hours*60*60;
		 mins = Math.floor(secs/60);
		}
 
	
		
		
		return [days,hours,mins];
	
	}
	function drawVerticalBar(dc,Color)	{
	 var firstpoint  = [dc.getWidth()/2, 0];
	  var endpoint  = [dc.getHeight()/2, 0];
	  dc.setColor(Color, Graphics.COLOR_TRANSPARENT);
	  dc.setPenWidth(2);
	  dc.drawLine(dc.getWidth()*0.4, dc.getHeight()/10, dc.getWidth()*0.4,dc.getHeight()-dc.getHeight()/10);

	  
	  //dc.drawLine(50, 0, dc.getHeight()/2, 0);
	}
	
	function trueHours(hours)	{
	var truehours = hours;
	if(is24hour==false)
		{
		if(hours<0)
			{
			truehours = hours+12;
			}
		if(hours>12)
			{
			truehours = hours-12;
			}	
			if(truehours<10)
			{
			truehours =  "0"+truehours;
			}		
		}
		else
		
		{
		if(hours<0)
			{
			truehours = hours+24;
			}
		if(hours>=24)
			{
			truehours = hours-24;
			}	
			if(truehours<10)
			{
			truehours =  "0"+truehours;
			}
		}
		return truehours;	
	
	}
	function trueHours2(hours)	{
	var truehours = hours;

		if(hours<0)
			{
			truehours = hours+24;
			}
		if(hours>=24)
			{
			truehours = hours-24;
			}	
			if(truehours<10)
			{
			truehours =  "0"+truehours;
			}
		
		return truehours;	
	
	}	
	function drawDate(dc, Color)	{
	}
    // Handle the partial update event
    function onPartialUpdate( dc ) {
        // If we're not doing a full screen refresh we need to re-draw the background
        // before drawing the updated second hand position. Note this will only re-draw
        // the background in the area specified by the previously computed clipping region.
      //  if(!fullScreenRefresh) {
           // drawBackground(dc);
      //  }

  //      var clockTime = System.getClockTime();
  //      var secondHand = (clockTime.sec / 60.0) * Math.PI * 2;
      

        // Update the cliping rectangle to the new location of the second hand.
//        curClip = getBoundingBox( secondHandPoints );
//        var bboxWidth = curClip[1][0] - curClip[0][0] + 1;
 //       var bboxHeight = curClip[1][1] - curClip[0][1] + 1;
 //       dc.setClip(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);

        // Draw the second hand to the screen.
 //      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      //  dc.fillPolygon(secondHandPoints);
    }

    // Compute a bounding box from the passed in points
    function getBoundingBox( points ) {
        var min = [9999,9999];
        var max = [0,0];

        for (var i = 0; i < points.size(); ++i) {
            if(points[i][0] < min[0]) {
                min[0] = points[i][0];
            }

            if(points[i][1] < min[1]) {
                min[1] = points[i][1];
            }

            if(points[i][0] > max[0]) {
                max[0] = points[i][0];
            }

            if(points[i][1] > max[1]) {
                max[1] = points[i][1];
            }
        }

        return [min, max];
    }

    // Draw the watch face background
    // onUpdate uses this method to transfer newly rendered Buffered Bitmaps
    // to the main display.
    // onPartialUpdate uses this to blank the second hand from the previous
    // second before outputing the new one.
    function drawBackground(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        //If we have an offscreen buffer that has been written to
        //draw it to the screen.
        if( null != offscreenBuffer ) {
            dc.drawBitmap(0, 0, offscreenBuffer);
        }

        // Draw the date
        if( null != dateBuffer ) {
            // If the date is saved in a Buffered Bitmap, just copy it from there.
            dc.drawBitmap(0, (height / 4), dateBuffer );
        } else {
            // Otherwise, draw it from scratch.
//            drawDateString( dc, width / 2, height / 4 );
        }
    }

    // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
        isAwake = false;
        WatchUi.requestUpdate();
    }

    // This method is called when the device exits sleep mode.
    // Set the isAwake flag to let onUpdate know it should render the second hand.
    function onExitSleep() {
        isAwake = true;


//WatchUi.animate(myString, 50, WatchUi.ANIM_TYPE_LINEAR, 10, 200, 10, null);
        
    }
}
class SliderViewDelegate extends WatchUi.WatchFaceDelegate {
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
