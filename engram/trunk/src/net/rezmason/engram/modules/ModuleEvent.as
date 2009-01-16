package net.rezmason.engram.modules {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	
	public class ModuleEvent extends Event {
		
		// CLASS PROPERTIES
		public static const PLAYER_FAIL:String = "playerFail", PLAYER_SUCCEED:String = "playerSucceed";
		public static const MODULE_READY:String = "moduleReady";
		
		// INSTANCE PROPERTIES
		private var _worth:int = 0;
		
		
		public function ModuleEvent( type:String, wrth:int = 0, bubbles:Boolean = true, cancelable:Boolean = false ):void {
			super(type, bubbles, cancelable);
			_worth = wrth;
		}
		
		// GETTERS & SETTERS
		
		public function get worth():int {
			return _worth;
		}
		
		public function set worth(i:int):void {
			_worth = i;
		}
		
		// PUBLIC METHODS
		
		override public function clone():Event {
			return new ModuleEvent(type, worth, bubbles, cancelable);
		}
	}
	
}
