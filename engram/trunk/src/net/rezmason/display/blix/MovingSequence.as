/**
 * blix Library 1.0: bitmap augmentation
 * by Jeremy Sachs 9/30/2007
 *
 * I have no blog, yet. When I have one, visit it. 
 * Maybe by then I'll have a new blix library.
 *
 * You may distribute this class freely, provided it is not modified in any way (including
 * removing this header or changing the package path).
 *
 * jeremysachs@rezmason.net
 */

package net.rezmason.display.blix {
	
	// IMPORT STATEMENTS
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	* 	Sequence that blits over time, and uses the conventional timeline paradigm.
	* 
	*	@author Jeremy Sachs
	*	@langversion	ActionScript 3.0
	*	@playerversion	Flash 9
	*	@tiptext
	*/
	public class MovingSequence extends Sequence {
		
		// INSTANCE PROPERTIES
		private var stoppedEvent:BlixEvent = new BlixEvent(BlixEvent.STOPPED);
		private var enterFrameEvent:BlixEvent = new BlixEvent(BlixEvent.ENTER_FRAME);
		private var _loop:Boolean;
		private var backwards:Boolean;
		private var _currentFrame:int=0;
		private var _dispatch:Boolean = false;
		private var _timer:Timer;
		private var _playing:Boolean = false;
		
		/**
		* Constructor for MovingSequence class.
		*
		*	@param	source	 The source sequence sheet.
		*	@param	rect	 The dimensions of a frame in the sequence sheet.
		*	@param	registrationPoint	 The center of the object relative to the sequence frame.
		*	@param	timer	 Timer object that "drives" the animation. When set to null, the MovingSequence will use an internal timer.
		*	@param	looping	 Determines whether the animation will repeat after it finishes.
		*	@param	dispatch	 Determines whether to dispatch events when the animation updates and stops.
		*	@param	reusable	 I honestly can't remember what this is for.
		*/
		public function MovingSequence(source:BitmapData, rect:Rectangle, registrationPoint:Point = null, timer:Timer = null, 
		 looping:Boolean = false, dispatch:Boolean = false, reusable:Boolean = true):void {
			super(Sequence.KEY, source, rect, registrationPoint, reusable);
			// _timer setup
			if (!timer) {
				_timer = new Timer(1);
				trace("Warning: You're creating a MovingSequence without specifying a Timer. A new Timer will be generated, which may impact your program's performance.");
			} else {
				_timer = timer;
			}
			_loop = looping;
			_dispatch = dispatch;
			if (reusable) {
				addEventListener(BlixEvent.CALIBRATED, safety);
			}
			_timer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
		}
		
		// GETTERS & SETTERS
		
		/**
		* Whether the animation is set to loop.
		*
		*/
		public function get loop():Boolean {
			return _loop;
		}
		
		public function set loop(value:Boolean):void {
			_loop = value;
		}
		
		/**
		* Whether the animation is currently playing.
		*
		*/
		public function get playing():Boolean {
			return _playing;
		}
		
		public function get currentFrame():int {
			return _currentFrame + 1;
		}
		
		/**
		* The Timer object that is "driving" the animation.
		*
		*/
		public function get timer():Timer {
			return _timer;
		}
		
		public function set timer(value:Timer):void {
			if (_playing) {
				_timer.removeEventListener(TimerEvent.TIMER, update);
				value.addEventListener(TimerEvent.TIMER, update);
			}
			_timer = value;
		}
		
		// PUBLIC METHODS
		
		/**
		* Plays the animation, starting at the current frame.
		*
		*/
		public function play():void {
			backwards = false;
			if (!_playing) {
				_timer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
				_playing = true;
			}
		}
		
		/**
		* Plays the animation backwards, starting at the current frame.
		*
		*/
		public function yalp():void {
			backwards = true;
			if (!_playing) {
				_timer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
				_playing = true;
			}
		}
		
		/**
		* Pauses the animation at the current frame.
		*
		*/
		public function stop():void {	
			if (_playing) {
				_timer.removeEventListener(TimerEvent.TIMER, update);
				if (_dispatch) {
					stoppedEvent.setFrame(_currentFrame+1);
					dispatchEvent(stoppedEvent);
				}
				_playing = false;
			}
		}
		
		/**
		* Plays the animation, starting at the specified frame.
		*
		*	@param	offset	 The frame to begin the animation.
		*/
		public function gotoAndPlay(offset:int):void {
			offset = (offset-1) % maxFrames;
			_currentFrame = offset;
			drawFrame(_currentFrame);
			play();
		}
		
		/**
		* Stops the animation at the specified frame.
		*
		*	@param	offset	 The frame to stop the animation.
		*/
		public function gotoAndStop(offset:int):void {
			offset = (offset-1) % maxFrames;
			_currentFrame = offset;
			drawFrame(_currentFrame);
			stop();
		}
		
		/**
		* Plays the animation backwards, starting at the specified frame.
		*
		*	@param	offset	 The frame to begin the animation.
		*/
		public function gotoAndYalp(offset:int):void {
			offset = (offset-1) % maxFrames;
			_currentFrame = offset;
			drawFrame(_currentFrame);
			yalp();
		}
		
		/**
		* Steps the animation forward one frame.
		*
		*/
		public function nextFrame():void {
			if (_currentFrame < maxFrames || _loop) {
				_currentFrame = (_currentFrame + 1) % maxFrames;
				drawFrame(_currentFrame);
			}
		}
		
		/**
		* Steps the animation backward one frame.
		*
		*/
		public function prevFrame():void {
			if (_currentFrame > 0 || _loop) {
				_currentFrame = (maxFrames + _currentFrame - 1) % maxFrames;
				drawFrame(_currentFrame);
			}
		}
		
		/**
		* Creates a new MovingSequence object with identical values.
		*
		*	@return		A new MovingSequence object that is identical to the original.
		*/
		public function clone():MovingSequence {
			var returnVal:MovingSequence = new MovingSequence(_source,_rect,_registration,_timer,_loop);
			if (_playing) {
				if (backwards) {
					returnVal.gotoAndYalp(_currentFrame + 1);
				} else {
					returnVal.gotoAndPlay(_currentFrame + 1);
				}
			}
			returnVal.rotation = rotation;
			returnVal.scaleX = scaleX, returnVal.scaleY = scaleY;
			return returnVal;
		}
		
		// PRIVATE METHODS
		
		private function safety(event:BlixEvent):void {
			_currentFrame = 0;
			update();
		}
		
		private function update(te:TimerEvent=null):void {
			//*
			if (backwards) {
				// step back
				if (_currentFrame - 1 > 0 || _loop) {
					_currentFrame = (maxFrames + _currentFrame - 1) % maxFrames;
				} else {					
					_currentFrame = 0;
					_timer.removeEventListener(TimerEvent.TIMER, update);
					if (_dispatch) {
						stoppedEvent.setFrame(_currentFrame+1);
						dispatchEvent(stoppedEvent);
					}
				}
			} else {
				// step forward
				if (_currentFrame + 1 < maxFrames || _loop) {
					_currentFrame = (_currentFrame + 1) % maxFrames;
				} else {
					_currentFrame = 0;
					_timer.removeEventListener(TimerEvent.TIMER, update);
					if (_dispatch) {
						stoppedEvent.setFrame(_currentFrame+1);
						dispatchEvent(stoppedEvent);
					}
				}
			}
			drawFrame(_currentFrame);
			if (_dispatch) {
				enterFrameEvent.setFrame(_currentFrame+1);
				dispatchEvent(enterFrameEvent);
			}
			//te.updateAfterEvent();
			/**/
		}
	}
}