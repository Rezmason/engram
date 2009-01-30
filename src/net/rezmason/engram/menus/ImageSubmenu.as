package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	import net.rezmason.engram.display.GamePalette;
	import net.rezmason.engram.display.WindowSizes;
	import net.rezmason.gui.GUIGroup;
	import net.rezmason.utils.isAIR;

	public final class ImageSubmenu extends Submenu {
		
		// CLASS PROPERTIES
		
		// INSTANCE PROPERTIES
		private var sizeGroup:GUIGroup = new GUIGroup;
		
		
		public function ImageSubmenu(__settingsMenu:SettingsMenu):void {
			super(__settingsMenu);
			
			sizeGroup.addGUIAbstract(radSmall);
			sizeGroup.addGUIAbstract(radMedium);
			sizeGroup.addGUIAbstract(radLarge);
			sizeGroup.addEventListener(Event.CHANGE, changeSize);
			
			addColorChild(blnSmoothing);
			addColorChild(blnBuffer);
			addColorChild(monitor.littleWallpaper, 1);
			addColorChild(monitor.littleScreen);
			addColorChild(radSmall);
			addColorChild(radMedium);
			addColorChild(radLarge);
			if (!isAIR()) {
				sizeGroup.enabled = false;
			}
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
		
		private function changeSize(event:Event):void {
			switch (sizeGroup.chosenOption) {
				case radSmall:
					trace(WindowSizes.SMALL);
				break;
				case radMedium:
					trace(WindowSizes.MEDIUM);
				break;
				case radLarge:
					trace(WindowSizes.LARGE);
				break;
			}
		}
	}
}
