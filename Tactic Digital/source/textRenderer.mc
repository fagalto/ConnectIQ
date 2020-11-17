
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
		var spacing = 0;//size/20;
		value = value.toString();
		//System.println("gotta renderin"+value+" on "+x+","+y);
		var tempPolygons = new[value.length()];
		var valPolygons = new[value.length()];
		var wMod=1;	//for wide letters like m and w
		var digit = null;
		var pMaxX = null;
		var tx=0;
		
		spacing = size/20;
		if(spacing<2)
			{
			spacing = 3;
			}	
			for(var i=0;i<value.length();i++)
			{
			digit = value.substring(i,i+1).toString();
			var tempPolygons1 = calcDigit(size,digit);
			 
				pMaxX = polyMaxX(tempPolygons1);
			tempPolygons =	PolyTranslate(tempPolygons1,tx,0);
			
			tx=tx+pMaxX+spacing;
			valPolygons[i] = tempPolygons;
				if(digit.find("m") !=null or digit.find("w") !=null) {
				//
				wMod=2.0;
				}			
			 else
			 	{wMod=1.0;}
			}
		me.polygons = valPolygons;
		me.len = tx;
		return true;
		}
		
		function drawText(x,y)
		{
			_dc.setColor(fgColor, bgColor);	
		for(var i=0;i<me.polygons.size();i++)
			{

				me.polygons[i] = PolyTranslate(me.polygons[i],x,y);
			       //clip = getBoundingBox(me.polygons[i]);
			 		//_dc.setClip(clip[0][0], clip[0][1], clip[1], clip[2]); 
			 			
				_dc.fillPolygon(me.polygons[i]);
				
			}
			//_dc.clearClip();	
		}
		

		function calcDigit(s,digit)	{
		var tdv = 6.0;
		if(s<30)
			{
			tdv=6.0;
			}
		var mUp = tdv/2.0+0.5;
		var mDn = tdv/2.0-0.5;
		if(s<20 and s.toNumber()%2==0)
			{
		  mUp = tdv/2.0+1;
		  mDn = tdv/2.0-0;			
			}
				
 	

		//System.println("gotta:"+mUp+","+mDn);
		var hs = s/2;
		var th = Math.floor(s/tdv);

		  mUp = mUp*th;
		  mDn = mDn*th;	
		 
		//if(th<2){th=2;}
		//System.println("gotta:"+th+","+mUp);
		var xspacing = s/10;
		var polygon = null;
		
		var letter = new[2];
		
			switch ( digit ) {
			case "1":
					polygon = [[hs, 0], [hs, -s],[hs-1.5*th,-s],[hs-1.5*th,-s+th],[hs-th,-s+th],[hs-th,0]];break;
			case "2":
					polygon = [[hs, 0], [hs, 0-1*th],[0+th,0-1*th],[0+th,0-mDn],[hs,0-mDn],[hs,-s],[0,-s],[0,-s+th],[hs-th,-s+th],[hs-th,0-mUp],[0,0-mUp],[0,0]];break;
			case "3":
					polygon = [[hs, 0], [hs, -s],[0,-s],[0,-s+th],[hs-th,-s+th],[hs-th,0-mUp],[0+2,0-mUp],[0+2,0-mDn],[hs-th,0-mDn],[hs-th,0-1*th],[0,0-1*th],[0,0]];break;
			case "4":
					polygon = [[hs, 0], [hs,-s+1.5*th],[hs-th,-s+1.5*th],[hs-th,0-mUp],[0+th,0-mUp],[0+th,-s],[0,-s],[0,0-mDn],[hs-th,0-mDn],[hs-th,0]];break;
			case "5":
					polygon = [[hs, 0], [hs, 0-mUp],[0+th,0-mUp],[0+th,-s+th],[hs,-s+th],[hs,-s],[0,-s],[0,0-mDn],[hs-th,0-mDn],[hs-th,0-1*th],[0,0-1*th],[0,0]];break;
			case "6":
					polygon = [[hs, 0], [hs, 0-mUp],[0+th,0-mUp],[0+th,-s+th],[hs,-s+th],[hs,-s],[0,-s],[0,0],[0+th,0],[0+th,0-mDn],[hs-th,0-mDn],[hs-th,0-1*th],[0+th,0-1*th],[0+th,0]];break;
			case "7":
					polygon = [[hs, 0], [hs, -s],[0,-s],[0,-s+th],[hs-th,-s+th],[hs-th,0]]; break;
			case "8":
					polygon = [[hs, 0], [hs, -s],[hs-th,-s],[hs-th,0-mUp],[0+th,0-mUp],[0+th,-s+th],[hs-th,-s+th],[hs-th,-s],[0,-s],[0,0],  [0+th,0],[0+th,0-mDn],[hs-th,0-mDn],[hs-th,0-1*th],[0+th,0-1*th],[0+th,0]];break;
			case "9":
					polygon = [[hs, 0],[hs,-s],[hs-th,-s],[hs-th,0-mUp],[0+th,0-mUp],[0+th,-s+th],[hs-th,-s+th],[hs-th,-s],[0,-s],[0,0-mDn],[hs-th,0-mDn],[hs-th,0-1*th],[0,0-1*th],[0,0]];break;	
			case "0":
					polygon = [[hs, 0], [hs, -s],[hs-th,-s],[hs-th,0-1*th],[0+th,0-1*th],[0+th,-s+th],[hs-th,-s+th],[hs-th,-s],[0,-s],[0,0]]; break;	
			case "-":
					polygon = [[0, 0-mUp], [hs, 0-mUp],[hs, 0-mDn],[0, 0-mDn]]; break;		
			case "|":
					polygon = [[hs, 0], [hs, -s],[0,-s],[0,0]]; break;
			case ".":
					polygon = [[hs/2-th/2, 0], [hs/2+th/2, 0],[hs/2+th/2, 0-th], [hs/2-th/2, 0-th]]; break;					
			case "a":
					polygon = [[hs, 0], [hs, -s],[0,-s],[0,0],[th,0],[th,-s+th],[hs-th,-s+th],[hs-th,0-mDn],[th,0-mDn],[th,0-mUp],[hs-th,0-mUp],[hs-th,0]];break;	
			case "b":
					polygon = [[hs, 0],[hs,0-mUp],[th,0-mUp],[th,-s],[0,-s],  [0,0],[hs-th,0],[hs-th,0-th],[th,0-th],[th,0-mDn],[hs-th,0-mDn],[hs-th,0]];break;
			case "c":
					polygon = [[hs, 0], [hs, 0-th],[th,0-th],[th,0-mDn],[hs,0-mDn],[hs,0-mUp],[0,0-mUp],[0,0]];break;		
			case "d":
					polygon = [[hs, 0], [hs, -s],[hs-th,-s],[hs-th,0-mUp],[0,0-mUp],[0,0],[hs-th,0],[hs-th,0-th],[th,0-th],[th,0-mDn],[hs-th,0-mDn],[hs-th,0]];break;
			case "e":
					polygon = [[hs, 0], [hs, 0-th],[th,0-th],[th,0-2*th],[hs,0-2*th],[hs,-s+th],[0,-s+th],[0,-s+2*th],[hs-th,-s+2*th],[hs-th,0-3*th],[th,0-3*th],[th,-s+2*th],[0,-s+2*th],[0,0]];break;
			case "f":
					polygon = [[hs-th, 0],[hs-th,0-mDn],[hs,0-mDn],[hs,0-mUp],[hs-th,0-mUp],[hs-th,-s+th],[hs,-s+th],[hs,-s],[hs-2*th,-s],[hs-2*th,0-mUp],[hs-3*th,0-mUp],[hs-3*th,0-mDn],[hs-2*th,0-mDn],[hs-2*th,0]];break;
			case "g":
					polygon = [[0,-s+2*th],[hs,-s+2*th],[hs,0+th],[0,0+th],[0,0],[hs-th,0],[hs-th,0-th],[0,0-th],[0,0-2*th],[hs-th,0-2*th],[hs-th,-s+3*th],[th,-s+3*th],[th,0-2*th],[0,0-2*th]];break;
			case "h":
					polygon = [[hs, 0],[hs,-s+2*th],[th,-s+2*th],[th,-s+th],[0,-s+th],  [0,0],[th,0],[th,-s+3*th],[hs-th,-s+3*th],[hs-th,0]];break;
			case "i":
					polygon = [[0,0],[th,0],[th,-s+2*th],[0,-s+2*th]];break;		
			case "j"://todo
					polygon = [[2*th,0],[3*th,0],[3*th,-s+th],[1.5*th,-s+th],[1.5*th,-s+2*th],[2*th,-s+2*th],[2*th,0]];break;
			case "k"://todo
					polygon = [[2*th,0],[3*th,0],[3*th,-s+th],[1.5*th,-s+th],[1.5*th,-s+2*th],[2*th,-s+2*th],[2*th,0]];break;
			case "l"://todo
					polygon = [[2*th,0],[3*th,0],[3*th,-s+th],[1.5*th,-s+th],[1.5*th,-s+2*th],[2*th,-s+2*th],[2*th,0]];break;	
			case "m":
					polygon = [[0,0],[0,-s],[5*th,-s],[5*th,0],[4*th,0], [4*th,-s+th],[3*th,-s+th],[3*th,0],[2*th,0],[2*th,-s+th],[th,-s+th],[th,0],[0,0]];break;
			case "n":
					polygon = [[0,0],[0,-s+2*th],[hs,-s+2*th],[hs,0],[hs-th,0], [hs-th,-s+3*th],[th,-s+3*th],[th,0]];break;	
			case "o":
					polygon = [[hs, 0], [hs, -s+2*th],[hs-th,-s+2*th],[hs-th,0-1*th],[0+th,0-1*th],[0+th,-s+3*th],[hs-th,-s+3*th],[hs-th,-s+2*th],[0,-s+2*th],[0,0]]; break;																																	
			case "p"://todo
					polygon = [[hs, 0], [hs, -s+2*th],[hs-th,-s+2*th],[hs-th,0-1*th],[0+th,0-1*th],[0+th,-s+3*th],[hs-th,-s+3*th],[hs-th,-s+2*th],[0,-s+2*th],[0,0]]; break;
			case "r":
					polygon = [[0,0],[0,-s+2*th],[hs,-s+2*th],[hs,-s+3.5*th],[hs-th,-s+3.5*th], [hs-th,-s+3*th],[th,-s+3*th],[th,0]];break;	
			case "s":
					polygon = [[0,0],[hs,0],[hs,0-mUp],[th,0-mUp],[th,-s+th],[hs,-s+th],[hs,-s],[0,-s],[0,0-mDn],[hs-th,0-mDn],[hs-th,0-th],[0,0-th],[0,0]  ];break;	
			case "t":
					polygon = [[hs-th, 0],[hs-th,0-mDn],[hs,0-mDn],[hs,0-mUp],[hs-th,0-mUp],[hs-th,-s],[hs-2*th,-s],[hs-2*th,0-mUp],[hs-3*th,0-mUp],[hs-3*th,0-mDn],[hs-2*th,0-mDn],[hs-2*th,0]];break;
			case "u":
					polygon = [[0,0],[0,-s+2*th],[th,-s+2*th],[th,0-th],[hs-th,0-th], [hs-th,-s+2*th],[hs,-s+2*th],[hs,0],[0,0]];break;
			case "w":
					polygon = [[0,0],[0,-s+th],[th,-s+th],[th,0-th],[2*th,0-th],[2*th,-s+th],[3*th,-s+th],[3*th,0-th],[4*th,0-th],[4*th,-s+th],[5*th,-s+th],[5*th,0],[0,0]];break;																																		
			}
			
		//polygon = [[hs+100, 0+100], [hs+100, -s+100],[hs-2*th+100,-s+100],[hs-2*th+100,-s+th+100],[hs-th+100,-s+th+100],[hs-th+100,0+100]];
	
		return polygon;
	
	
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