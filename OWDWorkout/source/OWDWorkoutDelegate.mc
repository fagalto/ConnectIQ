using Toybox.WatchUi;

class OWDWorkoutDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new OWDWorkoutMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}