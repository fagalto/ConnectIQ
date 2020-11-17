
class symbolRenderer {
var _dc;
public var _themeColor;
public var _bgColor;
	// Constructor
    function initialize(dc) {
        _dc = dc;
    }



function renderSymbol(x,y,fieldType,FieldColor) {
var s = 15;
var polygon = null;
var polygon1 = null;
var polygon2 = null;
var complicatedIcon = new[2];
_dc.setColor(_themeColor, _bgColor);
_dc.setPenWidth(1);
//assume bitmap size is14//38349
		switch ( fieldType ) {
		case 0: //steps
		//polygon = [[4, 0], [4, -1],[5,-1],[5,-2],[6,-5],[6,-9],[5,-10],[1,-10],[0,-9],[0,-8],[1,-7],[3,-7],[3,-4],[2,-3],[1,-2],[1,-1],[2,0]];//definitely to improve
		//polygon = [[3,0],[4,-1],[4,-2],[3,-3],[2,-4],[2,-5],[3,-6],[4,-7],[6,-7],[6,-10],[1,-10],[0,-9],[0,-1],[1,0]];//definitely to improve
		polygon1 = [[3, -2], [4,-3],[4,-4],[2,-6],[2,-10],[4,-12],[5,-12],[7,-13],[7,-14],[6,-15],[1,-15],[0,-12],[0,-5],[1,-5],[1,-3],[2,-2]];
		polygon2 = [[13, -2], [14,-3],[14,-5],[15,-5],[15,-13],[14,-15],[9,-15],[8,-14],[8,-13],[10,-12],[11,-12],[13,-10],[13,-6],[11,-4],[11,-3],[12,-2]];
		//polygon2 = [[15,-5],[15,-11],[14,-13],[9,-13],[8,-12],[8,-11],[10,-10],[11,-10],[13,-8],[13,-5]];
		complicatedIcon = [polygon1,polygon2];
		for(var i =0;i<complicatedIcon.size();i++){
	complicatedIcon[i] =	PolyTranslate(complicatedIcon[i],x-3*i,y+5*i);	
			
			_dc.fillPolygon(complicatedIcon[i]);		
		}
		 
		break;	
		case 1: //Calories
		polygon2 = [[10, 0], [11,-1],[12,-1],[13,-2],[14,-3],[14,-5],[13,-6],[13,-7],[12,-8],[12,-10],[13,-11],[13,-12],[14,-13],[15,-14],[15,-15],
		
		[13,-15],[12,-14],[11,-14],[10,-13],[9,-12],[8,-12],[7,-11],[6,-10],[5,-9],[5,-8],[4,-7],[4,-6],[3,-4],[3,-3],[4,-2],[5,-1],[6,0],[10,0]];
		
		var polygon3 = [[10,-2],[11,-3],[12,-4],[11,-5],[11,-6],[10,-7],[10,-10],[9,-10],[8,-9],[7,-8],[7,-7],[6,-6],[6,-5],[5,-4],[6,-3],[7,-2]];
		polygon2 =	PolyTranslate(polygon2,x-1,y);	
		polygon3 =	PolyTranslate(polygon3,x-1,y);	
		DrawPoly(polygon2);
		_dc.fillPolygon(polygon3);
		break;	
		case 2: //Temperature
		polygon2 = [[7,0],[8,-1],[8,-4],[7,-5],[7,-7],[10,-7],[7,-7],[7,-10],[10,-10],[7,-10],[7,-13],[10,-13],[7,-13],[7,-14],[6,-15],[4,-15],[3,-14],[3,-5],[2,-4],[2,-1],[3,0],[7,0]];
		polygon2 =	PolyTranslate(polygon2,x,y);	
		var mercury = [[4,-2],[6,-2],[6,-3],[5,-3],[5,-10],[5,-3],[4,-3],[4,-2]];
		mercury =	PolyTranslate(mercury,x,y);	
			DrawPoly(polygon2);
			DrawPoly(mercury);
			
		break;	
		case 3: //Battery
		var	myStats = System.getSystemStats();
				var batLvl =myStats.battery;

		batLvl=-1*Math.floor(1.3*batLvl/10);
		//System.println(batLvl);
		polygon2 = [[8,0],[8,-13],[6,-13],[6,-15],[2,-15],[2,-13],[0,-13],[0,0],[8,0]];
		polygon2 =	PolyTranslate(polygon2,x+1,y);	
		var batLvlLine = [[8,-1],[8,batLvl],[2,batLvl],[2,-1],[9,-1]];
		
		batLvlLine =	PolyTranslate(batLvlLine,x,y);	
		DrawPoly(polygon2);
		_dc.fillPolygon(batLvlLine);
		if(batLvl==-13)
			{
			var batFull = [[6,-14],[2,-14]];
			batFull =	PolyTranslate(batFull,x,y);	
			DrawPoly(batFull);
			}		
		break;	
		case 4: //HeartRate
		polygon = [[6,0],[12,-8], [12,-12],[10,-15],[9,-15],[6,-12],[3,-15],[2,-15],[0,-12],[0,-8],[6,0]];
		break;	
		case 5: //Floors
		polygon = [[0, 0], [3,0],[3,-3],[6,-3],[6,-6],[9,-6],[9,-9],[12,-9],[12,-12],[15,-12],[15,-13],[11,-13], [11,-10],[8,-10],[8,-7],[5,-7],[5,-4],[2,-4],[2,-1],[0,-1]];
		break;	
		case 6: //Altitude
		polygon = [[0, 0], [12,0],[9,-13],[6,-5],[4,-10]];
		break;
		case 7: //Messages
		polygon1 = [[2, -3], [13, -3],[13,-13],[9,-9],[6,-9],[2,-13],[13,-13],[2,-13],[2,-3]];
		polygon1 =	PolyTranslate(polygon1,x,y);	
		DrawPoly(polygon1);
		break;	
		case 8: //Memory
		polygon1 = [[3, -3], [12, -3],[12,-5],[14,-5],[12,-5],[12,-7],[14,-7],[12,-7], [12,-9],[14,-9],[12,-9] ,[12,-11],[14,-11],[12,-11], [12,-13],[3,-13], 
		[3,-11],[1,-11],[3,-11]  ,  [3,-9],[1,-9],[3,-9] , [3,-7],[1,-7],[3,-7], [3,-5],[1,-5],[3,-5], [3,-3]];
		polygon1 =	PolyTranslate(polygon1,x,y);	
		DrawPoly(polygon1);
		break;			
		default:
		polygon = [[s*0.33, 0], [s, -s*0.67],[s*0.67,-s],[0,-s*0.33]];
		break;										
	}
	if(polygon !=null){
	polygon =	PolyTranslate(polygon,x,y);	
			_dc.setColor(_themeColor, _bgColor);
			_dc.fillPolygon(polygon);
	}
			
}

function DrawPoly(polygon) {
		for(var i=1;i<polygon.size();i++)
			{
			_dc.drawLine(polygon[i-1][0], polygon[i-1][1], polygon[i][0], polygon[i][1]);
			}
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