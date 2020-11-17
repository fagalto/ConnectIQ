
class textRenderer {
var _dc;
public var fgColor;
public var bgColor;
public var polygons;
public var len;

function initialize (dc) {
_dc = dc;

}

	function calcText(size,value)
	{
 
		me.len = 1;
		return true;
	}
		
		function drawText(x,y,font,text,align)
		{
		_dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
			_dc.drawText(x, y, font, text, align );
		}
		

		function calcDigit(s,digit)	{

	
}

function polyMaxX (Polygon)
	{
	var maxX = 0;
		if(Polygon !=null)
		{
		var s = Polygon.size();
		
		
		for( var j = 0; j < Polygon.size(); j++ ) {
				   //System.println("imma translatin"+Polygon[j]);
				    if(Polygon[j][0]>maxX)
				    	{
				    	maxX = Polygon[j][0];
				    	
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
	
	
function getBoundingBox(array) {
   var minX=array[0][0];
   var minY=array[0][1];
   var maxX=array[0][0];
   var maxY=array[0][1];
   
		 for(var i=0;i<array.size();i++){
		 
			 for(var j=0;j<array[i].size();j++)
			 	{
					if(array[i][j]<minX)
					 	{
					 	minX = array[i][j];
					 	}
					 if(array[i][j]<minY)
					 	{
					 	minY = array[i][j];
					 	}
					 if(array[i][j]>maxX)
					 	{
					 	maxX = array[i][j];
					 	}
					 if(array[i][j]>maxY)
					 	{
					 	maxY = array[i][j];
					 	}						 			 	
			 	}
			 

		 		 	
		 
		 
		 
		 }
		 //		        var bboxWidth = curClip[1][0] - curClip[0][0];
		 //        var bboxHeight = curClip[1][1] - curClip[0][1];
		 var width = maxX+1- (minX-1);
		 var height = maxY+1- (minY-1);
        return [[minX-1,minY-1], width,height];
    }	


}