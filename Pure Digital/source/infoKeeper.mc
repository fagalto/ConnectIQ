using Toybox.Application;
using Toybox.System;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Weather;

class infoKeeper {
public var tempUnits;
public var values;
public var info;


function initialize () {

	me.values = new[11];
me.tempUnits = System.getDeviceSettings().temperatureUnits ;
me.info =  ActivityMonitor.getInfo();
}
function refreshInfo() {
me.info =  ActivityMonitor.getInfo();
}


function getFieldValue(fieldType) {
var value = 0;

		switch ( fieldType ) {
		case 0: //steps
		value = me.info.steps;
		

		 
		break;	
		case 1: //Calories
		value = me.info.calories;
		
		break;
		case 9: //distance in cm
		value = (me.info.distance/100).toString()+"m";//meters
		if(info.distance/100>1000)
			{
			value = (info.distance/100/1000.0).format("%.01f").toString()+"km";
			}

		 
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
					value = (myStats.usedMemory/1024).toNumber()+"k";	
					//System.println("value memory is "+value);	
		break;
		case 11: //Weather
				value = "since CIQ 3.2.0";
				if(Toybox.Weather has :getCurrentConditions)	
					{
					var weather = Weather.getCurrentConditions();
					var tempOut = weather.temperature;
					var tempFeel = weather.feelsLikeTemperature;
					var windSpeed = weather.windSpeed;
					//var windDir = weather.windBearing;
					value = tempOut+"'C";
				//	System.println("value watch is "+value);	
					//System.println("value weather is "+weather);	
					}
		//value = 1;
		break;
		case 10: //bluetooth
			     value = "On";
			    var isConnected = System.getDeviceSettings().phoneConnected;
			    if(!isConnected)
			    	{
			    	value = "Off";
			    	}
		
		break;									
		default:
		value = 0;
		break;										
	}

me.values[fieldType] = value.toString();
return value.toString();

}




}