using Toybox.WatchUi;
using Toybox.Sensor;

class OWDWorkoutView extends WatchUi.View {
var accdataa;

    function initialize() {
        View.initialize();
        accdataa  = new accelerationData();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        accdataa.enableAccel();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        var infos = Sensor.Info;
        System.println(infos.accel);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
       dc.drawText(50, 50, Graphics.FONT_SMALL ,accdataa.mSamplesX,Graphics.TEXT_JUSTIFY_RIGHT);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
