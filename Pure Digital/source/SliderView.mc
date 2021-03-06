

using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Application.Storage;


var partialUpdatesAllowed = false;

class SliderView extends WatchUi.WatchFace
{
    var isAwake;


    var curClip;
    var screenCenterPoint;
   // var screenHalfPoint;
    var fullScreenRefresh;
    var is24hour;
  
	var fontSize;
	var tempUnits;
	 
    public var BgColor;
    public var BrColor;   
    public var DtColor;
    public var FgColor;
    public var ThemeColor;
    public var SecondsColor;
    public var HoursColor;


 	public var chosenFields;
	public var displaySeconds;
	public var btStatus;

	var bgRedrawRequested;	
	var offlineFieldValues;//;// = new[6];
	var offCalcBuffer;
	var offCalcField1;
	var offCalcField6;
	var sRenderer;
	var tRenderer;
	var iKeeper;
	var hrBox;
	var curHour;
	var curMinute;
	//fonts
	var font_hours;
    var font_minutes;
    var font_date;
    var font_data;
    var fheights;
    var sWidth;
    var sHeight;
    var phoneConnectionStatus;
	

    function initialize() {
    //largefont 
        WatchFace.initialize();

        fullScreenRefresh = true;
        offlineFieldValues = new[15];
         fheights = new[4];
          is24hour = System.getDeviceSettings().is24Hour;
         tempUnits = System.getDeviceSettings().temperatureUnits ;
      

       
     
        partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
    }

    // Configure the layout of the watchface for this device
    function onLayout(dc) {


 		screenCenterPoint = [dc.getWidth()/2, dc.getHeight()/2];
 		
 		 fheights = [94,62,25,14];//default 240px;
 		 if(dc.getWidth()==260)
 		 	{
 		 fheights = [102,67,27,15];	
 		 	}
 		 if(dc.getWidth()==280)
 		 	{
 		  fheights = [110,73,30,17];		
 		 	}
 		

 		bgRedrawRequested = new[2];
 		 sRenderer = new symbolRenderer(dc);
 		  tRenderer = new textRenderer(dc);
 		  iKeeper = new infoKeeper();
 		  hrBox = new hrRenderer(dc);
 		   isAwake = true;
 		   
 	    font_hours = WatchUi.loadResource(Rez.Fonts.hours);
        font_minutes = WatchUi.loadResource(Rez.Fonts.minutes);
        font_date = WatchUi.loadResource(Rez.Fonts.date);	
        font_data = WatchUi.loadResource(Rez.Fonts.data);	   

      		 getColorSettings(me);
 		 sRenderer._themeColor = ThemeColor;
 		 sRenderer._bgColor = BgColor;  
 		 tRenderer.fgColor = FgColor;
 		 tRenderer.bgColor = BgColor;   		   
         chosenFields = [1,2,3,4,5,6];
         getFields ();  

	}
 
    // Handle the update event
    function onUpdate(dc) {
    
        sWidth = dc.getWidth();
     	sHeight = dc.getHeight();  
        var width;
        var height;
        var screenWidth = dc.getWidth();
        var clockTime = System.getClockTime();
        var minuteHandAngle;
        var hourHandAngle;
        var secondHand;
        var targetDc = null;
        var curClip = null;
       // isAwake = true;

         hrBox.getHrHistory();
         iKeeper.refreshInfo();
         getFields ();
         phoneConnectionStatus = PhoneConnection();
			if(Storage.getValue("SettingsChanged") == true)
				{
				      		 getColorSettings(me);
					 		 sRenderer._themeColor = ThemeColor;
					 		 sRenderer._bgColor = BgColor;  
					 		 tRenderer.fgColor = FgColor;
					 		 tRenderer.bgColor = BgColor;   		   
					         chosenFields = [1,2,3,4,5,6];
					         getFields (); 
					         Storage.setValue("SettingsChanged", false); 
				}
		 
		// fullScreenRefresh = true;
 		drawBackground(dc);

	
 
    }

