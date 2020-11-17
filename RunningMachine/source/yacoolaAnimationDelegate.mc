  
using Toybox.WatchUi;

// This class bridges communication between the app and the animation
// playback
class yacoolaAnimationDelegate extends WatchUi.AnimationDelegate {
    var _controller;

	// Constructor
    function initialize(controller) {
        AnimationDelegate.initialize();
        _controller = controller;
    }

	// Animation event handler
    function onAnimationEvent(event, options) {
        switch(event) {
            case WatchUi.ANIMATION_EVENT_COMPLETE:
            _controller.play();
            break;
            case WatchUi.ANIMATION_EVENT_CANCELED:
                _controller.stop();
                break;
        }
    }
}