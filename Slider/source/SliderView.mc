
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
using Toybox.Timer;
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
    var font_min1_a;
    var font_min2_a;
    var font_max_a;  
    var font_min1_aa;
    var font_min2_aa;
    var font_max_aa;        
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
    var BgColor;
    var BrColor;   
    var DtColor;
    var FgColor;
    var ShowBatteryBar;
    var ShowActivityBar;
    var StepCals;
    
    	var fontSize;
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

    // Initialize variables for this view
    function initialize() {
        WatchFace.initialize();
        screenShape = System.getDeviceSettings().screenShape;
        fullScreenRefresh = true;
        partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
         BrColor = 0xFFFFFF;
           BgColor = 0x000000;
		 FgColor = 0xFFFFFF;
		
		 DtColor = 0xFFFFFF; //Application.getApp().getProperty("DotColor");
		 StepCals = 1;//cals      
 //dndIcon = new WatchUi.Bitmap({:rezId=>Rez.Drawables.DoNotDisturbIcon,:locX=>10,:locY=>30});
        
    }

    // Configure the layout of the watchface for this device
    function onLayout(dc) {

        // Load the custom font we use for drawing the 3, 6, 9, and 12 on the watchface.
       // font1 = WatchUi.loadResource(Rez.Fonts.mari_font);
        font_min1 = WatchUi.loadResource(Rez.Fonts.mari_font_min);
        font_min2 = WatchUi.loadResource(Rez.Fonts.mari_font_min2);
        font_max = WatchUi.loadResource(Rez.Fonts.steelfish);

       // font_min1_aa = font_min1;
       // font_min2_aa = font_min2;
       // font_max_aa = font_max;
        
       // font_min1_a = WatchUi.loadResource(Rez.Fonts.mari_font_min_a);
       // font_min2_a = WatchUi.loadResource(Rez.Fonts.mari_font_min2_a);
       // font_max_a = WatchUi.loadResource(Rez.Fonts.steelfish_a);        
        //font_max = WatchUi.loadResource(Rez.Fonts.teko);

        // If this device supports the Do Not Disturb feature,
        // load the associated Icon into memory.

          

//WatchUi.animate( dndIcon, :locX, WatchUi.ANIM_TYPE_EASE_IN_OUT, 10, dc.getWidth() + 50, 160, null);
        // If this device supports BufferedBitmap, allocate the buffers we use for drawing

        curClip = null;

        screenCenterPoint = [dc.getWidth()/2, dc.getHeight()/2];
    }

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
         ShowActivityBar = false;
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
        if(Application.getApp().getProperty("ShowActivityBar") != null)
        {
        ShowActivityBar = Application.getApp().getProperty("ShowActivityBar");
        }   
        else
        	{
        	Application.getApp().setProperty("ShowBatteryBar", ShowActivityBar);
        	}   
        if(Application.getApp().getProperty("FontSize")==1)
        {
        	font_min=font_min2;
        	fontSize = 1;
        	
        }
         else
        	{
        	fontSize=0;//Application.getApp().setProperty("FontSize", 0);displaySeconds
        	font_min=font_min1;
        	}     
        if(Application.getApp().getProperty("displaySeconds") != null)
        {
        displaySeconds = Application.getApp().getProperty("displaySeconds");
        }   
        else
        	{
        	Application.getApp().setProperty("displaySeconds", displaySeconds);
        	}
 	//	font_min1 =  font_min1_aa;
    //   font_min2 = font_min2_aa;
    //   font_max = font_max_aa;
        if(Application.getApp().getProperty("FontSize")==1)
        {
        	font_min=font_min2;
        	fontSize = 1;
        	
        }
         else
        	{
        	fontSize=0;//Application.getApp().setProperty("FontSize", 0);displaySeconds
        	font_min=font_min1;
        	}   
        // We always want to refresh the full screen when we get a regular onUpdate call.
       

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
	function drawHorizontalBar(dc,Color)	{
	 var firstpoint  = [dc.getWidth()/2, 0];
	  var endpoint  = [dc.getHeight()/2, 0];
	  dc.setColor(Color, Graphics.COLOR_TRANSPARENT);
	  dc.setPenWidth(3);
	  dc.drawLine(dc.getWidth()/2-1, 0, dc.getWidth()/2-1,dc.getHeight());

	  
	  //dc.drawLine(50, 0, dc.getHeight()/2, 0);
	}
	function DrawInactivityBar(dc,Bg)
	{
	  dc.setColor(Bg, Bg);
	  var activitylevel = ActivityMonitor.getInfo().moveBarLevel ;
	 // activitylevel = ActivityMonitor.MOVE_BAR_LEVEL_MAX;
	  // 
	  if(activitylevel!=null)
	  {
	  
	  for (var i=0;i<activitylevel;i++)
	  {
	  dc.drawPoint(dc.getWidth()/2, dc.getHeight()-1-i*10);
	  }
	 }	
	}
	
	function drawBattery(dc,Bg) {
	
	var BbarY = 10;
	var BarWidth = 100;
	BatBarStatic = null;
		var myStats = System.getSystemStats();
		

	var ScreenCurvepoint = dc.getWidth()*0.42;
	if(System.getDeviceSettings().screenShape ==2)
		{
		BbarY = 1;
		ScreenCurvepoint = dc.getWidth()*0.6;
		}	
	//var step = //2*ScreenCurvepoint.toFloat()/dc.getWidth().toFloat();
	var step = ScreenCurvepoint/100f;
	var percentRed = 10*step;
	var percentYellow = 30*step;
	var percentGreen = 100*step;	
	var BatteryLevel = myStats.battery*step;	
	var charging=false;
			if(System.Stats has :charging)
		{
	charging = myStats.charging;
			}
	var BarStartX=dc.getWidth()/2+ScreenCurvepoint/2;


	
	if(charging == false)
	{
	if(BatteryLevel>=percentRed)
		{
		 dc.setColor(Graphics.COLOR_RED,Bg);
		  
			dc.drawLine(BarStartX, BbarY, BarStartX-percentRed ,BbarY);
			//System.println(BarStartX-percentRed);	
			if(BatteryLevel>=percentYellow)
			{
			dc.setColor( Graphics.COLOR_YELLOW,Bg);
			dc.drawLine(BarStartX-percentRed, BbarY, BarStartX-percentYellow ,BbarY);
			dc.setColor( Graphics.COLOR_GREEN,Bg);
				dc.drawLine(BarStartX-percentYellow, BbarY, BarStartX-BatteryLevel ,BbarY);
				
				if((BarStartX-BatteryLevel)<dc.getWidth()/2+2)
					{
					BatBarStatic=[dc.getWidth()/2+2,BbarY,BarStartX-BatteryLevel,BbarY,Graphics.COLOR_GREEN];
					//System.println(" bar param: "+BarStartX+"-"+BatteryLevel+" to "+(dc.getWidth()/2+2)+":)");	
					}
					
				
			}
			else
				{
				dc.setColor(Graphics.COLOR_YELLOW,Bg);
				dc.drawLine(BarStartX-percentRed, BbarY, BarStartX-BatteryLevel ,BbarY);
				}					
		}
	else
		{
		dc.setColor(Graphics.COLOR_RED,Bg);
		dc.drawLine(BarStartX, BbarY, BarStartX-BatteryLevel ,BbarY);
		}
	}
	else{
			dc.setColor(Graphics.COLOR_BLUE,Bg);
		dc.drawLine(BarStartX, BbarY, BarStartX-BatteryLevel ,BbarY);
				if((BarStartX-BatteryLevel)<dc.getWidth()/2+2)
					{
					BatBarStatic=[dc.getWidth()/2+2,BbarY,BarStartX-BatteryLevel,BbarY,Graphics.COLOR_BLUE];
					}		
	}
	
	 //dc.drawLine(dc.getWidth()/2, BbarY, 168 ,BbarY);
	}

	function drawMinutes(dc,Color)	{
	//height = 30/170
	var hcoord= 120/170f;
	var step = dc.getWidth()/120f;//rozpiêtoœæ to 120 min, step to 5 minut -->2px
	
	dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
		var	Dt = Application.getApp().getProperty("DotColor");
		
	//1 minuta to szeer/120
	//dc.drawText(100,10,0,step, Graphics.TEXT_JUSTIFY_CENTER);	
	///horus
	var font =  font_max;
	
	var timeX = dc.getWidth()/2;
	var timeY = dc.getHeight()*hcoord-Graphics.getFontHeight(font);//poprzedni font by³o podzielone przez /1.1
	//var h = Graphics.getFontHeight(17);
	////	
	var hours = System.getClockTime().hour.format("%02d");
	var minutes = System.getClockTime().min.format("%02d");
	// hours = "03";
	// minutes ="59";
	 var hoursdrawn=false;
						hourVecTxt = null;	
						minVecTxt=null;
						MinThick = null;
						MinPoint = null;
						//System.println("zeroing vectors1");
	//dc.drawText(100,10,0,minutes, Graphics.TEXT_JUSTIFY_CENTER);

	for(var i=0;i<120;i++)
	{
	var actmin = minutes.toNumber()-60+i;
	//dc.drawText(1+i,10+i,0,actmin, Graphics.TEXT_JUSTIFY_CENTER);	
	if(actmin%5==0)
		{
		dc.setColor(Dt , Graphics.COLOR_TRANSPARENT);
		dc.drawPoint(i*step, dc.getHeight()*hcoord);

					if(i*step>(dc.getWidth()/2-3) && i*step<(dc.getWidth()/2+3) && MinPoint==null) {
							MinPoint=[i*step,  dc.getHeight()*hcoord];
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
						//hourVecTxt = null;	
						if(i>60 and hoursdrawn==false)
							{
						dc.drawText((i-120)*step, timeY, font, trueHours(hours.toNumber()-1), Graphics.TEXT_JUSTIFY_CENTER );	
						dc.drawText((i-60)*step, timeY, font, trueHours(hours.toNumber()), Graphics.TEXT_JUSTIFY_CENTER );
						//hourVecTxt=[i*step,timeY,trueHours(hours.toNumber()),Graphics.TEXT_JUSTIFY_CENTER];
						 
						// dtVecNum=[(i+24-shifter)*step,dc.getHeight()*hcoord-3,today.day ,Graphics.TEXT_JUSTIFY_CENTER]; 
						
						dc.drawText(i*step, timeY, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_CENTER );
						
							
						dc.drawText((i+60)*step, timeY, font, trueHours(hours.toNumber()+2), Graphics.TEXT_JUSTIFY_CENTER );
						hoursdrawn = true;
							}
						else if(i==60 and hoursdrawn==false)
							{
							//System.println("i'=:"+i*step);
						dc.drawText((i-60)*step, timeY, font, trueHours(hours.toNumber()-1), Graphics.TEXT_JUSTIFY_CENTER );	
						dc.drawText((i)*step, timeY, font, trueHours(hours.toNumber()), Graphics.TEXT_JUSTIFY_CENTER );
						//hourVecTxt=[i*step,timeY,trueHours(hours.toNumber()),Graphics.TEXT_JUSTIFY_CENTER];
						dc.drawText((i+60)*step, timeY, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_CENTER );
						//dc.drawText((i+120)*step, timeY, font, trueHours(hours.toNumber()+1), Graphics.TEXT_JUSTIFY_CENTER );
						hoursdrawn = true;
							}					
						dc.setColor(Dt , Graphics.COLOR_TRANSPARENT);		
						dc.drawLine(i*step, dc.getHeight()*hcoord-5, i*step,dc.getHeight()*hcoord+5);	
						if(i*step>(dc.getWidth()/2-3) && i*step<(dc.getWidth()/2+3)) {
						MinThick=[i*step, dc.getHeight()*hcoord-5, i*step,dc.getHeight()*hcoord+5];
						}
						dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
						
						//hourVecTxt = null;
							if(i*step>(dc.getWidth()/2-25) && i*step<(dc.getWidth()/2+25) && hourVecTxt==null) {
							
								if(i*step>dc.getWidth()/2)	{
								//System.println("vectors set1");
									hourVecTxt=[i*step,timeY,trueHours(hours.toNumber()+1),Graphics.TEXT_JUSTIFY_CENTER];
								}
								if(i*step<=dc.getWidth()/2)	{
								//System.println("vectors set2");
									hourVecTxt=[i*step,timeY,trueHours(hours.toNumber()),Graphics.TEXT_JUSTIFY_CENTER];
								}							
							
							}				
					}
					//minutes job	
					dc.setColor(Dt , Graphics.COLOR_TRANSPARENT);			
					dc.drawLine(i*step, dc.getHeight()*hcoord-4, i*step,dc.getHeight()*hcoord+4);
						if(i*step>(dc.getWidth()/2-3) && i*step<(dc.getWidth()/2+3)) {
						MinThick=[i*step, dc.getHeight()*hcoord-4, i*step,dc.getHeight()*hcoord+4];
						}
					dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
					//minutes
					dc.drawText(i*step, dc.getHeight()*hcoord+3, font_min,mindisp , Graphics.TEXT_JUSTIFY_CENTER);
					//minVecTxt=null;
					if(i*step>(dc.getWidth()/2-10) && i*step<(dc.getWidth()/2+10) && minVecTxt==null) {
							minVecTxt=[i*step,dc.getHeight()*hcoord+3,mindisp,Graphics.TEXT_JUSTIFY_CENTER];
							}						

				}

		}
	
	}


	


	}
	function drawSteps(dc,Color,StepCals)	{
	//height = 30/170
	var hcoord= 160/170f;
		var info = ActivityMonitor.getInfo();
		var steps = info.steps;
		var mark = "";
		var scope = 500;
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
		var tMark = "C";
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
		//System.println(degree);
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


		steps = Math.floor(alt);
		}		
		var mod = Graphics.getFontHeight(font_min)*1;
		
		
		
		
		var scale = Math.floor(steps/1000);//ilekroków
		//horyzont
		var start = steps.toNumber()-2*scope;
		var stop = steps.toNumber()+2*scope;
		var liczbakroków = stop-start;
		var pikselinakrok = dc.getWidth()/liczbakroków.toFloat();
		//var step = (stop-start)/dc.getWidth();//1 pix to x kroków
	dc.setColor(Color , Graphics.COLOR_TRANSPARENT);	
		var	Dt = Application.getApp().getProperty("DotColor");	
		//dc.drawText(dc.getWidth()/2, dc.getHeight()*hcoord+8, 0,steps , Graphics.TEXT_JUSTIFY_CENTER);	
		
		StepThick = null;
		StepDot = null;
		StepTxt=null;
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
		dc.setColor(Dt , Graphics.COLOR_TRANSPARENT);	
		dc.drawPoint(i*pikselinakrok, dc.getHeight()*hcoord);
					if(i*pikselinakrok>(dc.getWidth()/2-3) && i*pikselinakrok<(dc.getWidth()/2+3) && StepDot==null) {
							StepDot=[i*pikselinakrok, dc.getHeight()*hcoord];
							}	
		
		

				 
			if(act%scope==0)
				{
				dc.drawLine(i*pikselinakrok, dc.getHeight()*hcoord-7, i*pikselinakrok,dc.getHeight()*hcoord+7);
					if(i*pikselinakrok>(dc.getWidth()/2-3) && i*pikselinakrok<(dc.getWidth()/2+3) && StepThick==null) {
							StepThick=[i*pikselinakrok, dc.getHeight()*hcoord-7, i*pikselinakrok,dc.getHeight()*hcoord+7];
					 }					
				dc.setColor(Color , Graphics.COLOR_TRANSPARENT);	
				dc.drawText(i*pikselinakrok+4, dc.getHeight()*hcoord-mod, font_min,act.toString()+mark , Graphics.TEXT_JUSTIFY_LEFT);
					var tw = dc.getTextWidthInPixels(act.toString()+mark, font_min);
					if(i*pikselinakrok+4<(dc.getWidth()/2+3) && i*pikselinakrok+4+tw>(dc.getWidth()/2+3))
					{
					StepTxt=[i*pikselinakrok+4, dc.getHeight()*hcoord-mod,  act.toString()+mark,Graphics.TEXT_JUSTIFY_LEFT];
					}
				dc.setColor(Dt , Graphics.COLOR_TRANSPARENT);		
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
	DateDot=null;
	DateThick = null;
	var hcoord= 26/170f;
	var step = dc.getWidth()/48f;//rozpiêtoœæ to 48 godzin, step to 5 minut 
	//var step = dc.getWidth()/120;//rozpiêtoœæ to 120 min, step to godzina -->5px
	dc.setColor(Color , Graphics.COLOR_TRANSPARENT);

						 dtVecTxt=null;
						 dtVecNum=null; 

	var hours = System.getClockTime().hour.format("%02d").toNumber();

	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT );

     var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
     var negoneDay = new Time.Duration(-Gregorian.SECONDS_PER_DAY);

     var tomorrow = Gregorian.info(Time.now().add(oneDay), Time.FORMAT_SHORT );

     var yesterday = Gregorian.info(Time.now().add(negoneDay), Time.FORMAT_SHORT );

	var	Dt = Application.getApp().getProperty("DotColor");	

	var font = font_min;
	var mod = Graphics.getFontHeight(font_min);

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
		dc.setColor(Dt , Graphics.COLOR_TRANSPARENT);
		dc.drawPoint(i*step, dc.getHeight()*hcoord);

					if(i*step>(dc.getWidth()/2-3) && i*step<(dc.getWidth()/2+3) && DateDot==null) {
							DateDot=[i*step,dc.getHeight()*hcoord];
							}			
		
			if(acthour%24==0)
				{
				dc.drawLine(i*step, dc.getHeight()*hcoord-10, i*step,dc.getHeight()*hcoord+10);

					if(i*step>(dc.getWidth()/2-3) && i*step<(dc.getWidth()/2+3) && DateThick==null) {
							DateThick=[i*step, dc.getHeight()*hcoord-10, i*step,dc.getHeight()*hcoord+10];
							}	

			
				}
				var mindisp = trueHours2(acthour).toNumber();
					if(mindisp==12)
						{
						
						if(thisistoday==true)
						{
						dc.setColor(Color , Graphics.COLOR_TRANSPARENT);
						//dc.drawLine(i*step, dc.getHeight()*hcoord-15, i*step,dc.getHeight()*hcoord+35);
						dc.drawText((i-shifter)*step, dc.getHeight()*hcoord-mod, font,dayOfWeek(yesterday.day_of_week) , Graphics.TEXT_JUSTIFY_CENTER);
						dc.drawText((i-shifter)*step, dc.getHeight()*hcoord-3, font,yesterday.day , Graphics.TEXT_JUSTIFY_CENTER);	
						

						
						dc.drawText((i+24-shifter)*step, dc.getHeight()*hcoord-mod, font,dayOfWeek(today.day_of_week) , Graphics.TEXT_JUSTIFY_CENTER);
						//myString.draw(dc);
						dc.drawText((i+24-shifter)*step, dc.getHeight()*hcoord-3, font,today.day , Graphics.TEXT_JUSTIFY_CENTER);
						
						 dtVecTxt=[(i+24-shifter)*step,dc.getHeight()*hcoord-mod,dayOfWeek(today.day_of_week),Graphics.TEXT_JUSTIFY_CENTER];
						 dtVecNum=[(i+24-shifter)*step,dc.getHeight()*hcoord-3,today.day ,Graphics.TEXT_JUSTIFY_CENTER]; 
 
						
						dc.drawText((i+48-shifter)*step, dc.getHeight()*hcoord-mod, font,dayOfWeek(tomorrow.day_of_week) , Graphics.TEXT_JUSTIFY_CENTER);
						dc.drawText((i+48-shifter)*step, dc.getHeight()*hcoord-3, font,tomorrow.day , Graphics.TEXT_JUSTIFY_CENTER);						
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
	function drawBatteryStatic(dc,bw) {
	//BatBarStatic;
	
		if(BatBarStatic != null) {
		dc.setPenWidth(bw);
		 dc.setColor(BatBarStatic[4] , Graphics.COLOR_TRANSPARENT);	
		
		dc.drawLine(BatBarStatic[0],BatBarStatic[1],BatBarStatic[2],BatBarStatic[3]);	
		//System.println("printing bar from: "+BatBarStatic[0]+" to "+BatBarStatic[2]);	
		}	
	}
	function drawDateStatic(dc,Color) {

	if(dtVecTxt != null && dtVecNum != null)
	{
						 dc.setColor(Color , Graphics.COLOR_TRANSPARENT);	
	//System.println("drawing date : "+dtVecTxt[2]+" on pos "+dtVecTxt[0]);
						dc.drawText(dtVecTxt[0], dtVecTxt[1], font_min,dtVecTxt[2] , dtVecTxt[3]);
						dc.drawText(dtVecNum[0], dtVecNum[1], font_min,dtVecNum[2] , dtVecNum[3]);
						
						
						
						
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
	function drawHoursStatic(dc,Color) {

						 dc.setColor(Color , Graphics.COLOR_TRANSPARENT);	//minVecTxt
	if(hourVecTxt != null)
	{
	
						dc.drawText(hourVecTxt[0], hourVecTxt[1], font_max,hourVecTxt[2] , hourVecTxt[3]);
					//	System.println("printing hour: "+hourVecTxt[2]+" on pos "+hourVecTxt[0]);
						}
	if(minVecTxt != null) {
						dc.drawText(minVecTxt[0], minVecTxt[1], font_min,minVecTxt[2] , minVecTxt[3]);
					//	System.println("printing minute: "+minVecTxt[2]+" on pos "+minVecTxt[0]);
						}
						
		 dc.setColor(DtColor , Graphics.COLOR_TRANSPARENT);		
 		if(MinPoint != null) {					
		dc.drawPoint(MinPoint[0], MinPoint[1]);
		//System.println("printing DOT: "+DateDot[1]+" on pos "+DateDot[0]);
		}		
		
		if(MinThick != null) {
		dc.drawLine(MinThick[0],MinThick[1],MinThick[2],MinThick[3]);	
		//System.println("printing thick: "+DateThick[2]+" on pos "+DateThick[0]);	
		}

					
						
						
						

	}
 function drawStepStatic(dc,Color) {

 //StepTxt
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
						dc.drawText(StepTxt[0], StepTxt[1], font_min,StepTxt[2] , StepTxt[3]);
					//	System.println("printing minute: "+minVecTxt[2]+" on pos "+minVecTxt[0]);
						}
	}
    // Handle the partial update event
    function onPartialUpdate( dc ) {
        // If we're not doing a full screen refresh we need to re-draw the background
        // before drawing the updated second hand position. Note this will only re-draw
        // the background in the area specified by the previously computed clipping region.
        //System.println("partial initialised");
        if(displaySeconds==true)
        {

            
        
         var seconds = System.getClockTime().sec;
        // System.println("update"+seconds);
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
   
    //var curY = Math.ceil(secs*dc.getHeight()/60.0);
    var step = Math.floor(dc.getHeight()/60.0);
    var modifier = (dc.getHeight()-step*60)/2;
    var curY = modifier+secs*step;
        var min = [dc.getWidth()/2-2,curY-11];
        var max = [dc.getWidth()/2+2,curY+11];



        return [min, max];
    }
    function getBoundingBox2(dc,secs  ) {
   
     var step = Math.floor(dc.getHeight()/60.0);
    var modifier = (dc.getHeight()-step*60)/2;
    var curY = modifier+secs*step;  
    //var curY = Math.ceil(secs*dc.getHeight()/60.0);
        var min = [dc.getWidth()/2-2,curY-6];
        var max = [dc.getWidth()/2+2,curY+6];



        return [min, max];
    }
 function getBoundingBox3(dc) {
var hcoord= 160/170f;   
    
        var min = [0,hcoord-10];
        var max = [dc.getWidth(),hcoord+7];



        return [min, max];
    }  
 function drawCurrentSteps(dc) {
 
var info = ActivityMonitor.getInfo();
var stepsss = info.steps;
var caloriesss = info.calories;





       curClip = getBoundingBox3(dc);
        var bboxWidth = curClip[1][0] - curClip[0][0];
        var bboxHeight = curClip[1][1] - curClip[0][1];
        dc.setClip(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);

//drawSteps(dc,FgColor,StepCals);
dc.clearClip();
System.println("You have taken: " + stepsss +
               " steps and burned: " + caloriesss + " calories!");	
 }
function drawSeconds(dc,Color,secs)	{

//drawCurrentSteps(dc);
if(secs==59)
{
fullScreenRefresh = true;
}

     var step = Math.floor(dc.getHeight()/60.0);
    var modifier = (dc.getHeight()-step*60)/2;
    var curY = modifier+secs*step;  
	var width = dc.getWidth()/2-1;
  
	    dc.setPenWidth(3);
	//erase previous
	dc.setColor(Color, BgColor);
	dc.drawLine(width, curY-11,width,curY+11);//zamalowanie poprzedniego
	

       curClip = getBoundingBox2(dc, secs );
        var bboxWidth = curClip[1][0] - curClip[0][0];
        var bboxHeight = curClip[1][1] - curClip[0][1];
        dc.setClip(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);


	dc.setColor(BgColor, BgColor);
	dc.drawLine(width, curY-6,width,curY+6);
	//drawBackground(dc);
		//drawMinutes(dc,FgColor);
		if(1)//fullScreenRefresh==false)
		{
		dc.setPenWidth(2);
		drawDateStatic(dc,FgColor);
		drawHoursStatic(dc,FgColor);
		drawStepStatic(dc,DtColor);
		drawBatteryStatic(dc,2);
		dc.setPenWidth(3);
		}
	dc.setColor(Color, BgColor);
	dc.drawLine(width, curY-2,width,curY+2);	
	 dc.clearClip();
//System.println("line-="+(curY-3)+"line+=:"+(curY+3));
//System.println("diff-="+((curY+2)-(curY-2))+"px");

	
}



    function drawBackground(dc) {

     	if(fullScreenRefresh==true)
     	{
     	fullScreenRefresh=false;
     	//switch fonts to aliased;

     	
     	 
     	System.println("drawin full bg");
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
		drawHorizontalBar(dc,BrColor);
		if(ShowActivityBar==true)
			{
			DrawInactivityBar(dc,BgColor);
			}  
		}   
    }

    // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
        isAwake = false;
        fullScreenRefresh = false;
        WatchUi.requestUpdate();
    }

    // This method is called when the device exits sleep mode.
    // Set the isAwake flag to let onUpdate know it should render the second hand.
    function onExitSleep() {
        isAwake = true;
         fullScreenRefresh = true;


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
