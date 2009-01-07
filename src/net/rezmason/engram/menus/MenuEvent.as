package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	
	internal class MenuEvent extends Event {
		
		// CLASS PROPERTIES
		internal static const LAST_MENU:String = "lastMenu";
		internal static const DEBUG_MENU:String = "debugMenu";
		internal static const GAME_MENU:String = "gameMenu";
		internal static const GRID_MENU:String = "gridMenu";
		internal static const MAIN_MENU:String = "mainMenu";
		internal static const PAUSED_MENU:String = "pausedMenu";
		internal static const SETTINGS_MENU:String = "settingsMenu";
		
		// CONSTRUCTOR
		public function MenuEvent( type:String, bubbles:Boolean = true, cancelable:Boolean = false ):void {
			super(type, bubbles, cancelable);
		}
		
		// PUBLIC METHODS
		
		override public function clone() : Event {
			return new MenuEvent(type, bubbles, cancelable);
		}
	}
	
}
