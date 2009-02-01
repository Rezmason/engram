package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	import flash.events.Event;

	public final class ModuleSubmenu extends Submenu {
		
		// CLASS PROPERTIES
		
		
		// INSTANCE PROPERTIES
		
		
		
		public function ModuleSubmenu(__settingsMenu:SettingsMenu):void {
			super(__settingsMenu);
			
			addColorChild(window);
			addColorChild(background, 1);
			addColorChild(toolbar, 1);
			addColorChild(btnDelete, 1);
			addColorChild(btnUpdate, 1);
			addColorChild(btnUpdate, 1);
			addColorChild(slider);
			addColorChild(disabledSlider, 1);
			
			btnUpdate.visible = false;
			
			disabledSlider.visible = false;
			
			slider.scrollToMouse = true;
			slider.encloseThumb = true;
		}
		
		// GETTERS & SETTERS
		
		override internal function get description():String {
			return "Sometimes a module will have its own settings. You can access those here.";
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
