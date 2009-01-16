package net.rezmason.display {
	
	// IMPORT STATEMENTS
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Moment extends MovieClip {
		
		// CLASS PROPERTIES
		private static const COMPLETE_EVENT:Event = new Event(Event.COMPLETE);
		
		// INSTANCE PROPERTIES
		private var _isPlaying:Boolean = false;

		
		public function Moment():void {
			super();
			super.stop();
			visible = false;
		}
		
		// GETTERS & SETTERS
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void {
			if (_isPlaying != value) {
				if (value) {
					play();
				} else {
					stop();
				}
			}
		}
		
		// PUBLIC METHODS
		
		override public function play():void {
			visible = true;
			super.gotoAndPlay(1);
			_isPlaying = true;
		}
		
		public function playRandom():void {
			visible = true;
			super.gotoAndPlay(int(Math.random() * (totalFrames - 1) + 1));
		}
		
		override public function stop():void {
			super.stop();
			visible = false;
			dispatchEvent(COMPLETE_EVENT);
			_isPlaying = false;
		}	
	}
}
