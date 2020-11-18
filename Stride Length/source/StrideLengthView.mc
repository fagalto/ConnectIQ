using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.FitContributor;
using Toybox.UserProfile;

class StrideLengthView extends WatchUi.DataField {

    hidden var mValue;
           var  mSpeed;
        var mCad;
        var mDistanceBuffer;
        var mStrideLenBuffer;
        var mPointer;
        var mStrideAggragateLen;
        var noOfBuffer;
        var avgOrCurrent;
        var STRIDE_LEN_FIELD_ID;
        var HGFACTOR_LEN_FIELD_ID;
        var VGFACTOR_LEN_FIELD_ID;
        var strideLenField;
        var mDistance;
        var isPaused;
        var vgFactor;
        var vgFactorField;
        var hgFactor = new[3];
        var hgFactorField;        
        var mFontHeight;
        var xTinyHeight;
        var uWeight;
        var uHeight;
        var drawFullScreen;
        var screenCenterPoint;
        var obscurityFlags;
        var sWidth;
        var sHeight;
        var bgColor;
        var fgColor;


    function initialize() {
        DataField.initialize();
        var settings = System.getDeviceSettings();
        screenCenterPoint = [settings.screenWidth/2, settings.screenHeight/2];
        sWidth = settings.screenWidth;
        sHeight = settings.screenHeight;
        
        bgColor = getBackgroundColor();
       // System.println(bgColor);
        if(bgColor == Graphics.COLOR_BLACK)
        	{
        	fgColor = Graphics.COLOR_WHITE;
        	}
        	else
        		{fgColor = Graphics.COLOR_BLACK;}
        
       	mFontHeight = Graphics.getFontHeight(Graphics.FONT_NUMBER_MEDIUM)-Graphics.getFontDescent(Graphics.FONT_NUMBER_MEDIUM);
        uWeight = UserProfile.getProfile().weight/1000.0;
        uHeight = UserProfile.getProfile().height;
       	xTinyHeight =0;//Graphics.getFontHeight(Graphics.FONT_XTINY)-Graphics.getFontDescent(Graphics.FONT_XTINY);
       //	mFontHeight = Graphics.getFontDescent(Graphics.FONT_NUMBER_MEDIUM);
        
       	//xTinyHeight = Graphics.getFontDescent(Graphics.FONT_XTINY); 	
        mValue = 0.0f;
        mSpeed = 0;
        mCad = 0;
        noOfBuffer = 10;
        mStrideLenBuffer = new[noOfBuffer];
        mPointer =0;
        mStrideAggragateLen = 0;
        avgOrCurrent= "STR.LEN";
        STRIDE_LEN_FIELD_ID=0;
        HGFACTOR_LEN_FIELD_ID =1;
        VGFACTOR_LEN_FIELD_ID =2;
        mDistance=0;
        isPaused = true;
        hgFactor = [0,0,0];
        vgFactor = 0; 
		obscurityFlags = null;    
			
        // Create the custom FIT data field we want to record.
        strideLenField = createField(
            "STRIDE LENGTH",
            STRIDE_LEN_FIELD_ID,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"cm"}
        );
        hgFactorField = createField(
            "G FACTOR",
            HGFACTOR_LEN_FIELD_ID,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"g"}
        );   
 
        strideLenField.setData(mValue);
        hgFactorField.setData(hgFactor[0]);  
      //  vgFactorField.setData(vgFactor);       
        
    }

    function compute(info) {
    var avgOrCurrent=0;
        // See Activity.Info in the documentation for available information.

                mValue = 0.0f;
       
        if(info has :currentCadence and info has :currentSpeed){
            if(info.currentCadence  != null){
                 mCad = info.currentCadence/60.0;//rpm
               // System.println("cadence is: "+mCad/60.0);
            } 
            if(info.currentSpeed != null){
                 mSpeed = info.currentSpeed;
               // System.println("speed is: "+mSpeed);
            } 
        }
if(mCad >0 and isPaused==false)
{
        mStrideLenBuffer[mPointer] = 	mSpeed/mCad;
        mStrideAggragateLen += mSpeed/mCad;
        if(info.elapsedDistance !=null)
        {
		mDistance = info.elapsedDistance/1000.0;
			}
        
        
        	mPointer++;
        	if(mPointer>(noOfBuffer-1))
        		{
        		mPointer=0;
        		} 
        		 
        		if(mStrideLenBuffer[mPointer])
        		{
        		
        		mStrideAggragateLen =  mStrideAggragateLen-mStrideLenBuffer[mPointer] ;
        		var avgStrideLen =     mStrideAggragateLen/(noOfBuffer-1);   
        		mValue =avgStrideLen*100.0;
        		avgOrCurrent = "Stride Len (avg)";
        		} 
        		else
        			{
        			        if(mCad != null and mSpeed != null)
				        	{
				        	
				        	avgOrCurrent = "Stride Len (current)";
				        	} 
				        	mValue =mSpeed/mCad*100.0;
        			}
        			strideLenField.setData(mValue);
        		hgFactor = getAccelData(info.currentCadence,uWeight,mSpeed/mCad);
        		hgFactorField.setData(hgFactor[0]); //[Gcount,hMax,mPower];


}        		
       			
    }

    function onUpdate(dc) {
 			
 		obscurityFlags = DataField.getObscurityFlags(); 	
         bgColor = getBackgroundColor();
        if(bgColor == Graphics.COLOR_BLACK)
        	{
        	fgColor = Graphics.COLOR_WHITE;
        	}
        	else
        		{fgColor = Graphics.COLOR_BLACK;}
        		
  if(obscurityFlags==15) {
  drawFullScreen = 1;
  }
  else if(obscurityFlags==7 and dc.getHeight() == (sHeight/2-1)) { //tophalf
  drawFullScreen = 2;
  }
  else if(obscurityFlags==13 and dc.getHeight() == (sHeight/2-1)) { //bottomhalf
  drawFullScreen = 3;
  }
  else if (obscurityFlags ==5 or  obscurityFlags ==4 or obscurityFlags ==1 )
  	{
  	drawFullScreen = 5;
  	}
  else{
  	drawFullScreen = 4;
  	}
  
	        		if(drawFullScreen ==1)
        			{
        			//System.println("i draw full"); 	
        			drawFullScreenDataField(dc,hgFactor,mValue,uHeight);
        			}
        			else if (drawFullScreen ==2) {
        			//System.println("i draw half"); 	
        			drawHalfField(dc,mValue,uHeight,1);
        			}
        			else if (drawFullScreen ==3) {
        			//System.println("i draw bottom half");
        			drawHalfField(dc,mValue,uHeight,2);
        			} 
        			else if (drawFullScreen ==5) {
        			//System.println("i draw bottom half"); drawRectField(dc,StrideLen,userHeight)	
        			 drawRectField(dc,mValue,uHeight);
        			}         			       			
        			else{
				      // 	System.println("i draw rest"); 		
		
			  		 justWriteDownData(dc,mValue);
        	}
       
         	
    }
  function onTimerPause () {
  isPaused = true;
  }
  function onTimerStopped () {
  isPaused = true;
  }
  function onTimerResume () {
   isPaused = false;
  }
  function onTimerStart () {
   isPaused = false;
  }
  
  function getAccelData(Cadence,weight,StrideLen) {
  var gCons = 9.81;
  var Gcount = 0;
  var vGcount =0;
  var hMax = 0;
  var mPower = 0;
   var Vv = 0;
  if(StrideLen==0 or StrideLen ==null or Cadence ==null)
  	{
    Gcount = 1;
    vGcount =1;
  	}
  	else
  	{
 var sMoveTime= (1/(Cadence/60.0))*0.5; //body moving up time. land time is the same for simplicity
 
 var Vo = sMoveTime*gCons;
 hMax =  (Vo*Vo)/(2*gCons);
 mPower = Math.floor(weight*gCons*hMax/sMoveTime);
 var doublealpha = 2*Math.atan(hMax/(StrideLen/2.0));
 if(doublealpha!=0)
 {Vv = Math.sqrt(StrideLen*gCons/(Math.sin(doublealpha)));}
   Gcount = (Vv/(sMoveTime/2.0))/gCons;
  // vGcount = (Vo/(sMoveTime/2.0))/gCons;

 }
	hMax = (hMax*100).toNumber();
	mPower = mPower.toNumber();
//	System.println("Gcount is: "+Gcount) ;
    return [Gcount,hMax,mPower];
}
 
