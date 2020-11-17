using Toybox.Application;
using Toybox.WatchUi;

class SliderApp extends Application.AppBase {

    var temperature = null;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }
    // This method runs each time the main application starts.
    function getInitialView() {
        if( Toybox.WatchUi has :WatchFaceDelegate ) {
            return [new SliderView(), new SliderViewDelegate()];
        } else {
            return [new SliderView()];
        }
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        WatchUi.requestUpdate();
    }

}