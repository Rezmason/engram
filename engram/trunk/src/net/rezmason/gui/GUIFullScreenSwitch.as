package net.rezmason.gui {
	
	// IMPORT STATEMENTS
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GUIFullScreenSwitch extends GUIAbstract {
		
		// PRIVATE INSTANCE PROPERTIES
		private var uiManager:GUIManager;

		// CONSTRUCTOR
		public function GUIFullScreenSwitch():void {
			super(GUIAbstractEnforcer.INSTANCE);
			
			expectedChildren["txtLabel"] = TextField;
			verifyChildren(this);
			
			buttonMode = true;
			useHandCursor = true;
			txtLabel.mouseEnabled = false;
			
			uiManager = GUIManager.INSTANCE;
			
			addEventListener(MouseEvent.CLICK, toggle);
		}
		
		// PRIVATE METHODS
		
		private function toggle(event:MouseEvent = null):void {
			uiManager.toggleFullScreen();
			txtLabel.text = (uiManager.fullScreenEnabled ? "NORMAL" : "FULLSCREEN");
		}
	}
}