    function drawBackground(dc) {
  
     	// System.println("imma drawinn full");
     	dc.clearClip(); 
		
		dc.setColor(BgColor, BgColor);
		dc.clear();
		
		dc.setPenWidth(1);

		drawHours(dc,FgColor);
		drawMinutes(dc,FgColor);
		drawFields(dc,FgColor);
		//drawIfActive(dc,true);
				    	if(displaySeconds==true)
				    		{
				    		 var secs = System.getClockTime().sec;
				    		drawSeconds(dc,SecondsColor,secs);
				     
				    		}
 
    }
	
	function drawMinutes(dc,Color)	{

		var minutes = System.getClockTime().min.format("%02d");
		var fsize = sHeight/4;
		//var fsize = Math.floor(dc.getWidth()/2.54);
		var y = Math.floor(sHeight/2-fheights[1]*1.1);
		var x = sWidth/2+5 ;
		tRenderer.fgColor = ThemeColor;
		//renderText(dc,x,y,fsize,minutes,ThemeColor);
		dc.setClip(sWidth/2, sHeight/3, sWidth/2, sHeight/3);
			tRenderer.drawText(x-fheights[1]*0.05, y, font_minutes, minutes, Graphics.TEXT_JUSTIFY_LEFT);
		tRenderer.fgColor = FgColor;
		dc.clearClip();
	}
	
	function drawHours(dc,Color)	{
		var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT );
		var months = today.month;
		if(months<10)
			{
			months = "0"+months.toString();
			}
			months.toString();
		var daten =   today.day.toString()+"-"+months;
		var dayOfWeek = dayOfWeek(today.day_of_week);
		//System.println(daten);	
		
		var hours = System.getClockTime().hour;
		
		if(!is24hour and hours > 12)
			{
			hours = hours-12;
			
			//
			}
			else
				{
				
				}
		hours = hours.format("%02d");
		var onehour = new Time.Duration(3600);
		var currenth = new Gregorian.Moment(Time.now().value());

		
		var fsize = fheights[0];
		var y = Math.floor(sHeight/2-fheights[0]*1.1);
		
	 
		
	

			var x = sWidth/2;
			var gwidth = tRenderer.len;	
			 
		dc.setClip(0,sHeight/2-fheights[0]*0.55,sWidth/2,fsize*1.1)	;

		
		tRenderer.fgColor = HoursColor;
		tRenderer.drawText(x+fheights[0]*0.05, y, font_hours, hours, Graphics.TEXT_JUSTIFY_RIGHT);

			var xd = sWidth/2;
			var yb = Math.floor(sHeight/2-fheights[0]);
		
		
		dc.setClip(0,0,sWidth/2,sHeight/3)	;
		tRenderer.fgColor = FgColor;
		tRenderer.drawText(x,yb,font_date, daten, Graphics.TEXT_JUSTIFY_RIGHT);
		
		
		//tRenderer.calcText(bigDataFont,dayOfWeek);
			//var xy = sWidth/2-tRenderer.len-2;
			var yd = yb-Math.floor(fheights[2]*1.1);
		tRenderer.drawText(x,yd,font_date, dayOfWeek, Graphics.TEXT_JUSTIFY_RIGHT);
		RenderShade(dc,0,0,x,sHeight/2-(fheights[0]*1.1)/2,BgColor,Color);
		
		
		
		dc.setClip(0,sHeight/2,sWidth/2,sHeight/2)	;
		
		hrBox.width = 100;
		
		hrBox.height = 50;
		var yhr = sHeight/2+(fheights[0]*1.1)/2;
		var xhr = sWidth/2-hrBox.width-6;	
		hrBox.drawHrGraph(xhr,yhr);	
		//System.println("x= "+xhr+"y="+yhr);
		dc.setColor(Graphics.COLOR_RED,BgColor);
		var yhr_label = yhr+hrBox.height-fheights[3]/2;
		
