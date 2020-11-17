using Toybox.WatchUi;

class animationView extends WatchUi.View {
var  _animationDelegate;


    function initialize() {

 _animationDelegate = new yacoolaAnimationController();
    }

    // Load your resources here
    function onLayout(dc) {




    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
//    _animationDelegate.play();
        _animationDelegate.handleOnShow(self);
        _animationDelegate.play();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
       	// Clear the screen buffer
      // var dca =	_animationDelegate.getAnimLayer().getDc();
   dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
   dc.clear();
     
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
 _animationDelegate.handleOnHide(self);
    }
    


}
