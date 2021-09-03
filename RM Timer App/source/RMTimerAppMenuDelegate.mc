using Toybox.WatchUi;
using Toybox.System;

class RMTimerAppMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            System.println("Save");
            Application.getApp().fitSave();
        } else if (item == :item_2) {
            System.println("Discard");
        }
    }

}