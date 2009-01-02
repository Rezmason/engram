package net.rezmason.display {
	
	// IMPORT STATEMENTS
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Moment extends MovieClip {
		
		// INSTANCE PROPERTIES
		private const COMPLETE_EVENT:Event = new Event(Event.COMPLETE);

		// CONSTRUCTOR
		public function Moment():void {
			super();
			super.stop();
			visible = false;
		}
		
		// PUBLIC METHODS
		
		override public function play():void {
			visible = true;
			super.gotoAndPlay(1);
		}
		
		public function playRandom():void {
			visible = true;
			super.gotoAndPlay(int(Math.random() * (totalFrames - 1) + 1));
		}
		
		override public function stop():void {
			super.stop();
			visible = false;
			dispatchEvent(COMPLETE_EVENT);
		}	
	}
}
