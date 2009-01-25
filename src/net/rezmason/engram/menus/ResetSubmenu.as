package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	import flash.events.Event;

	public final class ResetSubmenu extends Submenu {
		
		// CLASS PROPERTIES
		
		
		// INSTANCE PROPERTIES
		
		
		
		public function ResetSubmenu():void {
			resetCase.addEventListener("crashDump", ditto);
			resetCase.addEventListener("reset", ditto);
			addColorChild(resetCase.openCase.getChildAt(1));
			addColorChild(resetCase.openCase.getChildAt(2), 1);
			addColorChild(resetCase.closedCase.getChildAt(1));
		}
		
		// PUBLIC METHODS
		
		override public function trigger(event:Event = null):void {
			resetCase.switchOn();
		}
		
		// PRIVATE & PROTECTED METHODS
		
		override protected function prepare(event:Event = null):void {
			trace("prepare:", event);
			resetCase.switchOff();
		}
		
		override protected function reset(event:Event = null):void {
			trace("reset:", event);
			resetCase.switchOff();
		}
		
		private function ditto(event:Event):void {
			dispatchEvent(event);
		}
	}
}
