using Toybox.Application;
using Toybox.WatchUi;

class PureElegantApp extends Application.AppBase {
var wfInstance;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    
        wfInstance = new PureElegantView();
        if( Toybox.WatchUi has :WatchFaceDelegate ) {
            return [wfInstance, new ElegantViewDelegate()];
        } else {
            return [wfInstance];
        }
        
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	wfInstance.onSettingsChanged(wfInstance);
        WatchUi.requestUpdate();
    }
    function getSettingsView() {
        return [new PureSettingsView(), new PureSettingsDelegate()];
    }      

}