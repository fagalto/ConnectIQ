using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class Background extends WatchUi.Drawable {

    hidden var mColor;

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
        mColor = 0xFFFFFF;
    }
    function setColor(color) {
        mColor = color;
    }

    function draw(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, mColor);
        dc.clear();
    }
}
