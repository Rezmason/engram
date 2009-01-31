package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	import flash.events.Event;

	public final class SoundSubmenu extends Submenu {
		
		// CLASS PROPERTIES
		
		
		// INSTANCE PROPERTIES
		
		
		
		public function SoundSubmenu(__settingsMenu:SettingsMenu):void {
			super(__settingsMenu);
		}
		
		// GETTERS & SETTERS
		
		override internal function get description():String {
			return "Crank the overall volume up or down with this knob here.";
		}
		
		// PUBLIC METHODS
		
		override internal function trigger(event:Event = null):void {
			
		}
		
		// PRIVATE & PROTECTED METHODS
		
		override protected function prepare(event:Event = null):void {
			
		}
		
		override protected function reset(event:Event = null):void {
			
		}
		
		private function ditto(event:Event):void {
			dispatchEvent(event);
		}
	}
}