		tRenderer.drawText(x-5,yhr_label,font_data, hrBox.minHr+"-"+hrBox.maxHr, Graphics.TEXT_JUSTIFY_RIGHT);
		
		
		
		var ya = sHeight/2+(fheights[0]*1.1)/2;
		var x2 = sWidth/2-2;	
		RenderShade(dc,xhr,ya,x2,ya+hrBox.height,BgColor,Color);
		//offCalcBuffer = [[x,y,fsize,hours,ThemeColor],[x,yb,fsize,hourBefore,Color],[x,ya,fsize,hourLater,Color]];
		dc.clearClip();
	}	
	
	



	
	function drawSeconds(dc,Color,secs)	{ 
		//System.println("draw seconds called for drawin: "+secs);// 
		
		if (secs==59)
			{
			//fullScreenRefresh=true;
			}
		var secondsAngle = (secs/60.0) * Math.PI * 2;
		if(secs>30)
			{
			secondsAngle = ((60-secs)/60.0) * Math.PI * 2;
			}
		
		var thick = generateSecondsThicks(screenCenterPoint,secondsAngle,5);
		
		////now dc restrict
		       curClip = getBoundingBox(thick);
		 dc.setClip(curClip[0][0], curClip[0][1], curClip[1], curClip[2]); 
		        	bgRedrawRequested[0] = 0;			        	
		       	if((secs>4 and secs<8) or (secs>52 and secs<57))// drawOffCalcField(DrawContext,x,y,fontSize,fieldType,FieldColor,value,fieldno)
		        	{
		        	
		        	bgRedrawRequested[1] = 1;
		        	//drawOffCalcField(offCalcField1[0],offCalcField1[1],offCalcField1[2],offCalcField1[3],offCalcField1[4],offCalcField1[5],offCalcField1[6]);
		        	} 
		        else if((secs>22 and secs<25) or (secs>35 and secs<38)) {
		        		bgRedrawRequested[1] = 2;
		       //drawOffCalcField(offCalcField6[0],offCalcField6[1],offCalcField6[2],offCalcField6[3],offCalcField6[4],offCalcField6[5],offCalcField6[6]);
		        }
		        
		        	
				       	else
				        	{
				        	bgRedrawRequested[1] = 0;
				        	} 	        		
		dc.setColor(Color, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(3);
		DrawPolygon(dc,thick[0]);
		//?BToption
		 
		if(btStatus)
			{
			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
				if(phoneConnectionStatus[0]==0)
				{
					dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
				}
			}
		DrawPolygon(dc,thick[1]);

}	
	
	function drawFields(dc,FieldColor) {
        // chosenFields = [1,2,3,4,5,6];
       
        //Steps,Calories,Temperature,Battery,HeartRate,Floors,Altitude,Messages	
        dc.setPenWidth(1);
     var x = sWidth/2+2;
     var y =0;  
     var z=2;
     var fsize = Math.floor(fheights[3]);//sHeight/20.0; 
     var asc = Graphics.getFontAscent(font_data);
		     for(var i =0;i<chosenFields.size();i++) {
		     //wez warto�� pola
		   	
		      y = sHeight/6.0+i*1.4*fsize;
		      
		      if(i>2)
		      	{
		      	//minute font size = sHeight/4
		   
		    y = sHeight/6.0+i*1.4*fsize+fheights[1]+0.6*fsize;
		      z--;
		      	}
		      	dc.setClip(sWidth/2,y-fsize*1.2,sWidth/3,fsize*1.5);
		      	//System.println("drawin field "+chosenFields[i]+" on y:"+y+"fsize="+fsize);
		     		drawField(dc,x,y,chosenFields[i],FieldColor,asc,i);
		     //narysuj pole
		     
		     }
	dc.clearClip();
	
	}	
	
	function drawField(DrawContext,x,y,fieldType,FieldColor,fontSize,fieldno) {
	//Steps,Calories,Temperature,Battery,HeartRate,Floors,Altitude,Messages	
	

	
	var value =0;
		if(true)//true)
		{
		value = iKeeper.getFieldValue(fieldType);
		offlineFieldValues[fieldType]=value;
		}
		else {
		value = offlineFieldValues[fieldType];
			}
		//System.println("gettin field"+fieldType+"got"+value);
	if (fieldType !=11)
	{
		sRenderer.renderSymbol(x,y,fieldType,FieldColor);	
		tRenderer.drawText(x+fontSize*0.8,y-fontSize,font_data, value, Graphics.TEXT_JUSTIFY_LEFT);
	}	
				if ( fieldno==0)
				{
					offCalcField1 = [DrawContext,x,y,fontSize,fieldType,FieldColor,value];
					}
				if ( fieldno==5)
				{
					 offCalcField6 = [DrawContext,x,y,fontSize,fieldType,FieldColor,value];
					}
										
	
	}
	function drawOffCalcField(DrawContext,x,y,fontSize,fieldType,FieldColor,value) {
	if (fieldType !=11)
		{
				tRenderer._dc.setClip(curClip[0][0], curClip[0][1], curClip[1], curClip[2]); 
				tRenderer.drawText(x+fontSize*0.8,y-fontSize,font_data, value, Graphics.TEXT_JUSTIFY_LEFT);
		}
	}
	
		function RenderShade(dc,x1,y1,x2,y2,Bg,Fg) {
		
 		
		x1--;
		y1--;
		x2++;
		y2++;
		dc.setColor(Bg, Bg);
		dc.setPenWidth(1);

		for(var i=x1;i<x2;i++)
			{
			
			dc.drawLine(i, y1, i, y2);
			i++;
			
			}
		for(var j=y1;j<y2;j++)
			{
			dc.drawLine(x1, j, x2, j);
			j++;
			}	
		dc.setColor(Fg, Bg);	
		
		
}



function DrawPolygon(DrawContext,polygon) {
		for(var i=1;i<polygon.size();i++)
			{
			DrawContext.drawLine(polygon[i-1][0], polygon[i-1][1], polygon[i][0], polygon[i][1]);
			}
}
	
 


	function dayOfWeek(day) {
	
	var days = [1, 2, 3, 4, 5, 6, 7, 8];
	days[0]=null;
	days[1]="sunday";
	days[2]="monday";
	days[3]="tuesday";
	days[4]="wednesday";
	days[5]="thursday";
	days[6]="friday";
	days[7]="saturday";
	
	return days[day].substring(0,3);

	}		
 


 
 
 
 
	public function getColorSettings(app) {
	if(app ==null)
		{
		app = SliderView;
		}
			
        if(Application.getApp().getProperty("BackgroundColor") != null)
        {
        app.BgColor = Application.getApp().getProperty("BackgroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("BackgroundColor", app.BgColor);
        	}
        	 
      	if(Application.getApp().getProperty("ForegroundColor") != null)
        {
        app.FgColor = Application.getApp().getProperty("ForegroundColor");
        }
        else
        	{
        	Application.getApp().setProperty("ForegroundColor", app.FgColor);
        	}      
        if(Application.getApp().getProperty("ThemeColor") != null)
        {
        app.ThemeColor = Application.getApp().getProperty("ThemeColor");
        
        }   
        else
        	{
        	Application.getApp().setProperty("ThemeColor", app.ThemeColor);
        	}	
        if(Application.getApp().getProperty("SecondsColor") != null)
        {
        app.SecondsColor = Application.getApp().getProperty("SecondsColor");
        
        }   
        else
        	{
        	Application.getApp().setProperty("SecondsColor", app.SecondsColor);
        	}	
        if(Application.getApp().getProperty("HoursColor") != null)
        {
        app.HoursColor = Application.getApp().getProperty("HoursColor");
        
        }   
        else
        	{
        	Application.getApp().setProperty("HoursColor", app.HoursColor);
        	}        	
        if(Application.getApp().getProperty("displaySeconds") != null)
        {
        app.displaySeconds = Application.getApp().getProperty("displaySeconds");
        }   
        else
        	{
        	Application.getApp().setProperty("displaySeconds", app.displaySeconds);
        	} 
        if(Application.getApp().getProperty("btStatus") != null)
        {
        app.btStatus = Application.getApp().getProperty("btStatus");
        }   
        else
        	{
        	Application.getApp().setProperty("btStatus", app.btStatus);
        	}         	        	
	}

	
    // Handle the partial update event

    // Compute a bounding box from the passed in points
    function getBoundingBox(array) {
   var minX=array[0][0][0];
   var minY=array[0][0][1];
   var maxX=array[0][0][0];
   var maxY=array[0][0][1];
   
		 for(var i=0;i<array.size();i++){
		 
			 for(var j=0;j<array[i].size();j++)
			 	{
					if(array[i][j][0]<minX)
					 	{
					 	minX = array[i][j][0];
					 	}
					 if(array[i][j][1]<minY)
					 	{
					 	minY = array[i][j][1];
					 	}
					 if(array[i][j][0]>maxX)
					 	{
					 	maxX = array[i][j][0];
					 	}
					 if(array[i][j][1]>maxY)
					 	{
					 	maxY = array[i][j][1];
					 	}						 			 	
			 	}
			 

		 		 	
		 
		 
		 
		 }
		 //		        var bboxWidth = curClip[1][0] - curClip[0][0];
		 //        var bboxHeight = curClip[1][1] - curClip[0][1];
		 var width = maxX+2- (minX-2);
		 var height = maxY+2- (minY-2);
        return [[minX-1,minY-1], width,height];
    }
  

 
    function generateSecondsThicks(centerPoint, angle, handLength) {
        // Map out the coordinates of the watch hand
        var ThickLen = 12;
        var yMax = centerPoint[1];
        var cP = centerPoint;
        angle = angle+Math.PI/2;

        var coords1 = [[-3,-yMax+ThickLen],[-3,-yMax]];
        //var coords2 = [[0,-yMax+ThickLen],[0,-yMax]];
        var coords3 = [[3,-yMax+ThickLen],[3,-yMax]];
        
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        var ret = new[2];
        //System.println([cos,sin,angle]);

        // Transform the coordinates
       // var result1 = [[cP[0]+  coords1[0][1]*cos-sin,	cP[1]+coords1[0][1]*sin+cos ]     ,   [cP[0]+coords1[1][1]*cos-sin,	cP[1]+coords1[1][1]*sin+cos]];
        var result1 = [[cP[0]+  coords1[0][1]*cos+coords1[0][0]*sin,	cP[1]+coords1[0][1]*sin-coords1[0][0]*cos ]     ,  
        		 [cP[0]+coords1[1][1]*cos+coords1[1][0]*sin,	cP[1]+coords1[1][1]*sin-coords1[1][0]*cos]];
        /*var result2 = [[cP[0]+  coords2[0][1]*cos+coords2[0][0]*sin,	cP[1]+coords2[0][1]*sin-coords2[0][0]*cos ]     ,  
        		 [cP[0]+coords2[1][1]*cos+coords2[1][0]*sin,	cP[1]+coords2[1][1]*sin-coords2[1][0]*cos]];   */  
        var result3 = [[cP[0]+  coords3[0][1]*cos+coords3[0][0]*sin,	cP[1]+coords3[0][1]*sin-coords3[0][0]*cos ]     ,  
        		 [cP[0]+coords3[1][1]*cos+coords3[1][0]*sin,	cP[1]+coords3[1][1]*sin-coords3[1][0]*cos]];         		    	
        //var result1 = [[cP[0]+(yMax-ThickLen)*cos-sin,	cP[1]+(yMax-ThickLen)*sin+cos ]     ,   [cP[0]+yMax*cos-sin,	cP[1]+yMax*sin]+cos];
        
        return [result1,result3];
    } 
    
function miniBgRedraw(dc)
{
		if(curClip !=null)
			{
			dc.setColor(BgColor,BgColor);
			
			dc.clear();

			}
		       	if(bgRedrawRequested[1] == 1)// drawOffCalcField(DrawContext,x,y,fontSize,fieldType,FieldColor,value,fieldno)
		        	{
		        	drawOffCalcField(offCalcField1[0],offCalcField1[1],offCalcField1[2],offCalcField1[3],offCalcField1[4],offCalcField1[5],offCalcField1[6]);
		        			      //  dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_TRANSPARENT);	
			//dc.drawRectangle(curClip[0][0], curClip[0][1], curClip[1], curClip[2]); 
		        	} 
		        else if(bgRedrawRequested[1] == 2) {
		        		
		        drawOffCalcField(offCalcField6[0],offCalcField6[1],offCalcField6[2],offCalcField6[3],offCalcField6[4],offCalcField6[5],offCalcField6[6]);
		        		      //  dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_TRANSPARENT);	
			//dc.drawRectangle(curClip[0][0], curClip[0][1], curClip[1], curClip[2]); 
		        }

			
			
				//System.println("bg_secs_clear"+secs);
}    


    // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
        fullScreenRefresh = false;
         isAwake = false;
    }

    // This method is called when the device exits sleep mode.
    // Set the isAwake flag to let onUpdate know it should render the second hand.
    function onExitSleep() {
        isAwake = true;
        fullScreenRefresh = true;
        WatchUi.requestUpdate();
       //  System.println("imma wakin");


//WatchUi.animate(myString, 50, WatchUi.ANIM_TYPE_LINEAR, 10, 200, 10, null);
        
    }
    function onShow() {
        fullScreenRefresh = true;
         isAwake = true;    
        WatchUi.requestUpdate();

    } 
	function drawIfActive(dc,awake) {
	var Color = ThemeColor;
	if(awake==false)
		{
		Color = BgColor;
		}
	dc.setColor(ThemeColor,BgColor);
	dc.drawLine(sWidth/2-2, 2,sWidth/2+2, 2);
	
	}
    

          
  public  function getFields () {
    
   
    var j=0;
   
    for(var i=0;i<6;i++)
    {
    j++;
	     if(Application.getApp().getProperty("Field_"+j) != null) { 
		     	me.chosenFields[i] = Application.getApp().getProperty("Field_"+j);
		     	}
	         	else{Application.getApp().setProperty("Field_"+j, me.chosenFields[i]);
	         	} 
	         	
	     }        	         	         	         	         	         	
    }
    function onPartialUpdate(dc) {
   //  var conInfo = PhoneConnection();
     
		
		if( displaySeconds==true) {
		miniBgRedraw(dc);
		 var secs = System.getClockTime().sec;
		 phoneConnectionStatus = PhoneConnection();
			drawSeconds(dc,SecondsColor, secs);  
	}
	//System.println(conInfo[1]);
    
    }	
    function PhoneConnection() {
    var status = [1, "Connected"];
    var isConnected = System.getDeviceSettings().phoneConnected;
    if(!isConnected)
    	{
    	status = [0, "Disconnected"];
    	}
    	return status;
    }
    function onSettingsChanged(app) {
          		 app.getColorSettings(app);
 		 app.sRenderer._themeColor = app.ThemeColor;
 		 app.sRenderer._bgColor = app.BgColor;  
 		 app.tRenderer.fgColor = app.FgColor;
 		 app.tRenderer.bgColor = app.BgColor;   		   
         app.chosenFields = [1,2,3,4,5,6];
         app.getFields ();  
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
