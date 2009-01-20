package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.display.Sprite;
	
	[SWF(width='800', height='600', backgroundColor='#000000', frameRate='30')]
	public final class Main extends Sprite {
		
		public function Main():void {
			while (numChildren) {
				stage.addChild(getChildAt(0));
			}
			
			var view:View = new View();
			stage.addChild(new Guard(view));
			new Controller(view);
		}
	}
}