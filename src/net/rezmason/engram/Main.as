package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import net.rezmason.utils.ActiveGraph;
	
	[SWF(width='800', height='600', backgroundColor='#000000', frameRate='30')]
	public final class Main extends Sprite {
		
		// CLASS PROPERTIES
		[Embed(source="startup.mp3")]
		private static const Bonggg:Class;
		private static const ON:SoundTransform = new SoundTransform();
		
		// INSTANCE PROPERTIES
		private var guard:Guard;
		private var bonggg:Sound;
		
		
		public function Main():void {
			
			while (numChildren) {
				stage.addChild(getChildAt(0));
			}
			
			var view:View = new View();
			stage.addChild(guard = new Guard(view));
			new Controller(view);
			//stage.addChild(new ActiveGraph(0, false, true, 2));
			//showRedrawRegions(true, 0xFFFFFF);
			
			bonggg = new Bonggg() as Sound;
			if (bonggg) {
				SoundMixer.soundTransform = ON;
				bonggg.play();
			}
		}
	}
}