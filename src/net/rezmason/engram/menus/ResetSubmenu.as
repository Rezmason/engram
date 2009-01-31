package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	import flash.events.Event;

	public final class ResetSubmenu extends Submenu {
		
		// CLASS PROPERTIES
		
		
		// INSTANCE PROPERTIES
		
		
		
		public function ResetSubmenu(__settingsMenu:SettingsMenu):void {
			super(__settingsMenu);
			resetCase.addEventListener("crashDump", ditto);
			resetCase.addEventListener("reset", ditto);
			addColorChild(resetCase.openCase.getChildAt(1));
			addColorChild(resetCase.openCase.getChildAt(2), 1);
			addColorChild(resetCase.closedCase.getChildAt(1));
		}
		
		// GETTERS & SETTERS
		
		override internal function get description():String {
			return " ";
		}
		
		// PUBLIC METHODS
		
		override internal function trigger(event:Event = null):void {
			resetCase.switchOn();
		}
		
		// PRIVATE & PROTECTED METHODS
		
		override protected function prepare(event:Event = null):void {
			resetCase.switchOff();
		}
		
		override protected function reset(event:Event = null):void {
			resetCase.switchOff();
		}
		
		private function ditto(event:Event):void {
			dispatchEvent(event);
		}
	}
}
