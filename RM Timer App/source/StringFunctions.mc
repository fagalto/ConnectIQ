class StringFunctions {

function initialize() {

}

function replace(what,toWhat,text) {

	if(text.find(what)==null){
		return text;
		
	}
	else{
	var replaced = text.substring(0,text.find(what))+toWhat+text.substring(text.find(what)+what.length(),text.length());
		return replaced;
	}
}


}