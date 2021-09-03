class SettingsParser  {

public var trainingSet;
public var trainingString;
public var trainingSetObject;

    function initialize() {
             me.trainingSet = Application.getApp().getProperty("ActiveTraining");
             me.trainingString = Application.getApp().getProperty("T_"+me.trainingSet);
        	//System.println("Initial tId is:"+me.trainingSet);
        	//System.println("Initial tStr is:"+me.trainingString);
					//        	onSettingsChanged();
    }


    
    
   	 function onSettingsChanged() {
   	 
    	me.trainingSet = Application.getApp().getProperty("ActiveTraining");
    	me.trainingString = Application.getApp().getProperty("T_"+me.trainingSet);
         	//System.println("Changed tId is:"+me.trainingSet);
        	//System.println("Changed tStr is:"+me.trainingString);    	
    	//parseTrainingStringToTimerObject();
    	
    }
 	
 	function parseTrainingStringToTimerObject() {
 	
 	//1.are there intervals?
 	var isBracket = 0;
 	var bracketStartPos = me.trainingString.find("x(");
 	if(bracketStartPos==null) {
 	bracketStartPos = me.trainingString.find("x");
 	} 
 	else
 		{
 		isBracket =1;
 		}
	bracketStartPos.toNumber();
 	var bracketEndPos = me.trainingString.find(")");
 	if(bracketEndPos==null) {
 	bracketEndPos = trainingString.length();
 	}
 	var noOfSets =0;
 	var stringLeft = me.trainingString;
 	//System.println("no of sets="+noOfSets);
 	if(bracketStartPos) {
	 	noOfSets = me.trainingString.substring(bracketStartPos-1,bracketStartPos);
	 	stringLeft = me.trainingString.substring(bracketStartPos+1+isBracket,bracketEndPos);
	 	
	 	}
 	else{
 		noOfSets = 1;
 		//stringLeft = 
 		}
 		var subsets = splitSubsetString(stringLeft);
 	 trainingSetObject = {"repeats" => noOfSets.toNumber(), "set" => subsets};
 	 ////now lets split subset
 	 
 	
 	
 	return trainingSetObject;
 	
 	}
 	
 	function splitSubsetString(subsetString) {
 	var set = {};
 	var i=0;
 	i++;
 	while(subsetString.find("+")!=null){
 	var split = subsetString.substring(0, subsetString.find("+"));
 	set.put("set"+i,singleSplitAnalyse(split));
 	i++;
 	//System.println("miniset is:"+miniset);
 	subsetString = subsetString.substring(subsetString.find("+")+1, subsetString.length());
 	}
 	set.put("set"+i,singleSplitAnalyse(subsetString));
 	return set;
 	
 	
 	}
 	function singleSplitAnalyse(split){
 	
 	//System.println("AnalysinSplit:"+split);
 	var splited = "";
 	var splitCount = split.find("x");
 	if(splitCount!=null)
 		{
 		splitCount = split.substring(splitCount-1,splitCount).toNumber();
 		var cleanSplit = split.substring(split.find("x")+1, split.length());
 		
 		splited = new [splitCount];
			 for (var i = 0; i < splitCount; i += 1) {
			
			splited[i]= splitDecode(cleanSplit);
	
 			}
 		}
 		else {splited = splitDecode(split);}
 		//System.println("split: "+splited+" has been repeated "+splitCount+ "times");
 	return splited;

 		
 	
 	}
 	function splitDecode(split) {
 	var splitDistance = 0;
 	var splitIntensity = "";
 	var splitRestTime = "0";
 	var isThereAnyBreak = split.find("/");
 	if(isThereAnyBreak !=null)
 	{
 	splitRestTime = split.substring(split.find("/")+1,split.length());
 	splitRestTime = StringFunctions.replace(",",".",splitRestTime).toNumber()*60;
 	}  	
 	if(split.find("@")!=null) {	
 	splitDistance = split.substring(0, split.find("@"));
 	splitIntensity = split.substring(split.find("@")+1,split.length());
 	 	if(isThereAnyBreak !=null)
 		{splitIntensity = split.substring(split.find("@")+1,split.find("/"));
 			}
 	}
 	else if(split.find("T")!=null) {	
 	splitDistance = split.substring(0, split.find("T"));
 	splitIntensity = "T";
 	} 	
 	else if(split.find("I")!=null) {	
 	splitDistance = split.substring(0, split.find("I"));
 	splitIntensity = "I";
 	}
 	else
 		{
 		return "there ws some problems with split data:["+split+"]";
 		}
 	return {
			 	"StepName"=>"Run",
			 	"Distance" =>splitDistance,
 				"Intensity"=>splitIntensity,
 				"RestTime"=>splitRestTime.toNumber()};
 	

 		 	
 	
 	
 	
 	}
	
}