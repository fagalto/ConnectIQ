

using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Application;

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
	 
    var BgColor;
    var BrColor;   
    var DtColor;
    var FgColor;
    var ThemeColor;


 	var chosenFields;
	var displaySeconds;

	var bgRedrawRequested;	
	var offlineFieldValues;//;// = new[6];
	var offCalcBuffer;
	var offCalcField1;
	var offCalcField6;
	var sRenderer;
	var tRenderer;
	var iKeeper;
	var hrBox;
	var myDc;
	var curHour;
	var curMinute;

    function initialize() {
        WatchFace.initialize();

        fullScreenRefresh = true;
        offlineFieldValues = new[15];
       
     
        partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
    }

    // Configure the layout of the watchface for this device
    function onLayout(dc) {

 		screenCenterPoint = [dc.getWidth()/2, dc.getHeight()/2];
 		bgRedrawRequested = new[2];
 		 sRenderer = new symbolRenderer(dc);
 		  tRenderer = new textRenderer(dc);
 		  iKeeper = new infoKeeper();
 		  hrBox = new hrRenderer(dc);
 		   isAwake = true;
 		  

   

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
        var curClip = null;
        myDc = dc;
       // isAwake = true;
     		 getColorSettings();
 		 sRenderer._themeColor = ThemeColor;
 		 sRenderer._bgColor = BgColor;  
 		 tRenderer.fgColor = FgColor;
 		 tRenderer.bgColor = BgColor;   		   
       	 hrBox.getHrHistory();
         chosenFields = [1,2,3,4,5,6];
         
         getFields ();
         
         is24hour = System.getDeviceSettings().is24Hour;
         tempUnits = System.getDeviceSettings().temperatureUnits ;

		 
		// fullScreenRefresh = true;
 		drawBackground(dc);

        if(Application.getApp().getProperty("displaySeconds") != null)
        {
        displaySeconds = Application.getApp().getProperty("displaySeconds");
        }   
        else
        	{
        	Application.getApp().setProperty("displaySeconds", displaySeconds);
        	} 	
 
    }

    function drawBackground(dc) {
  
     	// System.println("imma drawinn full");
     	dc.clearClip(); 
		dc.clear();
		dc.setColor(BgColor, BgColor);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		
		dc.setPenWidth(1);

		drawHours(dc,FgColor);
		drawMinutes(dc,FgColor);
		//drawFields(dc,FgColor);
		drawIfActive(dc,true);
				    	if(displaySeconds==true)
				    		{
				    		 var secs = System.getClockTime().sec;
				    		//drawSeconds(dc,ThemeColor,secs);
				     
				    		}
 
    }
	
	function drawMinutes(dc,Color)	{

		var minutes = System.getClockTime().min.format("%02d");
		var fsize = dc.getHeight()/2;
		//var fsize = Math.floor(dc.getWidth()/2.54);
		var y = dc.getHeight()/2+fsize/2;
		var x = dc.getWidth()/2+5 ;
		tRenderer.fgColor = ThemeColor;
		//renderText(dc,x,y,fsize,minutes,ThemeColor);
		tRenderer.calcText(fsize,minutes);
		tRenderer.drawText(x,y);
		tRenderer.fgColor = FgColor;
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
		
		var hours = System.getClockTime().hour.format("%02d");
		
		var onehour = new Time.Duration(3600);
		var currenth = new Gregorian.Moment(Time.now().value());
		var hourLater =  Gregorian.info(currenth.add(onehour),Time.FORMAT_MEDIUM).hour.format("%02d");
		var hourBefore = Gregorian.info(currenth.subtract(onehour),Time.FORMAT_MEDIUM).hour.format("%02d");
		
		var fsize = Math.floor(dc.getWidth()/2);
		//System.println("gotta:"+fsize);
		var y = dc.getHeight()/2+fsize/2;
		var yb = dc.getHeight()/2-fsize*0.5-4;
	
		
		var yyears = yb-30-4;	
		var x2 = dc.getWidth()/2-2;	
	 
		tRenderer.fgColor = FgColor;
	
		tRenderer.calcText(fsize,hours);
			var x = dc.getWidth()/2-tRenderer.len-2;
			var gwidth = tRenderer.len;	
		tRenderer.drawText(x,y);
			
			var bigDataFont = 30;
		
		
		tRenderer.calcText(bigDataFont,daten);
			var xd = dc.getWidth()/2-tRenderer.len-2;	
		tRenderer.drawText(xd,yb);
		
		
		tRenderer.calcText(bigDataFont,dayOfWeek);
			var xy = dc.getWidth()/2-tRenderer.len-2;
		tRenderer.drawText(xy,yyears);
		
		

		
		//
		var ya = dc.getHeight()/2+fsize*1.5+4;
		//tRenderer.calcText(fsize,hourLater);
		//tRenderer.drawText(x,ya);	
		
		hrBox.width = 100;
		
		hrBox.height = 50;
		var yhr = dc.getHeight()/2+fsize*0.5+4;
		var xhr = dc.getWidth()/2-hrBox.width-6;	
		
		//dc.setColor(Graphics.COLOR_RED,BgColor);
		
		hrBox.drawHrGraph(xhr,yhr);	
		dc.setColor(Graphics.COLOR_RED,BgColor);
		
		
		    tRenderer.calcText(10,hrBox.minHr+"-"+hrBox.maxHr);
			var xtm = dc.getWidth()/2-tRenderer.len-2;
		    tRenderer.drawText(xtm,yhr+hrBox.height+12);
		//dc.drawRectangle(xhr,yhr, hrBox.width, hrBox.height)	;	
		//System.println("hrbox max is:"+hrBox.maxHr);
		//hrBox.drawHrGraph(x,ya);
		
		RenderShade(dc,x,yb-fsize,x2,yb,BgColor,Color);
		RenderShade(dc,xhr,ya-fsize,x2,ya,BgColor,Color);
		//offCalcBuffer = [[x,y,fsize,hours,ThemeColor],[x,yb,fsize,hourBefore,Color],[x,ya,fsize,hourLater,Color]];
	}	
	
	
	function drawHoursoffCalc(dc,x,y,fsize,hours,shade,Color) {
	//System.println("drawin"+hours+"with"+shade+" shade");
		dc.setColor(Color,BgColor);	
		//renderText(dc,x,y,fsize,hours,Color);
		tRenderer.calcText(fsize,hours);
		tRenderer.drawText(x,y);
		if(shade==true)
			{
			RenderShade(dc,x,y-fsize,dc.getWidth()/2-5,y,BgColor,Color);
			}	
			if(curClip !=null)
				{
				//System.println("drawin"+hours+"with clip set");
				}
	
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
		       	if((secs>3 and secs<8) or (secs>52 and secs<57))// drawOffCalcField(DrawContext,x,y,fontSize,fieldType,FieldColor,value,fieldno)
		        	{
		        	
		        	bgRedrawRequested[1] = 1;
		        	} 
		        else if((secs>22 and secs<27) or (secs>33 and secs<38)) {
		        bgRedrawRequested[1] = 2;
		        }
		        	
				       	else
				        	{
				        	bgRedrawRequested[1] = 0;
				        	} 	        		
		dc.setColor(ThemeColor, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(2);
		DrawPolygon(dc,thick[0]);
		DrawPolygon(dc,thick[1]);

}	
	
	function drawFields(dc,FieldColor) {
        // chosenFields = [1,2,3,4,5,6];
       
        //Steps,Calories,Temperature,Battery,HeartRate,Floors,Altitude,Messages	
        dc.setPenWidth(1);
     var x = dc.getWidth()/2+2;
     var y =0;  
     var z=2;
     var fsize = 16;//dc.getHeight()/20.0; 
		     for(var i =0;i<chosenFields.size();i++) {
		     //wez warto�� pola
		   	
		      y = dc.getHeight()/6.0+i*fsize*1.4;
		      if(i>2)
		      	{
		      	//minute font size = dc.getHeight()/4
		    y = dc.getHeight()- dc.getHeight()/6.0-z*fsize*1.4+fsize;
		      z--;
		      	}
		      //	System.println("drawin field "+chosenFields[i]+" on y:"+y);
		     		drawField(dc,x,y,chosenFields[i],FieldColor,fsize,i);
		     //narysuj pole
		     
		     }
	
	
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

	//renderSymbol(DrawContext,x,y,fontSize,fieldType,FieldColor);
	sRenderer.renderSymbol(x,y,fontSize,fieldType,FieldColor);
//	renderText(DrawContext,x+fontSize+5,y,fontSize,value.toString(),FieldColor);
	tRenderer.calcText(fontSize,value.toString());
	tRenderer.drawText(x+fontSize+5,y);

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
			sRenderer.renderSymbol(x,y,fontSize,fieldType,FieldColor);
			//renderText(DrawContext,x+fontSize+5,y,fontSize,value.toString(),FieldColor);
			tRenderer.calcText(fontSize,value.toString());
			tRenderer.drawText(x+fontSize+5,y);
			//System.println("drawin fields with clip set");	
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
 


 
 
 
 
	function getColorSettings() {
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
        if(Application.getApp().getProperty("ThemeColor") != null)
        {
        ThemeColor = Application.getApp().getProperty("ThemeColor");
        
        }   
        else
        	{
        	Application.getApp().setProperty("ThemeColor", ThemeColor);
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
    
function miniBgRedraw()
{
		if(curClip !=null)
			{
			myDc.setColor(BgColor,BgColor);
			myDc.fillRectangle(curClip[0][0], 
								curClip[0][1], 
								curClip[1] , 
								curClip[2]);
			}
			
			if(bgRedrawRequested[0]==1)///low
				{
				//dc.drawRectangle(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);
				drawHoursoffCalc(myDc,offCalcBuffer[2][0],offCalcBuffer[2][1],offCalcBuffer[2][2],offCalcBuffer[2][3],true,offCalcBuffer[2][4]);
				}
			if(bgRedrawRequested[0]==3)///top
				{
				//dc.drawRectangle(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);
				drawHoursoffCalc(myDc,offCalcBuffer[1][0],offCalcBuffer[1][1],offCalcBuffer[1][2],offCalcBuffer[1][3],true,offCalcBuffer[1][4]);
				}
			if(bgRedrawRequested[1]==1)
				{
				//dc.drawRectangle(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);
				//drawFields(dc,FgColor);
				
				//offCalcField1 = [DrawContext,x,y,fontSize,fieldType,FieldColor,value];
				drawOffCalcField(offCalcField1[0],offCalcField1[1],offCalcField1[2],offCalcField1[3],offCalcField1[4],offCalcField1[5],offCalcField1[6]);
				}
			if(bgRedrawRequested[1]==2)
				{
				//dc.drawRectangle(curClip[0][0], curClip[0][1], bboxWidth, bboxHeight);
				//drawFields(dc,FgColor);
				drawOffCalcField(offCalcField6[0],offCalcField6[1],offCalcField6[2],offCalcField6[3],offCalcField6[4],offCalcField6[5],offCalcField6[6]);
				}	
			
				//System.println("bg_secs_clear"+secs);
}    


    // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
       
        var secs =System.getClockTime().sec;
        curClip = null;
        myDc.clearClip();
        myDc.clear();
        WatchUi.requestUpdate();
        drawIfActive(myDc,false);
       

        fullScreenRefresh = false;
         isAwake = false;
      System.println("sleepin, secs="+secs);
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
	dc.drawPoint(dc.getWidth()/2, 1);
	
	}
    

          
    function getFields () {
    
   
    var j=0;
   
    for(var i=0;i<6;i++)
    {
    j++;
	     if(Application.getApp().getProperty("Field_"+j) != null) { 
		     	chosenFields[i] = Application.getApp().getProperty("Field_"+j);
		     	}
	         	else{Application.getApp().setProperty("Field_"+j, chosenFields[i]);
	         	} 
	         	
	     }        	         	         	         	         	         	
    }
    function onPartialUpdate(dc) {
     
		
		if( displaySeconds==true) {
		miniBgRedraw();
		 var secs = System.getClockTime().sec;
		dc.clearClip();
		var secondsAngle = (secs/60.0) * Math.PI * 2;
		if(secs>30)
			{
			secondsAngle = ((60-secs)/60.0) * Math.PI * 2;
			}
		
		var thick = generateSecondsThicks(screenCenterPoint,secondsAngle,5);
		
 
		       curClip = getBoundingBox(thick);
		 dc.setClip(curClip[0][0], curClip[0][1], curClip[1], curClip[2]); 
		//dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);    
 

			drawSeconds(dc,ThemeColor, secs);  
	}
	//System.println("partial, secs="+seconds);
    
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
