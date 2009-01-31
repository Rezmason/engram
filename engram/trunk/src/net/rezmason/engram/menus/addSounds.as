package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.rezmason.media.SoundManager;
	
	import net.rezmason.gui.GUIBtnKey;
	import net.rezmason.gui.GUIButton;
	import net.rezmason.gui.GUIOption;
	import net.rezmason.gui.GUITab;
	import net.rezmason.gui.GUICheckBox;
	
	public function addSounds(target:DisplayObjectContainer):void {
		var ike:int;
		var child:DisplayObject;
		
		function playButtonSound(event:Event = null):void {
			SoundManager.INSTANCE.play("buttonSound");
		}
		
		function playCheckBoxSound(event:Event = null):void {
			SoundManager.INSTANCE.play("settingSound");
		}
		
		for (ike = 0; ike < target.numChildren; ike += 1) {
			child = target.getChildAt(ike);
			if (child is GUIBtnKey || child is GUIButton || child is GUITab || child.name.indexOf("btn") == 0) {
				child.addEventListener(MouseEvent.MOUSE_DOWN, playButtonSound);
			} else if (child is GUICheckBox) {
				child.addEventListener(MouseEvent.CLICK, playCheckBoxSound);
			} else if (child is GUIOption) {
				child.addEventListener(MouseEvent.MOUSE_DOWN, playButtonSound);
			}
		}
	}
}