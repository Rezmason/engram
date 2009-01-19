package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.display.Sprite;
	
	public final class Main extends Sprite {
		
		public function Main():void {
			while (numContents) {
				stage.addChild(getChildAt(0));
			}
			stage.addChild(new Guard(new Controller().view));
		}
	}
}