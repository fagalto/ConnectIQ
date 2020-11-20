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
           				 var bgC = Application.getApp().getProperty("BackgroundColor");
				     var bgMenu = new BasicCustomMenu(35,Graphics.COLOR_WHITE,{
				        :focusItemHeight=>45,
				        :foreground=>new Rez.Drawables.MenuForeground(),
				        :title=>new DrawableMenuTitle("BackgroundColor",bgC),
				        :footer=>new DrawableMenuFooter()
				    });
			        for (var i=0;i<4;i++)
			            	{
			           		
			           		 bgMenu.addItem(new CustomItem(availableColors[i][1], availableColors[i][0]));
			            	}
			        var bgColor = bgMenu.findItemById(bgC);
 						bgMenu.setFocus(bgColor); 			            					    
				    WatchUi.pushView(bgMenu, new BasicCustomDelegate("BackgroundColor"), WatchUi.SLIDE_UP );	          				 
           				 
           				 
           				 
           		 
        } else if ( item.getId().equals(2) ) {
        //Bg Color 
           				
           				 var fgC = Application.getApp().getProperty("ForegroundColor");
           			var fgMenu = new BasicCustomMenu(35,Graphics.COLOR_WHITE,{
				        :focusItemHeight=>45,
				        :foreground=>new Rez.Drawables.MenuForeground(),
				        :title=>new DrawableMenuTitle("Foreground Color",fgC),
				        :footer=>new DrawableMenuFooter()
				    });
			        for (var i=0;i<availableColors.size();i++)
			            	{
			           		
			           		 fgMenu.addItem(new CustomItem(availableColors[i][1], availableColors[i][0]));
			            	}
			        var fgColor = fgMenu.findItemById(fgC);
 						fgMenu.setFocus(fgColor);  			            					    
				    WatchUi.pushView(fgMenu, new BasicCustomDelegate("ForegroundColor"), WatchUi.SLIDE_UP );
           				
           				
        } else if( item.getId().equals(3) ) {
        //Theme Color
						var thC = Application.getApp().getProperty("ThemeColor");
           			var themeMenu = new BasicCustomMenu(35,Graphics.COLOR_WHITE,{
				        :focusItemHeight=>45,
				        :foreground=>new Rez.Drawables.MenuForeground(),
				        :title=>new DrawableMenuTitle("Theme Color",thC),
				        :footer=>new DrawableMenuFooter()
				    });
			        for (var i=0;i<availableColors.size();i++)
			            	{
			           		
			           		 themeMenu.addItem(new CustomItem(availableColors[i][1], availableColors[i][0]));
			            	}
			        var themeColor = themeMenu.findItemById(thC);
 						themeMenu.setFocus(themeColor);  			            					    
				    WatchUi.pushView(themeMenu, new BasicCustomDelegate("ThemeColor"), WatchUi.SLIDE_UP );          		 
          		 
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
	        		
        }         
         else {
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

class BasicCustomMenu extends WatchUi.CustomMenu {

    var mTitle;

    function initialize( itemHeight, backgroundColor, options ) {
        mTitle = options.get(:title);
        WatchUi.CustomMenu.initialize( itemHeight, backgroundColor, options );
    }

    function drawTitle( dc ) {
        if( mTitle != null ) {
            if( Toybox.WatchUi.CustomMenu has :isTitleSelected ) {
               mTitle.setSelected(isTitleSelected());
            }
        }
        WatchUi.CustomMenu.drawTitle(dc);
    }

    function drawFooter( dc ) {
        if( Toybox.WatchUi.CustomMenu has :isFooterSelected ) {
            if( isFooterSelected() ) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
                dc.clear();
            }
        }
        WatchUi.CustomMenu.drawFooter(dc);
    }
}

//This is the menu input delegate shared by all the basic sub-menus in the application
class BasicCustomDelegate extends WatchUi.Menu2InputDelegate {
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

    function onWrap(key) {
        //Disallow Wrapping
        return false;
    }
}

// This is the custom item drawable.
// It draws the label it is initialized with at the center of the region
class CustomItem extends WatchUi.CustomMenuItem {
    var mLabel;
    var color;

    function initialize(id, label) {
        CustomMenuItem.initialize(id, {});
        mLabel = label;
        color = id;
        if(color==null)
        	{
        	color = Graphics.COLOR_BLACK;
        	}
        	if(color == Graphics.COLOR_BLACK or color == Graphics.COLOR_WHITE)
        		{
        		color = Graphics.COLOR_DK_GRAY;
        		}
    }

    // draw the item string at the center of the item.
    function draw(dc) {
        var font;
        if( isFocused() ) {
            font = Graphics.FONT_LARGE;
        } else {
            font = Graphics.FONT_SMALL;
        }

        if( isSelected() ) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, font, mLabel, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(color, Graphics.COLOR_BLACK);
        //dc.drawLine(0, 0, dc.getWidth(), 0);
        dc.drawLine(0, dc.getHeight() - 1, dc.getWidth(), dc.getHeight() - 1);
    }
}
class DrawableMenuFooter extends WatchUi.Drawable {
    function initialize() {
        Drawable.initialize({});
    }

    // Draw bottom half of the last dividing line below the final item
    function draw(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawLine(0, 0, dc.getWidth(), 0);
    }
}
class DrawableMenuTitle extends WatchUi.Drawable {
    var mIsTitleSelected = false;
    var title;
    var color;

    function initialize(gotTitle, gotColor) {
        Drawable.initialize({});
        title = gotTitle;
        color = gotColor;
        if(color==null)
        	{
        	color = Graphics.COLOR_WHITE;
        	}
    }

    function setSelected(isTitleSelected) {
        mIsTitleSelected = isTitleSelected;
    }

    // Draw the application icon and main menu title
    function draw(dc) {
         var labelX = dc.getWidth() / 2;
        var labelY = dc.getHeight() / 2;
        var bkColor = mIsTitleSelected ? Graphics.COLOR_BLUE : Graphics.COLOR_BLACK;
        dc.setColor(bkColor, bkColor);
        dc.clear();

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(labelX, labelY, Graphics.FONT_MEDIUM, title, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}