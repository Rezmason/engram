package net.rezmason.engram.modules {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	
	public class GameModule extends Module {
		
		// INSTANCE PROPERTIES
		protected static const GAME_OVER_EVENT:ModuleEvent = new ModuleEvent(ModuleEvent.PLAYER_FAIL);
		protected static const SUCCEED_EVENT:ModuleEvent = new ModuleEvent(ModuleEvent.PLAYER_SUCCEED);
		protected var _game:Game;
		protected var keys:Object = {}
		private var keyHandlers:Object;

		
		public function GameModule():void {
			super();
			keyHandlers = {
				(ModuleKeyRoles.AKEY as String):handleKeyA,
				(ModuleKeyRoles.BKEY as String):handleKeyB,
				(ModuleKeyRoles.XKEY as String):handleKeyX,
				(ModuleKeyRoles.YKEY as String):handleKeyY,
				(ModuleKeyRoles.UKEY as String):handleKeyU,
				(ModuleKeyRoles.DKEY as String):handleKeyD,
				(ModuleKeyRoles.LKEY as String):handleKeyL,
				(ModuleKeyRoles.RKEY as String):handleKeyR
			};
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
			keys = {};
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
		
		override final public function handleInput(inputType:String, keyDown:Boolean = true):void {
			keys[inputType] = keyDown;
			if (isPlaying && !isPaused) {
				keyHandlers[inputType](keyDown);
				if (keyDown) {
					handleKeyDown(inputType);
				} else {
					handleKeyUp(inputType);
				}
			}
			super.handleInput(inputType, keyDown);
		}
		
		public function handleKeyA(keyDown:Boolean):void {
			
		}
		
		public function handleKeyB(keyDown:Boolean):void {
			
		}
		
		public function handleKeyX(keyDown:Boolean):void {
			
		}
		
		public function handleKeyY(keyDown:Boolean):void {
			
		}
		
		public function handleKeyU(keyDown:Boolean):void {
			
		}
		
		public function handleKeyD(keyDown:Boolean):void {
			
		}
		
		public function handleKeyL(keyDown:Boolean):void {
			
		}
		
		public function handleKeyR(keyDown:Boolean):void {
			
		}
		
		public function handleKeyDown(inputType:String):void {
			
		}
		
		public function handleKeyUp(inputType:String):void {

		}
	}
}
