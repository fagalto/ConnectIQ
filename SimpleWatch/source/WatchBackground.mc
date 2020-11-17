using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as ActvMon;

class Background extends Ui.Drawable {

    var cals;
    var runicon;
    var baticon;
    var font;
    var statsfont;

    function initialize() {
        var dictionary = {
            :identifier => "Background",
            :locX => "0",
			:locY => "0",
            :width => "300",
			:height   => "300"
        };

        Drawable.initialize(dictionary);
        
         cals = Ui.loadResource(Rez.Drawables.cals);
       runicon = Ui.loadResource(Rez.Drawables.run);
        baticon = Ui.loadResource(Rez.Drawables.bat);
       font = Ui.loadResource(Rez.Fonts.id_font_c64);
       statsfont = Gfx.FONT_XTINY;

    }

    function draw(dc) {

        var time = makeClockTime();
         var stats = getStats();
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
		//clear screen;
        dc.clear();
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        //! Hour and minutes circle center - x only!!

        var vCenter = dc.getHeight()/2; //!y coordinate of circles
        var hCenter = dc.getWidth()/2; //!y coordinate of circles
        var firslineheight = dc.getHeight()*0.70;
        var linestart =  dc.getWidth()*0.15;
        var linewidth = dc.getWidth()*0.85;
        var secondlineheight = dc.getHeight()*0.30;
        
        var battxtypos = dc.getHeight()*0.82;
        var battxtxpos = dc.getWidth()*0.5;
        var statstxtheight = dc.getHeight()*0.71;
        var statstxtwidth = dc.getWidth()*0.45;
        var statstxtwidth2 = dc.getWidth()*0.55;
        
        var dateheight = dc.getHeight()*0.18;
        var datewidth = dc.getWidth()*0.5;
        
        //lines
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
  			dc.drawLine(linestart,firslineheight,linewidth,firslineheight);
  			dc.drawLine(linestart,secondlineheight,linewidth,secondlineheight);
  			dc.drawLine(hCenter,firslineheight*1.03, hCenter,firslineheight*1.02+Gfx.getFontHeight(statsfont));
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);	
		//hour
        	dc.drawText(hCenter, vCenter-Gfx.getFontHeight(font)/2 , font, time, Gfx.TEXT_JUSTIFY_CENTER);
 
       var calstxtx = statstxtwidth-dc.getTextWidthInPixels(stats[1].toString(), statsfont)-28;
       
       dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
       
      		dc.drawBitmap(statstxtwidth2, statstxtheight, runicon);
        	dc.drawBitmap(calstxtx, statstxtheight-10, cals);
        	
        	//
        	
        	dc.drawText(statstxtwidth,statstxtheight , statsfont, stats[1], Gfx.TEXT_JUSTIFY_RIGHT);
        	dc.drawText(statstxtwidth2+20,statstxtheight , statsfont, stats[2], Gfx.TEXT_JUSTIFY_LEFT);
          //date
        	dc.drawText(datewidth,dateheight , statsfont, stats[3]+" "+stats[4]+" "+stats[5]+" "+stats[6], Gfx.TEXT_JUSTIFY_CENTER);
          // stats	
           var battxtwidth = dc.getTextWidthInPixels(stats[0].toString(), statsfont);
          dc.drawBitmap(battxtxpos-battxtwidth-9, battxtypos, baticon);
        	dc.drawText(battxtxpos+10,battxtypos-5 , statsfont, stats[0]+"%", Gfx.TEXT_JUSTIFY_CENTER);   


    }
    
        hidden function makeClockTime()
    {
        var clockTime = Sys.getClockTime();
        var hour, min;

        hour = clockTime.hour;
        min = clockTime.min;

        // You so money and you don't even know it
        return Lang.format("$1$:$2$",[hour, min.format("%02d")]);
        //return[hour,min];
    }
    
    
    function getStats()
    {
        var stats = new[7];
        var statsy = Sys.getSystemStats();
		stats[0] = statsy.battery.toNumber();
		
		var actvinfo = ActvMon.getInfo();
    	stats[1] = actvinfo.calories;
    	stats[2] = actvinfo.steps;
    	
    	var date = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);

    	
    	stats[3] = date.day_of_week;
    	stats[4] = date.day;
    	stats[5] = date.day;
    	stats[6] = date.year;
    	
    return stats;
    }

}
