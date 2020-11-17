using Toybox.ActivityMonitor;
using Toybox.Time.Gregorian;

class hrRenderer {
var _dc;
public var width;
public var height;
public var fgColor;
public var bgColor;
public var noOfsamples;
public var hrData;
public var maxHr;
public var minHr;
public var noOfSamples;
private var hrHistTimestamp;

 

function initialize (dc) {
	_dc = dc;
	
	 me.minHr = 255;
	 me.maxHr = 0;
	 me.noOfSamples = 60;
	 me.hrData = new[me.noOfSamples];
	 me.hrHistTimestamp = new Gregorian.Moment(1);
	}

function getHrHistory() {
	
	var currenth = new Gregorian.Moment(Time.now().value());
	if(currenth.subtract(me.hrHistTimestamp).value()>60) //once per minute refresh data
		{
		//System.println("refreshing hr data");
			me.hrHistTimestamp = currenth;
			var hrIterator = ActivityMonitor.getHeartRateHistory( me.noOfSamples, false);
			if(hrIterator.getMax() != null and
				 hrIterator.getMax()< ActivityMonitor.INVALID_HR_SAMPLE
				 and hrIterator.getMax()>0) {
					me.maxHr = hrIterator.getMax();
					}
					else
						{
						me.maxHr = 30;
						}
			if(hrIterator.getMin() != null and
				 hrIterator.getMin()< ActivityMonitor.INVALID_HR_SAMPLE
				 and hrIterator.getMin()>0) {					
					me.minHr = hrIterator.getMin();
					}
					else
						{
						me.minHr = 25;
						}
			var sample = hrIterator.next();
				 
			for( var i = 0; i < hrData.size(); i++ )
			{
			if( sample.heartRate< ActivityMonitor.INVALID_HR_SAMPLE) {
			 me.hrData[i] = sample.heartRate;
			// System.println("imma requestin hr data, got "+sample.heartRate+" for time "+sample.when.value());
			 sample = hrIterator.next();
			 }
			 else
			 	{
			 	// System.println("got bad hr data, got "+sample.heartRate);
			 	me.hrData[i] =  minHr;
			 	}
		}
	}
	
	
	}	

function calculateHrGraph() {

var graphMax = me.height-2; //margin
var graphWidth = me.width;

var graphScaleY = graphMax.toFloat()/(me.maxHr-me.minHr);
var graphScaleX = graphWidth.toFloat()/hrData.size();
//System.println("graph width is are "+graphWidth);
var points = new[hrData.size()+2];
var i;
	for(i = 0; i < hrData.size(); i++ )
		{
		points[i] = [i*graphScaleX,graphMax-(hrData[i]-me.minHr)*graphScaleY];
		//System.println("points are "+points[i]);
		
		}
	points[i] = [graphWidth,graphMax];
		i++;
	points[i] = [0,graphMax];
//System.println("scales are "+points);
return points;
	}
	
function drawHrGraph(x,y) {

var points = calculateHrGraph();
points = PolyTranslate(points,x,y);
_dc.fillPolygon(points);


}	
	
	
	
	
	
	
	
	
function getMax (array)
	{
	var maxX = 0;
		if(array !=null)
		{
		var s = array.size();
		
		
		for( var j = 0; j < array.size(); j++ ) {
				   //System.println("imma translatin"+Polygon[j]);
				    if(array[j]>maxX)
				    	{
				    	maxX = array[j];
				    	
				    	}
				}
		}
		//System.println("maxX is"+maxX+", from "+Polygon);
	return maxX.toNumber();	
	}
function PolyTranslate(Polygon,Tx,Ty)
	{
	if(Polygon !=null)
	{
	var s = Polygon.size();
	var tempShifter = new [s];
	
	for( var j = 0; j < Polygon.size(); j++ ) {
			  // System.println("imma translatin"+Polygon[j]+[Tx,Ty]);
			    Polygon[j] =  [Polygon[j][0]+Tx,Polygon[j][1]+Ty];
			}
	}
	return Polygon;	
	}	
}