package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.System;
	
	import net.rezmason.engram.CommonEvents;
	import net.rezmason.utils.ActiveGraph;
	
	[SWF(width='800', height='600', backgroundColor='#000000', frameRate='60')]
	public final class Main extends Sprite {
		
		// CLASS PROPERTIES
		[Embed(source="../../../../resources/startup.mp3")]
		private static const Bonggg:Class;
		private static const ON:SoundTransform = new SoundTransform();
		
		private static const

			SPLASH:String =
			"\n   ___________     ___________       ___________    _____________       _________      _____  ____    " +
			"\n  /           `   |            `    /           `   |            `     /         `    |     ^^     `  " +
			"\n |  ,-------,__|  |  +-------,  |  |  ,-------,  |  |  +-------,  |   /  /-----`  `   |  +-,  ,--,  | " +
			"\n `  |___          |  |       |  |  |  |       `__/  |  |       |  |  |  |       |  |  |  | `__/  |  | " +
			"\n  >  ___)         |  |       |  |  |  |             |  |       |  |  |  |       |  |  |  |       |  | " +
			"\n /  /             |  |       |  |  |  |    _____    |  |    ___/  /  `  `_______/  /  |  |       |  | " +
			"\n |  |        _    |  |       |  |  |  |   (___  `   |  |   (__  <    /   _______   `  |  |       |  | " +
			"\n |  |       / `   |  |       |  |  |  |       |  |  |  |      `  `   |  |       |  |  |  |       |  | " +
			"\n |  `-------'  |  |  |       |  |  |  `-------'  |  |  |       |  |  |  |       |  |  |  |       |  | " +
			"\n `____________/   |__|       |__|   `___________/   |__|       |__/  |__|       |__|  |__|       |__| " ,

			MESSAGE:String =
			"\n\nHey, friend! This project needs contributors. If you're Flash-savvy, why not shoot me a quick note at" +
			"\n\n	jeremysachs@rezmason.net \n\n and let me know whether you're interested. Enjoy the video games. \n" ,
			
			APP_VERSION:Number = 3.13;
		
		// INSTANCE PROPERTIES
		private var bonggg:Sound;
		
		private var _guard:Guard;
		private var _graph:ActiveGraph;
		private var _view:View, _controller:Controller;
		
		
		public function Main():void {
			bonggg = new Bonggg() as Sound;
			
			while (numChildren) {
				stage.addChild(getChildAt(0));
			}
			
			trace(SPLASH + "v. " + APP_VERSION);
			trace(MESSAGE);
			
			//_graph = new ActiveGraph(0, false, true, 2);
			reset();
		}
		
		private function begin(event:Event = null):void {
			_view = new View();
			stage.addChild(_guard = new Guard(_view));
			_controller = new Controller(_view);
			_controller.addEventListener(CommonEvents.RESET_SYSTEM, reset, false, 0, true);
			System.gc();
			
			if (_graph) {
				stage.addChild(_graph);
			}
			//showRedrawRegions(true, 0xFFFFFF);
		}
		
		private function reset(event:Event = null):void {
			
			if (_guard) {
				stage.removeChild(_guard);
				_guard = null;
			}
			_view = null;
			_controller = null;
			
			if (bonggg) {
				SoundMixer.soundTransform = ON;
				bonggg.play().addEventListener(Event.SOUND_COMPLETE, begin, false, 0, true);
			} else {
				begin();
			}
		}
	}
}