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
        

       

        availableColors[4]=["Indigo",0x5500AA];
        availableColors[5]=["Purple",0xAA00FF];
        availableColors[6]=["Pink",0xFF0055];
 		availableColors[7]=["Blue Grey",0x5555AA];         
        availableColors[8]=["Blue",0x0055AA];
         
        availableColors[9]=["Light Blue",0x00AAFF];
       
        availableColors[10]=["Teal",0x00FFFF];
        availableColors[11]=["Ocean Blue",0x00FFAA]; 
		availableColors[14]=["Lime",0xAAFF55];      
        availableColors[12]=["Green",0x00FF00];        
        availableColors[13]=["Dark Green",0x005500];

        
        availableColors[15]=["Yellow",0xFFFF55];
        
        availableColors[16]=["Amber",0xFFAA00];
        availableColors[17]=["Light Brown",0xAA5500];
        availableColors[18]=["Orange",0xFF5500];
       
        availableColors[19]=["Red",0xFF0000];
        availableColors[20]=["Dark Red",0xAA0005];
		
        
       
        availableColors[21]=["Brown",0x550000];
        
    /********************
    var i=0;
	availableColors[i]=["0x000000",0x000000];
i++; availableColors[i]=["0x000055",0x000055];
i++; availableColors[i]=["0x0000AA",0x0000AA];
i++; availableColors[i]=["0x0000FF",0x0000FF];
i++; availableColors[i]=["0x005500",0x005500];
i++; availableColors[i]=["0x005555",0x005555];
i++; availableColors[i]=["0x0055AA",0x0055AA];
i++; availableColors[i]=["0x0055FF",0x0055FF];
i++; availableColors[i]=["0x00AA00",0x00AA00];
i++; availableColors[i]=["0x00AA55",0x00AA55];
i++; availableColors[i]=["0x00AAAA",0x00AAAA];
i++; availableColors[i]=["0x00AAFF",0x00AAFF];
i++; availableColors[i]=["0x00FF00",0x00FF00];
i++; availableColors[i]=["0x00FF55",0x00FF55];
i++; availableColors[i]=["0x00FFAA",0x00FFAA];
i++; availableColors[i]=["0x00FFFF",0x00FFFF];
i++; availableColors[i]=["0x550000",0x550000];
i++; availableColors[i]=["0x550055",0x550055];
i++; availableColors[i]=["0x5500AA",0x5500AA];
i++; availableColors[i]=["0x5500FF",0x5500FF];
i++; availableColors[i]=["0x555500",0x555500];
i++; availableColors[i]=["0x555555",0x555555];
i++; availableColors[i]=["0x5555AA",0x5555AA];
i++; availableColors[i]=["0x5555FF",0x5555FF];
i++; availableColors[i]=["0x55AA00",0x55AA00];
i++; availableColors[i]=["0x55AA55",0x55AA55];
i++; availableColors[i]=["0x55AAAA",0x55AAAA];
i++; availableColors[i]=["0x55AAFF",0x55AAFF];
i++; availableColors[i]=["0x55FF00",0x55FF00];
i++; availableColors[i]=["0x55FF55",0x55FF55];
i++; availableColors[i]=["0x55FFAA",0x55FFAA];
i++; availableColors[i]=["0x55FFFF",0x55FFFF];
i++; availableColors[i]=["0xAA0000",0xAA0000];
i++; availableColors[i]=["0xAA0055",0xAA0055];
i++; availableColors[i]=["0xAA00AA",0xAA00AA];
i++; availableColors[i]=["0xAA00FF",0xAA00FF];
i++; availableColors[i]=["0xAA5500",0xAA5500];
i++; availableColors[i]=["0xAA5555",0xAA5555];
i++; availableColors[i]=["0xAA55AA",0xAA55AA];
i++; availableColors[i]=["0xAA55FF",0xAA55FF];
i++; availableColors[i]=["0xAAAA00",0xAAAA00];
i++; availableColors[i]=["0xAAAA55",0xAAAA55];
i++; availableColors[i]=["0xAAAAAA",0xAAAAAA];
i++; availableColors[i]=["0xAAAAFF",0xAAAAFF];
i++; availableColors[i]=["0xAAFF00",0xAAFF00];
i++; availableColors[i]=["0xAAFF55",0xAAFF55];
i++; availableColors[i]=["0xAAFFAA",0xAAFFAA];
i++; availableColors[i]=["0xAAFFFF",0xAAFFFF];
i++; availableColors[i]=["0xFF0000",0xFF0000];
i++; availableColors[i]=["0xFF0055",0xFF0055];
i++; availableColors[i]=["0xFF00AA",0xFF00AA];
i++; availableColors[i]=["0xFF00FF",0xFF00FF];
i++; availableColors[i]=["0xFF5500",0xFF5500];
i++; availableColors[i]=["0xFF5555",0xFF5555];
i++; availableColors[i]=["0xFF55AA",0xFF55AA];
i++; availableColors[i]=["0xFF55FF",0xFF55FF];
i++; availableColors[i]=["0xFFAA00",0xFFAA00];
i++; availableColors[i]=["0xFFAA55",0xFFAA55];
i++; availableColors[i]=["0xFFAAAA",0xFFAAAA];
i++; availableColors[i]=["0xFFAAFF",0xFFAAFF];
i++; availableColors[i]=["0xFFFF00",0xFFFF00];
i++; availableColors[i]=["0xFFFF55",0xFFFF55];
i++; availableColors[i]=["0xFFFFAA",0xFFFFAA];
i++; availableColors[i]=["0xFFFFFF",0xFFFFFF];   
*********************/   
      
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
			           		
			           		 bgMenu.addItem(new CustomItem(availableColors[i][1], availableColors[i][0],false));
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
			           		
			           		 fgMenu.addItem(new CustomItem(availableColors[i][1], availableColors[i][0],false));
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
			           		
			           		 themeMenu.addItem(new CustomItem(availableColors[i][1], availableColors[i][0],false));
			            	}
			        var themeColor = themeMenu.findItemById(thC);
 						themeMenu.setFocus(themeColor);  			            					    
				    WatchUi.pushView(themeMenu, new BasicCustomDelegate("ThemeColor"), WatchUi.SLIDE_UP );          		 
          		 
        }else if( item.getId().equals(6) ) {
        //Theme Color
						var hoursC = Application.getApp().getProperty("HoursColor");
           			var hoursColor = new BasicCustomMenu(35,Graphics.COLOR_WHITE,{
				        :focusItemHeight=>45,
				        :foreground=>new Rez.Drawables.MenuForeground(),
				        :title=>new DrawableMenuTitle("Hours Color",hoursC),
				        :footer=>new DrawableMenuFooter()
				    });
			        for (var i=0;i<availableColors.size();i++)
			            	{
			           		
			           		 hoursColor.addItem(new CustomItem(availableColors[i][1], availableColors[i][0],false));
			            	}
			        var hoursCurrentColor = hoursColor.findItemById(hoursC);
 						hoursColor.setFocus(hoursCurrentColor);  			            					    
				    WatchUi.pushView(hoursColor, new BasicCustomDelegate("HoursColor"), WatchUi.SLIDE_UP );          		 
          		 
        }
        
		else if( item.getId().equals(4) ) { 
        //displayseconds
				if(item.isEnabled())
				{
	        	Application.getApp().setProperty("displaySeconds", true);
	        	}
	        	else
	        		{
	        		Application.getApp().setProperty("displaySeconds", false);
	        		}
	        		
        
        }else if( item.getId().equals(20) ) { 
        //displayseconds
				if(item.isEnabled())
				{
	        	Application.getApp().setProperty("btStatus", true);
	        	}
	        	else
	        		{
	        		Application.getApp().setProperty("btStatus", false);
	        		}
        }                  
         else {
            WatchUi.requestUpdate();
        }
            
       // Storage.setValue(menuItem.getId(), menuItem.isEnabled());
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
	var sRenderer;
	var id;
	var drawIcon;
	
    function initialize(idd, label,icon) {
    	id = idd;
        CustomMenuItem.initialize(id, {});
        mLabel = label;
        color = idd;
        drawIcon = icon;
        
    }

    // draw the item string at the center of the item.
    function draw(dc) {
        var font;
        var fcolor;
      
        if( isFocused() ) {
            font = Graphics.FONT_LARGE;
            fcolor = Graphics.COLOR_BLACK;
        } else {
            font = Graphics.FONT_SMALL;
             fcolor = Graphics.COLOR_DK_GRAY;
        }

        if( isSelected() ) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }

        dc.setColor(fcolor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/4, dc.getHeight()/2, font, mLabel, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        
        //dc.drawLine(0, 0, dc.getWidth(), 0);
        
        if(drawIcon)
        	{
        	dc.setColor(fcolor, Graphics.COLOR_BLACK);
        	}
        else
        	{
        	dc.setColor(color, Graphics.COLOR_BLACK);
        	dc.fillRectangle(0,0,dc.getWidth()/5,dc.getHeight());
        	}
        
        
       // dc.drawLine(0, dc.getHeight() - 1, dc.getWidth(), dc.getHeight() - 1);
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


        	color = Graphics.COLOR_WHITE;
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