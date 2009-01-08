package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	
	public class GameModule extends Module {
		
		// INSTANCE PROPERTIES
		protected static const GAME_OVER_EVENT:ModuleEvent = new ModuleEvent(ModuleEvent.PLAYER_FAIL);
		protected static const SUCCEED_EVENT:ModuleEvent = new ModuleEvent(ModuleEvent.PLAYER_SUCCEED);
		protected var _game:Game;

		// CONSTRUCTOR
		public function GameModule():void {
			super();
		}
		
		// GETTERS & SETTERS
		
		public function get score():int {
			return 0;
		}
		
		// PUBLIC METHODS
		
		override public function reset(event:Event = null):void {
			if (_game) {
				_game.reset();
			}
			super.reset();
		}
		
		public function gameOver(event:Event = null):void {
			dispatchEvent(GAME_OVER_EVENT);
			if (relay) {
				relay.dispatchEvent(GAME_OVER_EVENT);
			}
		}
		
		public function succeed(event:Event = null):void {
			dispatchEvent(SUCCEED_EVENT);
			if (relay) {
				relay.dispatchEvent(SUCCEED_EVENT);
			}
		}
	}
}
