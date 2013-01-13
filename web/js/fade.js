$(function() {
	function runEffect() {
	    var selectedEffect = "Blind"
	    var options = {};
	    if ( selectedEffect === "scale" ) {
	        options = { percent: 100 };
	    } else if ( selectedEffect === "size" ) {
	        options = { to: { width: 280, height: 185 } };
	    }
	     
	    $("#effect").show( selectedEffect, options, 500, callback );
	};
    
    function callback() {
        setTimeout(function() {
            $( "#effect:visible" ).removeAttr( "style" ).fadeOut();
        }, 1000 );
    };
    
	$(document).ready(function() {
		runEffect();
	});
	
});