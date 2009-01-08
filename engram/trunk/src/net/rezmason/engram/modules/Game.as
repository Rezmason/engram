package net.rezmason.engram.modules {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Game extends EventDispatcher {		
		// INSTANCE PROPERTIES
		protected const GAME_OVER_EVENT:ModuleEvent = new ModuleEvent(ModuleEvent.PLAYER_FAIL);
		protected const SUCCEED_EVENT:ModuleEvent = new ModuleEvent(ModuleEvent.PLAYER_SUCCEED);
		
		// PUBLIC METHODS
		
		public function reset(event:Event = null):void {
			
		}
		
		public function gameOver():void {
			dispatchEvent(GAME_OVER_EVENT);
		}
		
		public function succeed():void {
			dispatchEvent(SUCCEED_EVENT);
		}
	}
}