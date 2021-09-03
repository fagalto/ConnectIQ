class VdotCalculator {
var vDot;
var racePaces;
var paceDistances;

function initialize(vDotFromSettings) {

me.vDot = vDotFromSettings.toNumber();
me.racePaces = {};
me.paceDistances = ["400",
					"600",
					"800",
					"1K",
					"1,5K",
					"Mi",
					"2K",
					"3K",
					"4K",
					"5K",
					"7K",
					"10K",
					"15K",
					"HM",
					"M",
					"F",
					"R",
					"I",
					"T",
					"Easy"];
me.calculateRacePaces();					
}

function calculateRacePaces(){
var paceInSeconds = 200; 
	for(var i=0;i<me.paceDistances.size();i++){
		paceInSeconds = calclulateIntensity(me.paceDistances[i]);
		me.racePaces.put(me.paceDistances[i],paceInSeconds);
		
		}
	}
function calclulateIntensity(distance){
switch(distance) {

case "400": return 1000/400.0*(148.354+3.68756*me.vDot-0.370638*Math.pow(me.vDot,2)+0.010114*Math.pow(me.vDot,3)-1.34693*Math.pow(10,-4)*Math.pow(me.vDot,4)+8.99258*Math.pow(10,-7)*Math.pow(me.vDot,5)-2.41035*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "600": return 1000/600.0*(236.607+5.87613*me.vDot-0.590611*Math.pow(me.vDot,2)+0.0161166*Math.pow(me.vDot,3)-2.14633*Math.pow(10,-4)*Math.pow(me.vDot,4)+1.43297*Math.pow(10,-6)*Math.pow(me.vDot,5)-3.84089*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "800": return 1000/800.0*(326.378+8.11264*me.vDot-0.815403*Math.pow(me.vDot,2)+0.0222507*Math.pow(me.vDot,3)-2.96325*Math.pow(10,-4)*Math.pow(me.vDot,4)+1.97837*Math.pow(10,-6)*Math.pow(me.vDot,5)-5.30277*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "1K": return (422.859+10.9971*me.vDot-1.08137*Math.pow(me.vDot,2)+0.0294181*Math.pow(me.vDot,3)-3.91365*Math.pow(10,-4)*Math.pow(me.vDot,4)+2.61181*Math.pow(10,-6)*Math.pow(me.vDot,5)-6.9998*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "1,5K": return 1000/1500.0*(1396.01-51.7052*me.vDot+0.96528*Math.pow(me.vDot,2)-7.86847*Math.pow(10,-3)*Math.pow(me.vDot,3)-5.95299*Math.pow(10,-6)*Math.pow(me.vDot,4)+4.979495*Math.pow(10,-7)*Math.pow(me.vDot,5)-2.22219*Math.pow(10,-9)*Math.pow(me.vDot,6));break;
case "Mi": return 1000/1609.344*(961.34-5.96125*me.vDot-0.806084*Math.pow(me.vDot,2)+0.0271493*Math.pow(me.vDot,3)-3.841382*Math.pow(10,-4)*Math.pow(me.vDot,4)+2.62563*Math.pow(10,-6)*Math.pow(me.vDot,5)-7.11111*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "2K": return 1000/2000.0*(1860.398-65.2526*me.vDot+1.11848*Math.pow(me.vDot,2)-7.39154*Math.pow(10,-3)*Math.pow(me.vDot,3)-3.30646*Math.pow(10,-5)*Math.pow(me.vDot,4)+7.27314*Math.pow(10,-7)*Math.pow(me.vDot,5)-2.85808*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "3K": return 1000/3000.0*(3385.55-151.535*me.vDot+3.796225*Math.pow(me.vDot,2)-0.0556282*Math.pow(me.vDot,3)+4.730126*Math.pow(10,-4)*Math.pow(me.vDot,4)-2.14923*Math.pow(10,-6)*Math.pow(me.vDot,5)+4*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "4K": return 1000/4000.0*(4825.24-234.8568*me.vDot+6.53804*Math.pow(me.vDot,2)-0.1083596*Math.pow(me.vDot,3)+10.62228*Math.pow(10,-4)*Math.pow(me.vDot,4)-5.69456*Math.pow(10,-6)*Math.pow(me.vDot,5)+12.88244*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "5K": return 1000/5000.0*(3980.898-112.18299*me.vDot+1.6454301*Math.pow(me.vDot,2)-0.0120723*Math.pow(me.vDot,3)+3.519734*Math.pow(10,-5)*Math.pow(me.vDot,4)); break;
case "7K": return 1000/7000.0*(8713.32-448.469*me.vDot+13.53086*Math.pow(me.vDot,2)-0.2442426*Math.pow(me.vDot,3)+26.01137*Math.pow(10,-4)*Math.pow(me.vDot,4)-15.06435*Math.pow(10,-6)*Math.pow(me.vDot,5)+36.56506*Math.pow(10,-9)*Math.pow(me.vDot,6)); break;
case "10K": return 1000/10000.0*(10803.97-448.843*me.vDot+10.8801*Math.pow(me.vDot,2)-0.159103*Math.pow(me.vDot,3)+1.38731*Math.pow(10,-3)*Math.pow(me.vDot,4)-6.63077*Math.pow(10,-6)*Math.pow(me.vDot,5)+1.33333*Math.pow(10,-8)*Math.pow(me.vDot,6));break;
case "15K": return 1000/15000.0*(14678.4-514.218*me.vDot+10.259*Math.pow(me.vDot,2)-0.120868*Math.pow(me.vDot,3)+8.29957*Math.pow(10,-4)*Math.pow(me.vDot,4)-3.03077*Math.pow(10,-6)*Math.pow(me.vDot,5)+4.44444*Math.pow(10,-9)*Math.pow(me.vDot,6));break;
case "HM": return 1000/21097.0*(17336.69-375.5651*me.vDot+0.3070031*Math.pow(me.vDot,2)+0.129004*Math.pow(me.vDot,3)-2.3418409*Math.pow(10,-3)*Math.pow(me.vDot,4)+1.7420491*Math.pow(10,-5)*Math.pow(me.vDot,5)-4.888889*Math.pow(10,-8)*Math.pow(me.vDot,6));break;
case "M": return 1000/42195.0*(51775.699-2338.699999*me.vDot+62.891699*Math.pow(me.vDot,2)-1.0257101*Math.pow(me.vDot,3)+9.976018*Math.pow(10,-3)*Math.pow(me.vDot,4)-5.32359999*Math.pow(10,-5)*Math.pow(me.vDot,5)+1.2*Math.pow(10,-7)*Math.pow(me.vDot,6));break;
case "F": return((1189.326-34.7267*me.vDot+0.520149*Math.pow(me.vDot,2)-3.905221*Math.pow(10,-3)*Math.pow(me.vDot,3)+1.1655*Math.pow(10,-5)*Math.pow(me.vDot,4))*1000/1609.344);break;
case "R": return ((1204.7513-34.69981*me.vDot+0.5200425*Math.pow(me.vDot,2)-3.909968*Math.pow(10,-3)*Math.pow(me.vDot,3)+1.169418*Math.pow(10,-5)*Math.pow(me.vDot,4))*1000/1609.344); break;
case "I": return((1228.752-34.69981*me.vDot+0.5200425*Math.pow(me.vDot,2)-3.90997*Math.pow(10,-3)*Math.pow(me.vDot,3)+1.16942*Math.pow(10,-5)*Math.pow(me.vDot,4))*1000/1609.344); break;
case "T": return ((1392.5865-40.8875*me.vDot+0.6279977*Math.pow(me.vDot,2)-4.76957*Math.pow(10,-3)*Math.pow(me.vDot,3)+1.42131*Math.pow(10,-5)*Math.pow(me.vDot,4))*1000/1609.344);break;
case "Easy": return (360);break;
//return marathon Pace by default;
default: return 1000/42195.0*(51775.699-2338.699999*me.vDot+62.891699*Math.pow(me.vDot,2)-1.0257101*Math.pow(me.vDot,3)+9.976018*Math.pow(10,-3)*Math.pow(me.vDot,4)-5.32359999*Math.pow(10,-5)*Math.pow(me.vDot,5)+1.2*Math.pow(10,-7)*Math.pow(me.vDot,6));break;

}

}
function secondsToPace(seconds) {
var minutes = Math.floor(seconds/60).format("%i");
var secs = (seconds-60*Math.floor(seconds/60)).format("%.01f");

var formattedSeconds = (secs.toNumber()<10)?("0"+secs.toString()):(secs);
return minutes+":"+formattedSeconds;
}




}