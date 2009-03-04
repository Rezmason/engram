package net.rezmason.display {
	
	// IMPORT STATEMENTS
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	*	A self-handling movie clip that automatically hides itself when complete.
	*	<p>Intended for use with animated game elements.</p>
	*	
	*	@author Jeremy Sachs
	*	@langversion	ActionScript 3.0
	*	@playerversion	Flash 9
	*	@tiptext
	*/
	public class Moment extends MovieClip {
		
		// CLASS PROPERTIES
		private static const COMPLETE_EVENT:Event = new Event(Event.COMPLETE);
		
		// INSTANCE PROPERTIES
		private var _isPlaying:Boolean = false;

		/**
		*	Creates a Moment instance.
		*	
		*/
		public function Moment():void {
			super();
			super.stop();
			visible = false;
		}
		
		// GETTERS & SETTERS
		
		/**
		*	Determines whether the Moment is currently playing.
		*
		*/
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**
		*	@private
		*
		*/
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
		
		/**
		*	Rewinds and begins the timeline of the movie clip.
		*
		*/
		override public function play():void {
			visible = true;
			super.gotoAndPlay(1);
			_isPlaying = true;
		}
		
		/**
		*	Begins the timeline of the movie clip at the specified frame.
		*	
		*/
		override public function gotoAndPlay(frame:Object, scene:String = null):void {
			visible = true;
			super.gotoAndPlay(frame);
		}
		
		/**
		*	Plays the movie clip from a random point in its timeline.
		*
		*/
		public function playRandom():void {
			gotoAndPlay(int(Math.random() * (totalFrames - 1) + 1));
		}
		
		/**
		*	Stops the playhead in the movie clip and hides the Moment.
		*
		*/
		override public function stop():void {
			super.stop();
			visible = false;
			dispatchEvent(COMPLETE_EVENT);
			_isPlaying = false;
		}	
	}
}
