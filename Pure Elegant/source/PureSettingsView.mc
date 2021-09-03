//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application.Storage;

class PureSettingsView extends WatchUi.View {

var i;

    function initialize() {
        View.initialize();

        i=false;
    }

    function onUpdate(dc) {
        dc.clearClip();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		//i++;
	
        //System.println("opening menu for "+i+"th time");
        if(i==false)
        {i = PureSettingsDelegate.onMenu();
        }
        else
        	{
		 dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, Graphics.FONT_SMALL, "Press Back again \nfor save", Graphics.TEXT_JUSTIFY_CENTER);
        Storage.setValue("SettingsChanged", true); 
        	}
    }
}

class PureSettingsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();

    }

    function onMenu() {
        var menu = new PureSettingsMenu();
        menu.addItem(new WatchUi.MenuItem("Background Color","Color of background" , 1, null));
        menu.addItem(new WatchUi.MenuItem("Foreground Color","color for minutes and data", 2, null));
        menu.addItem(new WatchUi.MenuItem("Theme Color", "Color of bar& data", 3, null));
        menu.addItem(new WatchUi.MenuItem("Hours Color", "Color of Hours", 6, null));
        var secEnabled = Application.getApp().getProperty("displaySeconds");
        menu.addItem(new WatchUi.ToggleMenuItem("Display Seconds", null, 4,secEnabled ,null));

        
		
        WatchUi.pushView( menu, new PureSettingsMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

