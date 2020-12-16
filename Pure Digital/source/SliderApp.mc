using Toybox.Application;
using Toybox.WatchUi;

class SliderApp extends Application.AppBase {
var wfInstance;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }
    // This method runs each time the main application starts.
    function getInitialView() {
    wfInstance = new SliderView();
        if( Toybox.WatchUi has :WatchFaceDelegate ) {
            return [wfInstance, new SliderViewDelegate()];
        } else {
            return [wfInstance];
        }
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {

    	SliderView.onSettingsChanged(wfInstance);
        WatchUi.requestUpdate();
    }
    function getSettingsView() {
        return [new PureSettingsView(), new PureSettingsDelegate()];
    }    

}