package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	import flash.events.Event;

	public final class ImageSubmenu extends Submenu {
		
		// CLASS PROPERTIES
		
		
		// INSTANCE PROPERTIES
		
		
		
		public function ImageSubmenu(__settingsMenu:SettingsMenu):void {
			super(__settingsMenu);
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
