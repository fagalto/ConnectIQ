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

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.clearClip();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, Graphics.FONT_SMALL, "Press Menu \nfor settings", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class PureSettingsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menu = new PureSettingsMenu();
        menu.addItem(new WatchUi.MenuItem("Background Color","Color of background" , 1, null));
        menu.addItem(new WatchUi.MenuItem("Foreground Color","Main Color for hours, date and data", 2, null));
        menu.addItem(new WatchUi.MenuItem("Theme Color", "Color of minutes&Icons", 3, null));
        var secEnabled = Application.getApp().getProperty("displaySeconds");
        
        menu.addItem(new WatchUi.ToggleMenuItem("Display Seconds", null, 4,secEnabled ,null));
        menu.addItem(new WatchUi.MenuItem("Seconds Color", "seconds indicator color", 5, null));
        for(var i=1;i<=6;i++)
        	{
        	 menu.addItem(new WatchUi.MenuItem("Field "+i, "Field Settings", 10+i, null));
        	}

        
		
        WatchUi.pushView( menu, new PureSettingsMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
}

