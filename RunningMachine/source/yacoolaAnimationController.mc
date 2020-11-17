using Toybox.WatchUi;

class yacoolaAnimationController {
    private var _animation;
    private var _playing;
    var delegate;

    function initialize() {
        _playing = false;
    }

    function handleOnShow(view) {
        if( view.getLayers() == null ) {
            // Initialize the Animation
            _animation = new WatchUi.AnimationLayer(
                Rez.Drawables.yacoola,
                {
                    :locX=>-10,
                    :locY=>-10,
                }
                );

            // Build the time overlay
           // _textLayer = buildTextLayer();

            view.addLayer(_animation);
  
        }

    }
    function getAnimLayer() {
        return _animation;
    }    

    function handleOnHide(view) {
        view.clearLayers();
        _animation = null;
 
    }

    // Function to initialize the time layer




    function play() {
    //System.println("imma playin");
        if(!_playing) {
        delegate = new yacoolaAnimationDelegate(self);
            _animation.play({
                :delegate=>delegate
                });
            _playing = true;
        }
        else {
            _animation.play({:delegate=>delegate});
            _playing = true;
        }        
    }

    function stop() {
   // System.println("imma stoppin");
        if(_playing) {
            _animation.stop();
            _playing = false;
        }
    }

}