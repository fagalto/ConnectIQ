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
        var uWeight;
        var uHeight;
        var drawFieldShape;
        var obscurityFlags;
        var bgColor;
        var fgColor;
        var gitTest;
        var fRenderer;
      	var sWidth;
      	var sHeight;        


    function initialize() {
        DataField.initialize();
			var settings = System.getDeviceSettings();
			sWidth = settings.screenWidth;
			sHeight = settings.screenHeight;
        uWeight = UserProfile.getProfile().weight/1000.0;
        uHeight = UserProfile.getProfile().height;
 
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
 
function onLayout(dc) {
	 fRenderer = new fieldRenderer(dc,getBackgroundColor());
			//obscurityFlags = DataField.getObscurityFlags(); 
	        //View.setLayout(Rez.Layouts.FullScreenLayout(dc));
	 return true;
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
				    //** layout scenarios
				        	fRenderer.fgColor = fgColor;	
				        	fRenderer.bgColor = bgColor;	
				  if(obscurityFlags==15) {
				  drawFieldShape = 1; // fullscreen
				  fRenderer.drawFullScreenDataField(hgFactor,mValue,uHeight);
				  }
				  
				  else if(obscurityFlags==7) { //tophalf
					if (dc.getHeight() == (sHeight/2-1))
						{
						  drawFieldShape = 2;
						  fRenderer.drawHalfField(mValue,uHeight,1);
						}
					else if (dc.getHeight() < (sHeight/2-1))
						{
						  drawFieldShape = 4;
						  fRenderer.drawSemiHalfField(mValue,uHeight,1);		
						}		
				  
				  }
				  else if(obscurityFlags==13) { //bottomhalf
					if (dc.getHeight() == (sHeight/2-1))
						{ 
						  drawFieldShape = 3;
						  fRenderer.drawHalfField(mValue,uHeight,2);
						}
					else if (dc.getHeight() < (sHeight/2-1))
						{
						  drawFieldShape = 5;
						  fRenderer.drawSemiHalfField(mValue,uHeight,2);			
						}
					
				  }
				  else if (obscurityFlags ==5 or  obscurityFlags ==4 or obscurityFlags ==1 )
				  	{
				  	drawFieldShape = 9; //rectangle field somewhere in the middle of screen (4,5,6,7 and 8 field))
				  	fRenderer.drawRectField(mValue,uHeight);
				  	}
				  else{
				  	drawFieldShape = 10; //any other scenario
				  	 fRenderer.justWriteDownData(mValue);
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






 
  
 

}
