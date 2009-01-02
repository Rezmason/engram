package net.rezmason.utils {
	
	// IMPORT STATEMENTS
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public function clickToURL(target:InteractiveObject, request:URLRequest):void {
		target.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
			navigateToURL(request, "_blank");
		});
	}
}