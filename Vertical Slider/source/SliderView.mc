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
 
	var fontSize;
	var tempUnits;
	 
    var BgColor;
    var BrColor;   
    var DtColor;
    var FgColor;
    var ShowBatteryBar;
    var StepCals;

	var displaySeconds;

	 var dtVecTxt ;
	 var dtVecNum ; 
	 var hourVecTxt;
	 var minVecTxt;
	 var DateDot;
	 var DateThick;
	var MinThick ;
	var MinPoint ;	 
	var	StepThick;
	var	StepDot;						
	var BatBarStatic;
	var StepTxt;	
	var ClockFont; 
	var ClockFont1; 
		var ClockFont2; 
		var ClockFont3;	
	 
	 
	 
	 
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
      //  font_min1 = WatchUi.loadResource(Rez.Fonts.mari_font_min);
       //  font_min2 = WatchUi.loadResource(Rez.Fonts.mari_font_min2);
       font_min = new[3];
       //teko mari cone
       font_min[0] = [WatchUi.loadResource(Rez.Fonts.mari_min1),WatchUi.loadResource(Rez.Fonts.mari_min2)];
       font_min[1] =  font_min[0];
       font_min[2] = [WatchUi.loadResource(Rez.Fonts.cone_min1),WatchUi.loadResource(Rez.Fonts.cone_min2)];   
                
        ClockFont1 = WatchUi.loadResource(Rez.Fonts.teko);
 		ClockFont2 = WatchUi.loadResource(Rez.Fonts.mari_font_max);
 		ClockFont3 = WatchUi.loadResource(Rez.Fonts.cone);

        // If this device supports the Do Not Disturb feature,
        // load the associated Icon into memory.


	}
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
         ShowBatteryBar = false; 
         fullScreenRefresh = true;
         
         is24hour = System.getDeviceSettings().is24Hour;
         tempUnits = System.getDeviceSettings().temperatureUnits ;
        if(Application.getApp().getProperty("BarColor") != null)
        {
        BrColor = Application.getApp().getProperty("BarColor");
        }
         else
        	{
        	Application.getApp().setProperty("BarColor", BrColor);
        	}    
        	//barColor = Barcolor;   
         BgColor = 0x000000;
		 FgColor = 0xFFFFFF;
		 DtColor = 0x555555; //Application.getApp().getProperty("DotColor");
		 StepCals = 1;//cals
        if(Application.getApp().getProperty("BackgroundColor") != null)
        {
        BgColor = Application.getApp().getProperty("BackgroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("BackgroundColor", BgColor);
        	}
        	 
      	if(Application.getApp().getProperty("ForegroundColor") != null)
        {
        FgColor = Application.getApp().getProperty("ForegroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("ForegroundColor", FgColor);
        	}      
        if(Application.getApp().getProperty("DotColor") != null)
        {
        DtColor = Application.getApp().getProperty("DotColor");
        
        }   
        else
        	{
        	Application.getApp().setProperty("DotColor", DtColor);
        	}
        if(Application.getApp().getProperty("StepCals") != null)
        {
        StepCals = Application.getApp().getProperty("StepCals");
        }   
        else
        	{
        	Application.getApp().setProperty("StepCals", StepCals);
        	}  
        if(Application.getApp().getProperty("ShowBatteryBar") != null)
        {
        ShowBatteryBar = Application.getApp().getProperty("ShowBatteryBar");
        }   
        else
        	{
        	Application.getApp().setProperty("ShowBatteryBar", ShowBatteryBar);
        	}    
        if(Application.getApp().getProperty("FontSize")==1)
        {
        	font1= font_min[0][1];
        	fontSize = 1;
        	
        }
         else
        	{
        	fontSize=0;//Application.getApp().setProperty("FontSize", 0);
        	font1=font_min[0][0];
        	} 
        if(Application.getApp().getProperty("displaySeconds") != null)
        {
        displaySeconds = Application.getApp().getProperty("displaySeconds");
        }   
        else
        	{
        	Application.getApp().setProperty("displaySeconds", displaySeconds);
        	}  

		switch ( Application.getApp().getProperty("FontName") ) {
		    case 0:
		     ClockFont =ClockFont1; //teko
		     font1=font_min[0][fontSize];
		    break;
		    case 1:
		     ClockFont =ClockFont2; //mari
		     font1=font_min[1][fontSize];
		    break;
		    case 2: 
		     ClockFont =ClockFont3; //cone
		     font1=font_min[2][fontSize];
		    break;
		    default:
		    // If all else fails
		    break;
		}        	        	      	           	     	   
        // We always want to refresh the full screen when we get a regular onUpdate call.
        if( partialUpdatesAllowed) {
        dc.clearClip();
        }		
 		drawBackground(dc);
	
/*****************************************************/

        // Fill the entire background with Black.
      //  var bgdc = dc.getDc();
     //   dc.drawBitmap(0, 0, offscreenBuffer);




        if( partialUpdatesAllowed && displaySeconds==true) {
        dc.clearClip();
       
		         var seconds = System.getClockTime().sec;
		           //System.println("update "+seconds);
				var minutes = System.getClockTime().min;
				if(minutes%2!=0)
					{
							seconds = 60-seconds;
						} 
		      drawSeconds(dc,BrColor, seconds);
        } else if ( isAwake ) {
            // Otherwise, if we are out of sleep mode, draw the second hand
            // directly in the full update method.
           // dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
           // secondHand = (clockTime.sec / 60.0) * Math.PI * 2;
        }

      

    }

    // Draw the date string into the provided buffer at the specified location
	function drawVerticalBar(dc,Color)	{

	  dc.setColor(Color, Graphics.COLOR_TRANSPARENT);
	  dc.setPenWidth(3);
	  dc.drawLine(0, dc.getHeight()/2-1, dc.getWidth(),dc.getHeight()/2-1);
	   dc.setPenWidth(1);
	  //dc.drawLine(50, 0, dc.getHeight()/2, 0);
	}
	
	function drawBattery(dc,Bg) {
	
	var BbarX = 10;
	var BarWidth = 100;
	
		var myStats = System.getSystemStats();
		var BatteryLevel = myStats.battery;	
	var percentRed = 10;
	var percentYellow = 30;
	var percentGreen = 100;
	var BarStartY=dc.getHeight()/2+BarWidth/2;
	var charging=false;
			if(System.Stats has :charging)
		{
	charging = myStats.charging;
			}	
		if(System.getDeviceSettings().screenShape ==2)
		{
		//BbarX = 10;
		BarStartY=dc.getHeight()/2+BarWidth/2;
		}
	
	if(charging == false)
	{
	if(BatteryLevel>=percentRed)
		{
		 dc.setColor(Graphics.COLOR_RED,Bg);
		  
			dc.drawLine(BbarX, BarStartY, BbarX ,BarStartY-percentRed);
			//System.println(BarStartX-percentRed);	
			if(BatteryLevel>=percentYellow)
			{
			dc.setColor( Graphics.COLOR_YELLOW,Bg);
			dc.drawLine(BbarX, BarStartY-percentRed, BbarX, BarStartY-percentYellow);
			dc.setColor( Graphics.COLOR_GREEN,Bg);
				dc.drawLine(BbarX, BarStartY-percentYellow, BbarX, BarStartY-BatteryLevel);
				
					if((BarStartY-BatteryLevel)<dc.getHeight()/2+2)
					{
					BatBarStatic=[BbarX,dc.getHeight()/2+2,BbarX,BarStartY-BatteryLevel,Graphics.COLOR_GREEN];
					//System.println(" bar param: "+BarStartY+"-"+BatteryLevel+" to "+(dc.getHeight()/2+2)+":)");	
					}
			}
			else
				{
				dc.setColor(Graphics.COLOR_YELLOW,Bg);
				dc.drawLine(BbarX, BarStartY-percentRed, BbarX, BarStartY-BatteryLevel);
				}					
		}
	else
		{
		dc.setColor(Graphics.COLOR_RED,Bg);
		dc.drawLine(BbarX, BarStartY, BbarX, BarStartY-BatteryLevel );
		}
	}	
	else{
			dc.setColor(Graphics.COLOR_BLUE ,Bg);
		dc.drawLine(BbarX, BarStartY, BbarX, BarStartY-BatteryLevel );
					if((BarStartY-BatteryLevel)<dc.getHeight()/2+2)
					{
					BatBarStatic=[BbarX,dc.getHeight()/2-2,BbarX,BarStartY-BatteryLevel,Graphics.COLOR_BLUE];
					//System.println(" bar param: "+BarStartX+"-"+BatteryLevel+" to "+(dc.getWidth()/2+2)+":)");	
					}
	}
	
	 //dc.drawLine(dc.getWidth()/2, BbarY, 168 ,BbarY);
	}	
	function drawMinutes(dc,Color)	{
	//height = 30/170
	var hcoord= 105/170f;
	var step = dc.getHeight()/120f;//rozpiętość to 120 min, step to 5 minut -->2px
	
	dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
	 
		
	//1 minuta to szeer/120
	//dc.drawText(100,10,0,step, Graphics.TEXT_JUSTIFY_CENTER);	
	///horus
	var font =  ClockFont;
	var AxeX = dc.getWidth()*hcoord;hcoord= 105/170f;
	var timeX = dc.getWidth()*hcoord -9;
	var timeY = dc.getHeight()*hcoord-Graphics.getFontHeight(font)/1.1;
	//var h = Graphics.getFontHeight(17);
	////	
	var hours = System.getClockTime().hour.format("%02d");
	var minutes = System.getClockTime().min.format("%02d");
	// hours =23;
	// minutes =49;
	
	var hoursdrawn=false;
							hourVecTxt = null;	
						minVecTxt=null;
						MinThick = null;
						MinPoint = null;
	//dc.drawText(100,10,0,minutes, Graphics.TEXT_JUSTIFY_CENTER);

	for(var i=0;i<120;i++)
	{
	var actmin = minutes.toNumber()-60+i;
	//dc.drawText(1+i,10+i,0,actmin, Graphics.TEXT_JUSTIFY_CENTER);	
	if(actmin%5==0)
		{
		dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);
		dc.drawPoint( dc.getWidth()*hcoord,i*step);
					if(i*step>(dc.getHeight()/2-3) && i*step<(dc.getHeight()/2+3) && MinPoint==null) {
							MinPoint=[ dc.getWidth()*hcoord,i*step];
							}		
		dc.setColor(Color , Graphics.COLOR_TRANSPARENT);		
			if(actmin%15==0)
				{
				var mindisp = actmin;
				if(actmin <0)
					{
				mindisp = 	actmin+60;
					}
				if(actmin >60)
					{
					mindisp = 	actmin-60;
					}
				if(actmin ==60)
					{
					mindisp = 	0;
					}
					if(mindisp==0)
						{
						if(i>60 and hoursdrawn==false)
							{
							

						dc.drawText(timeX,(i-120-2)*step, font, trueHours(hours.toNumber()-1), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER );
						dc.drawText(timeX,(i-60-2)*step, font, trueHours(hours.toNumber()), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER );
						//dc.drawLine(AxeX-4,(i-60)*step, AxeX+4, (i-60)*step);	
						dc.drawText(timeX,(i-0-2)*step, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER );
						dc.drawText(timeX,(i+60-2)*step, font, trueHours(hours.toNumber()+2), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER );
				
						hoursdrawn = true;
							}
						else if(i==60 and hoursdrawn==false)
							{
						dc.drawText(timeX,(i-60-2)*step, font, trueHours(hours.toNumber()-1), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER );
						dc.drawText(timeX,(i-0-2)*step, font, trueHours(hours.toNumber()), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER );
						dc.drawText(timeX,(i+60-2)*step, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER );						
						//dc.drawText(timeX,(i+90)*step, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_CENTER );
						//dc.drawText(timeX,(i-30)*step, font, trueHours(hours.toNumber()-1), Graphics.TEXT_JUSTIFY_CENTER );	
						//dc.drawText(timeX,(i+30)*step, font, trueHours(hours.toNumber()), Graphics.TEXT_JUSTIFY_CENTER );
						//dc.drawText(timeX,(i+90)*step, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_CENTER );
						//dc.drawText((i+120)*step, timeY, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_CENTER );
						hoursdrawn = true;
							}					
							dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);		
						//dc.drawLine(AxeX-26,i*step, AxeX+6, i*step);	
						dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
						var fh=dc.getFontHeight(font)/2;
							if(i*step>(dc.getHeight()/2-fh) && i*step<(dc.getHeight()/2+fh) && hourVecTxt==null) {
							
								if(i*step>dc.getHeight()/2)	{

									hourVecTxt=[timeX,(i-0-2)*step,trueHours(hours.toNumber()+1),Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER];
								//System.println("vectors set+1");
								//System.println("printing hour: "+trueHours(hours.toNumber()+1)+" on"+i*step);									
								}
								if(i*step<=dc.getHeight()/2)	{
								//System.println("vectors set2");
									hourVecTxt=[timeX,(i-0-2)*step,trueHours(hours.toNumber()),Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER];
								 //System.println("vectors set: "+dc.getFontHeight(font));
								//System.println("printing hour: "+trueHours(hours.toNumber())+" on"+i*step);	
											//	dc.setColor(Graphics.COLOR_BLUE , Graphics.COLOR_TRANSPARENT);
											//	dc.setPenWidth(5);
											//	dc.drawCircle(120, i*step, 10);
											//	dc.setPenWidth(2);
								}							
							
							}										
						}	
						dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);			
					dc.drawLine(AxeX-4,i*step, AxeX+4, i*step);	
					
											if(i*step>(dc.getHeight()/2-3) && i*step<(dc.getHeight()/2+3)) {
						MinThick=[AxeX-4,i*step, AxeX+4, i*step];
						}
												//hourVecTxt = null;

						
						
						
					dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
					//minutes
					dc.drawText(AxeX+6,i*step-Graphics.getFontHeight(font1)/2,   font1,mindisp , Graphics.TEXT_JUSTIFY_LEFT);	
					if(i*step>(dc.getHeight()/2-10) && i*step<(dc.getHeight()/2+10) && minVecTxt==null) {
							minVecTxt=[AxeX+6,i*step-Graphics.getFontHeight(font1)/2,   mindisp , Graphics.TEXT_JUSTIFY_LEFT];
							}						
				}
		}
	
	}


	


	}
	function drawSteps(dc,Color,StepCals)	{
	//height = 30/170
	var hcoord= 156/170f;
	var AxeX =  dc.getWidth()*hcoord;
		var info = ActivityMonitor.getInfo();
		
		//var temp = ActivityMonitor.getInfo().temperature;
		var steps = info.steps;
		var mark = "";
		var scope = 500;//horyzont
		if(StepCals==1)
		{
		steps = info.calories;
		//mark="c";
		}
		if(StepCals==0)
		{
		steps = info.steps;
		//mark="s";
		}
		if(StepCals==2)
		{
		var temp=-55;
		if(Toybox has :SensorHistory)
		{
			if(Toybox.SensorHistory has :getTemperatureHistory)
			{
			temp = Toybox.SensorHistory.getTemperatureHistory({}).next().data.toLong();
			}
		}
		var tMark = "'C";
		if(tempUnits==System.UNIT_STATUTE)
			{
			//temp = Math.floor(temp*1.8+32);
			 temp = Math.floor(temp*1.8+32).toNumber();
			tMark = "F";
			}
			steps = temp;//Math.floor(temp);
		scope = 5;
		//var degree =StringUtil.utf8ArrayToString("c2b0");//'°';
		var degree = StringUtil.utf8ArrayToString([0xC2,0xB0]);
		
		mark= degree+tMark;
		mark= tMark;
		//System.println(mark);
		//mark = 
		}			
		if(StepCals==3)
		{
		var alt =-500;
		
		scope = 50;
		mark="m";
		if(Toybox has :SensorHistory)
		{		
			if(Toybox.SensorHistory has :getElevationHistory)
			{
			alt = Toybox.SensorHistory.getElevationHistory({}).next().data.toLong();
			}
		}
				if(tempUnits==System.UNIT_STATUTE)
			{
			//temp = Math.floor(temp*1.8+32);
			 alt = alt*3.2808399;
			mark = "ft";
			}


		steps = alt;
		}		
		var mod = Graphics.getFontHeight(font1)*1;
		
		
		
		
		var scale = Math.floor(steps/1000);//ilekroków
		//steps=5001;
		var start = steps.toNumber()-2*scope;
		var stop = steps.toNumber()+2*scope;
		var liczbakroków = stop-start;
		var pikselinakrok = dc.getHeight()/liczbakroków.toFloat();
		StepThick = null;
		StepDot = null;
		StepTxt=null;		
		//var step = (stop-start)/dc.getWidth();//1 pix to x kroków
	dc.setColor(Color , Graphics.COLOR_TRANSPARENT);	
		 
		//dc.drawText(dc.getWidth()/2, dc.getHeight()*hcoord+8, 0,steps , Graphics.TEXT_JUSTIFY_CENTER);	
		var act = 0;
	for(var i=0;i<liczbakroków;i++)
	{
		act = start+i;
		if(act<0 and StepCals<2)
		{
		act=0;
		}
		else
		{
	//var acthour = hours.toNumber()-24+i;
	//dc.drawText(1+i,10+i,0,actmin, Graphics.TEXT_JUSTIFY_CENTER);	
	
	if(act%(scope/5)==0)
		{
		dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);	
		dc.drawPoint(AxeX,i*pikselinakrok);
							if(i*pikselinakrok>(dc.getHeight()/2-3) && i*pikselinakrok<(dc.getHeight()/2+3) && StepDot==null) {
							StepDot=[AxeX,i*pikselinakrok];
							}
		

				 
			if(act%scope==0)
				{

				dc.drawLine(AxeX-7,i*pikselinakrok, AxeX+7, i*pikselinakrok);
									if(i*pikselinakrok>(dc.getHeight()/2-3) && i*pikselinakrok<(dc.getHeight()/2+3) && StepThick==null) {
							StepThick=[AxeX-7,i*pikselinakrok, AxeX+7, i*pikselinakrok];
					 }	
				dc.setColor(Color , Graphics.COLOR_TRANSPARENT);	
				dc.drawText(AxeX-5,i*pikselinakrok+4, font1,act.toString()+mark, Graphics.TEXT_JUSTIFY_CENTER);	
				dc.setColor(Graphics.COLOR_GREEN , Graphics.COLOR_TRANSPARENT);	
				
					var th = dc.getFontHeight(font1);
					//dc.drawCircle(AxeX-5,i*pikselinakrok+4+th/2,10);
					//System.println("Font height ="+th);
					//var th = dc.getTextDimensions(act.toString()+mark, font_min);
					if((i*pikselinakrok+4+th)>=(dc.getHeight()/2-3) && (i*pikselinakrok+4)<=(dc.getHeight()/2+3) && StepTxt==null)
					{
					StepTxt=[AxeX-5,i*pikselinakrok+4, act.toString()+mark, Graphics.TEXT_JUSTIFY_CENTER];
					}				
				dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);		
				}
			
			
		}			
					
				
		}
	
	}		
			
	
	


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
		function trueSeconds(number)	{
	var trueseconds = number;

		if(number<0)
			{
			trueseconds = number+60;
			}
		if(number>=60)
			{
			trueseconds = number-60;
			}	
			if(trueseconds<10)
			{
			trueseconds =  "0"+trueseconds;
			}
		
		return trueseconds;	
	
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
	function drawDate(dc, Color)	{
	//height = 30/170
	// System.println(Color);
	var hcoord= 26/170f;
	var AxeX = dc.getWidth()*hcoord;
	var step = dc.getHeight()/48f;//rozpiętość to 48 godzin, step to 5 minut 
	//var step = dc.getWidth()/120;//rozpiętość to 120 min, step to godzina -->5px
	dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
	//1 minuta to szeer/120
						 dtVecTxt=null;
						 dtVecNum=null; 
	//var hvcoord= 74/170f;
	var hours =System.getClockTime().hour.format("%02d").toNumber();
	 
	//var moment = Time.now();
	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    //var toda = new Time.Moment(Time.today().value());
     var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
     var negoneDay = new Time.Duration(-Gregorian.SECONDS_PER_DAY);

     var tomorrow = Gregorian.info(Time.now().add(oneDay), Time.FORMAT_SHORT);

     var yesterday = Gregorian.info(Time.now().add(negoneDay), Time.FORMAT_SHORT);
	 
	
	var font = 0;
	var mod = Graphics.getFontHeight(0)/2;

	//var timeX = dc.getWidth()/2;
	//var timeY = dc.getHeight()*hvcoord-font;
	////	
	//var minutes = System.getClockTime().min.format("%02d");
	//dc.drawText(100,10,0,minutes, Graphics.TEXT_JUSTIFY_CENTER);	
		var thisistoday=true;
		var shifter = 0;
		if(hours>12)
		{
		shifter=24;
		}
	for(var i=0;i<48;i++)
	{
	var acthour = hours.toNumber()-24+i;
	//dc.drawText(1+i,10+i,0,actmin, Graphics.TEXT_JUSTIFY_CENTER);	

	if(acthour%2==0)
		{
		dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);
		dc.drawPoint(AxeX,i*step);

					if(i*step>(dc.getHeight()/2-3) && i*step<(dc.getHeight()/2+3) && DateDot==null) {
							DateDot=[AxeX,i*step ];
							}			
		
			if(acthour%24==0)
				{
				dc.drawLine(AxeX-10,i*step, AxeX+10, i*step);
					if(i*step>(dc.getWidth()/2-3) && i*step<(dc.getWidth()/2+3) && DateThick==null) {
							DateThick=[AxeX-10,i*step, AxeX+10, i*step];
							}				
			
				}
				var mindisp = trueHours2(acthour).toNumber();
					if(mindisp==12)
						{
						
						if(thisistoday==true)
						{
						dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
						//dc.drawLine(i*step, dc.getHeight()*hcoord-15, i*step,dc.getHeight()*hcoord+35);
						dc.drawText(AxeX-2,(i-shifter)*step-mod , font1,dayOfWeek(yesterday.day_of_week) , Graphics.TEXT_JUSTIFY_RIGHT);
						dc.drawText(AxeX+2,(i-shifter)*step-mod, font1,yesterday.day , Graphics.TEXT_JUSTIFY_LEFT);	
						

						
						dc.drawText(AxeX-2,(i+24-shifter)*step-mod , font1,dayOfWeek(today.day_of_week) , Graphics.TEXT_JUSTIFY_RIGHT);
						//myString.draw(dc);
						dc.drawText(AxeX+2,(i+24-shifter)*step-mod,  font1,today.day , Graphics.TEXT_JUSTIFY_LEFT);
						
						 dtVecTxt=[AxeX-2,(i+24-shifter)*step-mod , dayOfWeek(today.day_of_week) , Graphics.TEXT_JUSTIFY_RIGHT];
						 dtVecNum=[AxeX+2,(i+24-shifter)*step-mod,  today.day , Graphics.TEXT_JUSTIFY_LEFT]; 						
						
						dc.drawText(AxeX-2,(i+48-shifter)*step-mod, font1,dayOfWeek(tomorrow.day_of_week) , Graphics.TEXT_JUSTIFY_RIGHT);
						dc.drawText(AxeX+2,(i+48-shifter)*step-mod, font1,tomorrow.day , Graphics.TEXT_JUSTIFY_LEFT);						
						thisistoday = false;
						}
						else
							{
							//dc.drawText(i*step, dc.getHeight()*hcoord-26, 0,tomorrow.day_of_week , Graphics.TEXT_JUSTIFY_CENTER);
							//dc.drawText(i*step, dc.getHeight()*hcoord+1, 0,tomorrow.day , Graphics.TEXT_JUSTIFY_CENTER);						
							}	
									
						}				
					
					//dc.drawText(i*step, dc.getHeight()*hcoord+8, 0,mindisp , Graphics.TEXT_JUSTIFY_CENTER);		
				
		}
	
	}




	}


	function drawBatteryStatic(dc,bw,secs) {
	//BatBarStatic;
	
		if(BatBarStatic != null and (secs>52 or secs<7)) {
		dc.setPenWidth(bw);
		 dc.setColor(BatBarStatic[4] , Graphics.COLOR_TRANSPARENT);	
		
		dc.drawLine(BatBarStatic[0],BatBarStatic[1],BatBarStatic[2],BatBarStatic[3]);	
		//System.println("printing bar from: "+BatBarStatic[0]+" to "+BatBarStatic[2]);	
		}	
	}
	function drawDateStatic(dc,Color,seconds) {

	if(dtVecTxt != null && dtVecNum != null && (seconds <15 or seconds >45) )
	{
						 dc.setColor(Color , Graphics.COLOR_TRANSPARENT);	
	//System.println("drawing date : "+dtVecTxt[2]+" on pos "+dtVecTxt[0]);
						dc.drawText(dtVecTxt[0], dtVecTxt[1], font1,dtVecTxt[2] , dtVecTxt[3]);
						dc.drawText(dtVecNum[0], dtVecNum[1], font1,dtVecNum[2] , dtVecNum[3]);
						
						
						
						
}
 dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);		
 		if(DateDot != null) {					
		dc.drawPoint(DateDot[0], DateDot[1]);
		//System.println("printing DOT: "+DateDot[1]+" on pos "+DateDot[0]);
		}		
		
		if(DateThick != null) {
		dc.drawLine(DateThick[0],DateThick[1],DateThick[2],DateThick[3]);	
		//System.println("printing thick: "+DateThick[2]+" on pos "+DateThick[0]);	
		}							

	}
	function drawHoursStatic(dc,Color,seconds) {

							//minVecTxt
							// dc.setColor(Graphics.COLOR_WHITE , Graphics.COLOR_WHITE);
							 
	if(hourVecTxt != null and (seconds >14 and seconds <47))
	{//dc.clear();
	 dc.setColor(Color , BgColor);
						dc.drawText(hourVecTxt[0], hourVecTxt[1], ClockFont,hourVecTxt[2] , hourVecTxt[3]);
						
						}
	if((seconds >32 and seconds <42) or(seconds>12 and seconds<21))
	{
	dc.setColor(Color , BgColor);
		if(minVecTxt != null) {
		dc.drawText(minVecTxt[0], minVecTxt[1], font1,minVecTxt[2] , minVecTxt[3]);
							//System.println("printing minute: "+minVecTxt[2]+" on pos "+minVecTxt[1]);
				}
							
			 dc.setColor(DtColor , BgColor);		
	 	if(MinPoint != null ) {					
			dc.drawPoint(MinPoint[0], MinPoint[1]);
			//System.println("printing DOT: "+MinPoint[1]+" on pos "+MinPoint[0]);
			}		
			
		if(MinThick != null) {
			dc.drawLine(MinThick[0],MinThick[1],MinThick[2],MinThick[3]);	
			//System.println("printing thick: "+MinThick[2]+" on pos "+MinThick[1]);	->   35 <-28-46
			}
		}

					
						
						
						

	}
 function drawStepStatic(dc,Color,secs) {

 //StepTxt
 if(secs>52 or secs<7)
 {
		 dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
 		if(StepDot != null) {					
		dc.drawPoint(StepDot[0], StepDot[1]);
		//System.println("printing DOT: "+DateDot[1]+" on pos "+DateDot[0]);
		}		
		
		if(StepThick != null) {
		dc.drawLine(StepThick[0],StepThick[1],StepThick[2],StepThick[3]);	
		//System.println("printing thick: "+DateThick[2]+" on pos "+DateThick[0]);	
		}							
	if(StepTxt != null) {
	 dc.setColor(FgColor , Graphics.COLOR_TRANSPARENT);	
						dc.drawText(StepTxt[0], StepTxt[1], font1,StepTxt[2] , StepTxt[3]);
					//	System.println("printing steps txt: "+StepTxt[2]+" on pos "+StepTxt[1]);
						}
	}
}

	
    // Handle the partial update event
    function onPartialUpdate( dc ) {
        // If we're not doing a full screen refresh we need to re-draw the background
        // before drawing the updated second hand position. Note this will only re-draw
        // the background in the area specified by the previously computed clipping region.
        
        if(displaySeconds==true)
        {

            
        
         var seconds = System.getClockTime().sec;
       // System.println("second: "+seconds);
		var minutes = System.getClockTime().min;
		if(minutes%2!=0)
			{
					seconds = 60-seconds;
				}         
       curClip = getBoundingBox(dc, seconds );
        var bboxWidth = curClip[1][0] - curClip[0][0];
        var bboxHeight = curClip[1][1] - curClip[0][1];
        dc.setClip(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);
        	   // dc.setPenWidth(1);
	//erase previous
	//dc.setColor(Graphics.COLOR_PINK, BgColor);
 		//dc.drawRectangle(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);
      drawSeconds(dc,BrColor, seconds);
      //         BgColor=Bg;
     //		BrColor = Barcolor;
     }
    }

    // Compute a bounding box from the passed in points
    function getBoundingBox(dc,secs  ) {
   
   	     var step = Math.floor(dc.getWidth()/60.0);
    var modifier = (dc.getWidth()-step*60)/2;
    var curX = modifier+secs*step; 
   
    //var curX = Math.ceil(secs*dc.getWidth()/60.0);
        var min = [curX-11,dc.getHeight()/2-2];
        var max = [curX+11,dc.getHeight()/2+2];



        return [min, max];
    }
    function getBoundingBox2(dc,secs  ) {
   
    	     var step = Math.floor(dc.getWidth()/60.0);
    var modifier = (dc.getWidth()-step*60)/2;
    var curX = modifier+secs*step; 
    //var curX = Math.ceil(secs*dc.getWidth()/60.0);
        var min = [curX-6,dc.getHeight()/2-2];
        var max = [curX+6,dc.getHeight()/2+2];



        return [min, max];
    }    
