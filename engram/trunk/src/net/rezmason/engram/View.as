package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.display.Sprite;

	public class View extends Sprite {
		
		// INSTANCE PROPERTIES
		private var _controller:Controller;
		
		public function View():void {
			super();
		}
		
		// GETTERS & SETTERS
		
		internal function get controller():Controller {
			return _controller;
		}
		
		internal function set controller(value:Controller):void {
			_controller = value;
		}
	}
}

