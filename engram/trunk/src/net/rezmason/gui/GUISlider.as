package net.rezmason.gui {
	
	// IMPORT STATEMENTS
	import flash.display.DisplayObject;
	
	public class GUISlider extends GUIAbstract {
		
		// CONSTRUCTOR
		public function GUISlider():void {
			super(GUIAbstractEnforcer.INSTANCE);
			
			expectedChildren["light"] = DisplayObject;
			verifyChildren(this);
			
			light.visible = false;
			addColorChild(light);
		}
		
		// GETTERS & SETTERS
		
		public function get value():Boolean {
			return light.visible;
		}
		
		public function set value(b:Boolean):void {
			light.visible = b;
		}
	}
}