function drawSeconds(dc,Color,secs)	{
//System.println("drawin seconds: "+secs);
	//height = 30/170
	
	     var step = Math.floor(dc.getWidth()/60.0);
    var modifier = (dc.getWidth()-step*60)/2;
    var curX = modifier+secs*step;  
	
//	var curX = secs*dc.getWidth()/60;
	var height = dc.getHeight()/2-1;
  
	    dc.setPenWidth(3);
	//erase previous
	dc.setColor(Color, BgColor);
	dc.drawLine( curX-10,height,curX+10,height);

       curClip = getBoundingBox2(dc, secs );
        var bboxWidth = curClip[1][0] - curClip[0][0];
        var bboxHeight = curClip[1][1] - curClip[0][1];
        dc.setClip(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);


	dc.setColor(BgColor, BgColor);
	dc.drawLine(curX-6,height,curX+6,height);
	//drawBackground(dc);
		//drawMinutes(dc,FgColor);
		if(1)//fullScreenRefresh==false)
		{
		dc.setPenWidth(2);
		drawDateStatic(dc,FgColor,secs);
		drawHoursStatic(dc,FgColor,secs);
		drawStepStatic(dc,DtColor,secs);
		drawBatteryStatic(dc,2,secs);
		dc.setPenWidth(3);
		}
	dc.setColor(Color, BgColor);
	dc.drawLine(curX-2,height,curX+2,height);

//System.println("line-="+(curY-3)+"line+=:"+(curY+3));
//System.println("diff-="+((curY+2)-(curY-2))+"px");		
}

    // Draw the watch face background
    // onUpdate uses this method to transfer newly rendered Buffered Bitmaps
    // to the main display.
    // onPartialUpdate uses this to blank the second hand from the previous
    // second before outputing the new one.
    function drawBackground(dc) {

    	if(1)//fullScreenRefresh==true)
     	{//switch fonts to aliased;
		//System.println("drawin full bg");
     	 
     	 
        dc.setColor(BgColor, BgColor);
		dc.clear();
		dc.setColor(BgColor, BgColor);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		
		dc.setPenWidth(2);

/**************Draw WatchFace*************************/
		drawMinutes(dc,FgColor);
		drawDate(dc,FgColor);
		drawSteps(dc,FgColor,StepCals);
		if(ShowBatteryBar==true)
			{
			drawBattery(dc,BgColor);
			}
		drawVerticalBar(dc,BrColor);
 			} 
    }

    // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
        isAwake = false;
        WatchUi.requestUpdate();
        fullScreenRefresh=false;
    }

    // This method is called when the device exits sleep mode.
    // Set the isAwake flag to let onUpdate know it should render the second hand.
    function onExitSleep() {
        isAwake = true;
        fullScreenRefresh=true;


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
