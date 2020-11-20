//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Application.Storage;
using Toybox.Graphics;



class PureSettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize(null);
        Menu2.setTitle("Settings");
    }
}

class PureSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
var availableColors = new[22];
    function initialize() {
        Menu2InputDelegate.initialize();
        
        availableColors[0]=["Black",0x000000];
        availableColors[1]=["White",0xFFFFFF];
        availableColors[2]=["Light Gray",0xAAAAAA];
        availableColors[3]=["Dark Gray",0x555555];
        availableColors[4]=["Red",0xFF0000];
        availableColors[5]=["Green",0x00FF00];
        availableColors[6]=["Pink",0xAA0005];
        availableColors[7]=["Purple",0xAA00FF];
        availableColors[8]=["DeepPurple",0xFF0055];
        availableColors[9]=["Indigo",0x5500AA];
        availableColors[10]=["Blue",0x0055AA];
        availableColors[11]=["LightBlue",0x00AAFF];
        availableColors[12]=["Teal",0x00FFFF];
        availableColors[13]=["DarkGreen",0x00FF55];
        availableColors[14]=["LightGreen",0x00FFAA];
        availableColors[15]=["Lime",0xAAFF55];
        availableColors[16]=["Yellow",0xFFFF55];
        availableColors[17]=["Amber",0xFFAA00];
        availableColors[18]=["Orange",0xFF5500];
        availableColors[19]=["DeepOrange",0xAA5500];
        availableColors[20]=["Brown",0x550000];
        availableColors[21]=["BlueGrey",0x5555AA]; 
        
    }

    function onSelect(item) {


        if( item.getId().equals(1) ) {
 
         		 var bgMenu = new WatchUi.Menu2({:title=>"Background Color"});

         		 
			            for (var i=0;i<4;i++)
			            	{
			           		 bgMenu.addItem(new WatchUi.MenuItem(availableColors[i][0], null, availableColors[i][1], null));	
			           		
			            	}
 
           		 WatchUi.pushView(bgMenu, new ColorChangeDelegate("BackgroundColor"), WatchUi.SLIDE_UP );
           		 
        } else if ( item.getId().equals(2) ) {
        //Bg Color
            var fgMenu = new WatchUi.Menu2({:title=>"Foreground Color"});
		           
		            for (var i=0;i<availableColors.size();i++)
		            	{
		           		 fgMenu.addItem(new WatchUi.MenuItem(availableColors[i][0], null, availableColors[i][1], null));	
		            	}            
          	
           		WatchUi.pushView(fgMenu, new ColorChangeDelegate("ForegroundColor"), WatchUi.SLIDE_UP ); 
        } else if( item.getId().equals(3) ) {
        //Theme Color
        	 var themeMenu = new WatchUi.Menu2({:title=>"Theme Color"});
		             for (var i=0;i<availableColors.size();i++)
		            	{
		           			 themeMenu.addItem(new WatchUi.MenuItem(availableColors[i][0], null, availableColors[i][1], null));	
		            	}   
          		 WatchUi.pushView(themeMenu, new ColorChangeDelegate("ThemeColor"), WatchUi.SLIDE_UP );
          		 
          		 
        } else if( item.getId().equals(4) ) { 
        //displayseconds
				if(item.isEnabled())
				{
	        	Application.getApp().setProperty("displaySeconds", true);
	        	}
	        	else
	        		{
	        		Application.getApp().setProperty("displaySeconds", false);
	        		}
        } else {
            WatchUi.requestUpdate();
        }
            
       // Storage.setValue(menuItem.getId(), menuItem.isEnabled());
    }
}
class ColorChangeDelegate extends WatchUi.Menu2InputDelegate {
var title;
    function initialize(gotTitle) {
        Menu2InputDelegate.initialize();
        title =gotTitle;
    }

    function onSelect(item) {
        var id = item.getId();


	Application.getApp().setProperty(title, id);
	 WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}


