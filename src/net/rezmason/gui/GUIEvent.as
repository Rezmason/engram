package net.rezmason.gui {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	
	public class GUIEvent extends Event {
		
		// CLASS PROPERTIES & CONSTANTS
		public static const    CLOSE_WINDOW:String = "closeWindow";
		public static const MINIMIZE_WINDOW:String = "minimizeWindow";
		public static const MAXIMIZE_WINDOW:String = "maximizeWindow";
		public static const     	SUSPEND:String = "suspend";
		public static const           READY:String = "uiReady";
		public static const           REREZ:String = "rerez";
		
		private var _suspendImmediately:Boolean;
		
		// CONSTRUCTOR
		public function GUIEvent(t:String, b:Boolean = true, c:Boolean = false, susp:Boolean = false):void {
			super(t, b, c);
			_suspendImmediately = susp;
		}
		
		// GETTERS & SETTERS
		
		public function get suspendImmediately():Boolean {
			return _suspendImmediately;
		}
		
		public function set suspendImmediately(b:Boolean):void {
			_suspendImmediately = b;
		}
		
		// PUBLIC METHODS
		
		override public function clone() : Event {
			return new GUIEvent(type, bubbles, cancelable, _suspendImmediately);
		}
		
	}
}
