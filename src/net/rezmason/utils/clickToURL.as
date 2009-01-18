package net.rezmason.utils {
	
	// IMPORT STATEMENTS
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	* Coverts an interactive object to a web link.
	*	
	*	@param	target	The display object that, when clicked, should activate the link.
	*	@param	request	A <code>URLRequest</code> representing the web location to navigate to.
	*	@see	flash.net.URLRequest
	*/
	public function clickToURL(target:InteractiveObject, request:URLRequest):void {
		target.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
			navigateToURL(request, "_blank");
		});
	}
}