function onLayout(dc) {

		//obscurityFlags = DataField.getObscurityFlags(); 
        View.setLayout(Rez.Layouts.FullScreenLayout(dc));
 return true;
    } 
function drawFullScreenDataField(dc,dynamics,StrideLen,userHeight) {
//draw Layout
dc.setColor(fgColor, bgColor);
dc.clear();
 
//layout
 
//colors
//fields
//Stride len quality will be divided by user height. This will be base for performance indicator

drawHalfField(dc,StrideLen,userHeight,1);
dc.setPenWidth(1);
dc.setColor(fgColor, bgColor);
dc.drawLine(0, sHeight/2, sWidth, sHeight/2);
dc.drawLine(sWidth/2, sHeight/2, sWidth/2, sHeight);
/********rest of fields************/
dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
dc.drawText(sWidth/2, sHeight/2, Graphics.FONT_TINY , "G Factor ",Graphics.TEXT_JUSTIFY_RIGHT);
dc.drawText(sWidth/2, sHeight/2, Graphics.FONT_TINY , " Power",Graphics.TEXT_JUSTIFY_LEFT);


dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
dc.drawText(sWidth/2, sHeight*0.75, Graphics.FONT_NUMBER_MEDIUM , dynamics[0].format("%.1f")+" ",Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
dc.drawText(sWidth/2, sHeight*0.75, Graphics.FONT_NUMBER_MEDIUM , " "+dynamics[2].format("%i"),Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);


} 


function generateStrideThicks(centerPoint, angle, handLength,thinPen) {

        var ThickLen = 12;
        var yMax = centerPoint[1]-thinPen-5;
        var cP = centerPoint;
        angle = angle+Math.PI/2;

        var coords1 = [[-5,-yMax+ThickLen],[0,-yMax]];
        var coords2 = [[0,-yMax],[5,-yMax+ThickLen]];
        var coords3 = [[5,-yMax+ThickLen],[-5,-yMax+ThickLen]];
        
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        var ret = new[2];
        var result1 = [[cP[0]+  coords1[0][1]*cos+coords1[0][0]*sin,	cP[1]+coords1[0][1]*sin-coords1[0][0]*cos ]     ,  
        		 [cP[0]+coords1[1][1]*cos+coords1[1][0]*sin,	cP[1]+coords1[1][1]*sin-coords1[1][0]*cos]];
        var result2 = [[cP[0]+  coords2[0][1]*cos+coords2[0][0]*sin,	cP[1]+coords2[0][1]*sin-coords2[0][0]*cos ]     ,  
        		 [cP[0]+coords2[1][1]*cos+coords2[1][0]*sin,	cP[1]+coords2[1][1]*sin-coords2[1][0]*cos]]; 
        var result3 = [[cP[0]+  coords3[0][1]*cos+coords3[0][0]*sin,	cP[1]+coords3[0][1]*sin-coords3[0][0]*cos ]     ,  
        		 [cP[0]+coords3[1][1]*cos+coords3[1][0]*sin,	cP[1]+coords3[1][1]*sin-coords3[1][0]*cos]];         		    	


        		 var total =    
        		[[cP[0]+  coords1[0][1]*cos+coords1[0][0]*sin,	cP[1]+coords1[0][1]*sin-coords1[0][0]*cos ],  
        		 [cP[0]+coords1[1][1]*cos+coords1[1][0]*sin,	cP[1]+coords1[1][1]*sin-coords1[1][0]*cos],

				 [cP[0]+  coords2[0][1]*cos+coords2[0][0]*sin,	cP[1]+coords2[0][1]*sin-coords2[0][0]*cos ],  
        		 [cP[0]+coords2[1][1]*cos+coords2[1][0]*sin,	cP[1]+coords2[1][1]*sin-coords2[1][0]*cos],
        		 
        		 [cP[0]+  coords3[0][1]*cos+coords3[0][0]*sin,	cP[1]+coords3[0][1]*sin-coords3[0][0]*cos ],  
				 [cP[0]+coords3[1][1]*cos+coords3[1][0]*sin,	cP[1]+coords3[1][1]*sin-coords3[1][0]*cos]];
        return [result1,result3,result2,total];
    }
function DrawPolygon(DrawContext,polygon) {
		for(var i=1;i<polygon.size();i++)
			{
			DrawContext.drawLine(polygon[i-1][0], polygon[i-1][1], polygon[i][0], polygon[i][1]);
			}
}


function drawHalfField(dc,StrideLen,userHeight,side) {
dc.setColor(fgColor,bgColor);
dc.clear();
var sideMultiplier =1;
var arc = Graphics.ARC_CLOCKWISE;
var arcYcenter = screenCenterPoint[1];
var cPoint = screenCenterPoint;
var valHeight = cPoint[1]-sideMultiplier*1.1*Graphics.getFontAscent(Graphics.FONT_NUMBER_HOT);

if(side==1){
sideMultiplier =1;
}
else if(side==2) {

sideMultiplier =-1;
arc = Graphics.ARC_COUNTER_CLOCKWISE;
cPoint = [screenCenterPoint[0],0];
valHeight = Graphics.getFontAscent(Graphics.FONT_TINY);
}

var strQuality = StrideLen/userHeight;
 
if(strQuality>0.99)
{
strQuality=0.99;
}




dc.setPenWidth(5);
var stridePalette = [Graphics.COLOR_RED, 
						Graphics.COLOR_ORANGE,
						Graphics.COLOR_YELLOW,
						Graphics.COLOR_GREEN,
						Graphics.COLOR_BLUE,
						Graphics.COLOR_PURPLE];
		
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
var i=0;
var thatArc = Math.floor(strQuality/0.1667).toNumber(); //because there is 6 colors onscale
var thinPen = sWidth/20;
var thickPen = thinPen*2;

for(var ang = 180;i<6;ang -=30*sideMultiplier)
	{
	dc.setPenWidth(thinPen);
	if(i==thatArc)
		{
	dc.setPenWidth(thickPen);	
		}
		//System.println("it is : "+i+" step");
	dc.setColor(stridePalette[i], Graphics.COLOR_TRANSPARENT);
	//System.println(screenCenterPoint[1]);
	//System.println("drawin arc "+ang+" to "+(ang-30*sideMultiplier)+" with radius "+(screenCenterPoint[0]-5)+"on position ("+screenCenterPoint[0]+","+screenCenterPoint[1]+")px");
	dc.drawArc(cPoint[0], cPoint[1], screenCenterPoint[0]-5,arc , ang, ang-30*sideMultiplier);
	i++;
	}		
		
/******************/	

var strQualityAngle = (strQuality*Math.PI-Math.PI/2.0)*sideMultiplier;
var thick = generateStrideThicks(cPoint,strQualityAngle,5,thinPen);
 
		dc.setColor(fgColor,bgColor);
		if(sideMultiplier>0) {dc.fillPolygon(thick[3]);}
		
dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
dc.drawText(sWidth/2, cPoint[1]-cPoint[1]*sideMultiplier*5/7.0, Graphics.FONT_TINY , "Stride [cm]",Graphics.TEXT_JUSTIFY_CENTER);					
		dc.setColor(fgColor,Graphics.COLOR_TRANSPARENT);
		dc.drawText(cPoint[0], valHeight, Graphics.FONT_NUMBER_HOT, StrideLen.format("%i"),Graphics.TEXT_JUSTIFY_CENTER );

}  
  
function drawRectField(dc,StrideLen,userHeight) {

dc.setColor(fgColor, bgColor);
dc.clear();
var cPoint = screenCenterPoint;
var fWidth = dc.getWidth();
var fHeight = dc.getHeight();


var strQuality = StrideLen/userHeight;
 
if(strQuality>0.99)
{
strQuality=0.99;
}




dc.setPenWidth(5);
var stridePalette = [Graphics.COLOR_RED, 
						Graphics.COLOR_ORANGE,
						Graphics.COLOR_YELLOW,
						Graphics.COLOR_GREEN,
						Graphics.COLOR_BLUE,
						Graphics.COLOR_PURPLE];
var i=0;
var thatArc = Math.floor(strQuality/0.1667).toNumber(); //because there is 6 colors onscale
var rectHeight = fHeight/10.0;
var rectWidth = Math.ceil(fWidth/6.0);
	dc.setPenWidth(1);

for(var x = 0;i<6; x+=rectWidth)
	{
	
	rectHeight = fHeight/10.0;
	if(i==thatArc)
		{
	rectHeight = fHeight/4.0;
		}
//System.println(rectHeight);

 
	dc.setColor(stridePalette[i], Graphics.COLOR_TRANSPARENT);
 
	dc.drawRectangle(x, fHeight-rectHeight, rectWidth, rectHeight+1);
	dc.fillRectangle(x, fHeight-rectHeight, rectWidth, rectHeight+1);
	i++;
	}		
		
/******************/	
//draw the stride length txtdc.setColor(fgColor, bgColor);	

dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
dc.drawText(fWidth/2, fHeight/10, Graphics.FONT_LARGE , StrideLen.format("%i")+" cm",Graphics.TEXT_JUSTIFY_CENTER);

}  
function justWriteDownData(dc,StrideLen) {
var fWidth = dc.getWidth();
var fHeight = dc.getHeight();
dc.setColor(fgColor, bgColor);
dc.clear();
dc.setColor(Graphics.COLOR_DK_GRAY , Graphics.COLOR_TRANSPARENT);
//dc.drawText(fWidth/2.0, fHeight*0.1, Graphics.FONT_TINY , "Stride [cm]",Graphics.TEXT_JUSTIFY_CENTER);
//System.println("imma drawin on "+fWidth/2.0+"px-x, y= "+fHeight*0.1);
dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
dc.drawText(fWidth/2.0, fHeight/2.0, Graphics.FONT_LARGE , StrideLen.format("%i")+"cm" ,Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
}
}
