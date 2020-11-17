using Toybox.Application;
using Toybox.System;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Lang;
using Toybox.Math;

class infoKeeper {
public var tempUnits;
public var values;


function initialize () {

	me.values = new[9];
me.tempUnits = System.getDeviceSettings().temperatureUnits ;
}

function getFieldValue(fieldType) {

var info = ActivityMonitor.getInfo();
var value = 0;

		switch ( fieldType ) {
		case 0: //steps
		value = info.steps;
		 
		break;	
		case 1: //Calories
		value = info.calories;
		break;	
		case 2: //Temperature
				var temp=000;
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
					value = temp;//Math.floor(temp);
		break;	
		case 3: //Battery
		var	myStats = System.getSystemStats();
					value = myStats.battery.toNumber();	
		break;	
		case 4: //HeartRate
				if(Toybox has :SensorHistory)
				{
				
					if(Toybox.ActivityMonitor has :getHeartRateHistory)
					{
					value = ActivityMonitor.getHeartRateHistory(1,true).next();
					//System.println("have"+value.heartRate);
						if(value.heartRate == null or value.heartRate>=ActivityMonitor.INVALID_HR_SAMPLE)
							{
							value = "na";
							}
							else{
							value = value.heartRate.toNumber();
							}
							
					//value = "na";	
					}
					else
					{
					value = "na";
					}	
				}
				else
					{
					value = "na";
					}
		//var hr = ActivityMonitor.heartRate
		break;	
		case 5: //Floors
		if(info has :floorsClimbed)
		{
		value = info.floorsClimbed;
		}
		else
			{
			value = 000;
			}
		 
		
		//System.println("have"+value+"floors");
		break;	
		case 6: //Altitude

			var alt =000;
					
					
					
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
						
						}
			
			
					value = alt;
		break;
		case 7: //Messages
		value = System.getDeviceSettings().notificationCount;
		//value = 1;
		break;	
		case 8: //Memory
		myStats = System.getSystemStats();
					value = myStats.usedMemory;	
					//System.println("value memory is "+value);	
		break;			
		default:
		value = 0;
		break;										
	}
me.values[fieldType] = value.toString();
return value.toString();

}




}