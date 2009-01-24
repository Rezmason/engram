package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	
	import net.rezmason.utils.ActiveGraph;
	
	[SWF(width='800', height='600', backgroundColor='#000000', frameRate='30')]
	public final class Main extends Sprite {
		
		// CLASS PROPERTIES
		[Embed(source="startup.mp3")]
		private static const Bonggg:Class;
		
		// INSTANCE PROPERTIES
		private var guard:Guard;
		private var bonggg:Sound;
		private var graph:ActiveGraph = new ActiveGraph(0, true, true, 2);
		
		
		public function Main():void {
			
			while (numChildren) {
				stage.addChild(getChildAt(0));
			}
			
			bonggg = new Bonggg() as Sound;
			
			bootUp();
			
			//showRedrawRegions(true, 0xFFFFFF);
		}
		
		// INTERNAL METHODS
		
		internal function bootUp(event:Event = null):void {
			
			if (guard) {
				stage.removeChild(guard);
				guard.dissolve();
				guard = null;
			}
			
			var view:View = new View();
			stage.addChild(guard = new Guard(view));
			(new Controller(view)).addEventListener("reboot", bootUp, false, 0, true);
			
			if (bonggg) {
				bonggg.play();
			}
			
			stage.addChild(graph);
		}
	}
}