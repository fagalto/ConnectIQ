using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.UserProfile;

class fieldRenderer {
var dc;

      public var sWidth;
      public var sHeight;
      public var bgColor;
      public var fgColor;
      public var fWidth;
      public var fHeight;  
      public var screenCenterPoint;    

function initialize (drawContext,bColor) {
dc = drawContext;
fWidth = dc.getWidth();
fHeight = dc.getHeight();
var settings = System.getDeviceSettings();
screenCenterPoint = [settings.screenWidth/2, settings.screenHeight/2];
sWidth = settings.screenWidth;
sHeight = settings.screenHeight;
        

        if(bColor == Graphics.COLOR_BLACK)
        	{
        	fgColor = Graphics.COLOR_WHITE;
        	bgColor = Graphics.COLOR_BLACK;
        	}
        	else
        		{fgColor = Graphics.COLOR_BLACK;
        		bgColor = Graphics.COLOR_BLACK;
        		}

}

function drawFullScreenDataField(dynamics,StrideLen,userHeight) {
//draw Layout
dc.setColor(fgColor, bgColor);
dc.clear();
 
//layout
 
//colors
//fields
//Stride len quality will be divided by user height. This will be base for performance indicator

drawHalfField(StrideLen,userHeight,1);
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

function drawHalfField(StrideLen,userHeight,side) {
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
	dc.drawArc(cPoint[0], cPoint[1], cPoint[0]-5,arc , ang, ang-30*sideMultiplier);
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

function drawRectField(StrideLen,userHeight) {

dc.setColor(fgColor, bgColor);
dc.clear();



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



function justWriteDownData(StrideLen) {

dc.setColor(fgColor, bgColor);
dc.clear();
dc.setColor(Graphics.COLOR_DK_GRAY , Graphics.COLOR_TRANSPARENT);
dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
dc.drawText(fWidth/2.0, fHeight/2.0, Graphics.FONT_LARGE , StrideLen.format("%i")+"cm" ,Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
}

function drawSemiHalfField(mValue,uHeight,side) {
dc.setColor(fgColor,bgColor);
dc.clear();
var sideMultiplier =1;
var arc = Graphics.ARC_CLOCKWISE;
var arcYcenter = [screenCenterPoint[0],fHeight];
var cPoint = [screenCenterPoint[0],screenCenterPoint[1]];

var valHeight = cPoint[1]-sideMultiplier*1.1*Graphics.getFontAscent(Graphics.FONT_NUMBER_HOT);

if(side==1){
sideMultiplier =1;
}
else if(side==2) {

sideMultiplier =-1;
arc = Graphics.ARC_COUNTER_CLOCKWISE;
cPoint = [screenCenterPoint[0],fHeight-sHeight/2]; //y coord will be negative because centerpoint is above fields
valHeight = Graphics.getFontAscent(Graphics.FONT_TINY);
}

var strQuality = mValue/uHeight;
 
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
//System.println(thinPen);
var angle = Math.toDegrees(Math.atan2((sHeight/2-fHeight), fWidth/2)); 
var fromAngle = Math.floor(180-angle)*sideMultiplier;
var angleStep = (180-2*angle)/6;
var thickPen = thinPen*2;

for(var ang = fromAngle;i<6;ang -=angleStep*sideMultiplier)
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
	dc.drawArc(cPoint[0], cPoint[1], screenCenterPoint[0]-3,arc , ang, ang-angleStep*sideMultiplier);
	i++;
	}		
		
/******************/	

var strQualityAngle = (strQuality*Math.PI-Math.PI/2.0)*sideMultiplier;
var thick = generateStrideThicks(cPoint,strQualityAngle,5,thinPen);
 
		dc.setColor(fgColor,bgColor);
	//	if(sideMultiplier>0) {dc.fillPolygon(thick[3]);}
		
//dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
//dc.drawText(sWidth/2, cPoint[1]-cPoint[1]*sideMultiplier*5/7.0, Graphics.FONT_TINY , "Stride [cm]",Graphics.TEXT_JUSTIFY_CENTER);					
		dc.setColor(fgColor,Graphics.COLOR_TRANSPARENT);
		dc.drawText(fWidth/2.0, fHeight/2.0, Graphics.FONT_LARGE , mValue.format("%i")+"cm" ,Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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


}