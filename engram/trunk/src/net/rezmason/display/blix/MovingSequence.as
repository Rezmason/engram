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


/* NAME: MovingSequence   PURPOSE: gives the blitting a timeline paradigm
 * unique parameters of MovingSequence:
 * timer- Timer object that "drives" animation (creates a new Timer by default)
 * looping- determines whether or not animation will repeat when it hits the end
 * dispatch- determines whether or not MovingSequence will dispatch events (true by default)
 * 
 * unique properties of MovingSequence:
 * loop- see above
 * timer- see above
 * isPlaying- self explanatory
 *
 * unique functions of MovingSequence:
 * standard timeline functions: play, stop, gotoAndPlay, gotoAndStop, prevFrame, nextFrame
 * yalp and gotoAndYalp- play backwards
 * clone- returns an exact copy of this MovingSequence
 * 
 * (NOTE: MovingSequence disptaches BlixEvents when it updates and stops.)
 * 
 */

package net.rezmason.display.blix
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class MovingSequence extends Sequence
	{
		private var stoppedEvent:BlixEvent = new BlixEvent(BlixEvent.STOPPED);
		private var enterFrameEvent:BlixEvent = new BlixEvent(BlixEvent.ENTER_FRAME);
		private var _loop:Boolean;
		private var backwards:Boolean;
		private var _currentFrame:int=0;
		private var mb:MovingSequence;
		private var _dispatch:Boolean = false;
		private var _timer:Timer;
		private var _playing:Boolean = false;

		public function MovingSequence(source:BitmapData, rect:Rectangle, reg:Point = null, tmr:Timer = null, 
		 looping:Boolean=false, dispatch:Boolean = false, reusable:Boolean = true):void
		{
			super(Sequence.KEY, source, rect, reg, reusable);
			// _timer setup
			if (!tmr) {
				_timer = new Timer(1);
				trace("Warning: You're creating a MovingSequence without specifying a Timer. A new Timer will be generated, which may impact your program's performance.");
			} else {
				_timer = tmr;
			}
			_loop = looping;
			_dispatch = dispatch;
			if (reusable){
				addEventListener(BlixEvent.CALIBRATED, safety);
			}
			_timer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
		}
		private function update(te:TimerEvent=null):void
		{
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
		private function safety(be:BlixEvent) : void {
			_currentFrame = 0;
			update();
		}
		public function play():void
		{
			backwards = false;
			if (!_playing) {
				_timer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
				_playing = true;
			}
		}
		public function yalp():void
		{
			backwards = true;
			if (!_playing) {
				_timer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
				_playing = true;
			}
		}
		public function stop():void
		{	
			if (_playing) {
				_timer.removeEventListener(TimerEvent.TIMER, update);
				if (_dispatch) {
					stoppedEvent.setFrame(_currentFrame+1);
					dispatchEvent(stoppedEvent);
				}
				_playing = false;
			}
		}
		public function gotoAndPlay(offset:int):void
		{
			offset = (offset-1) % maxFrames;
			_currentFrame = offset;
			drawFrame(_currentFrame);
			play();
		}
		public function gotoAndStop(offset:int):void
		{
			offset = (offset-1) % maxFrames;
			_currentFrame = offset;
			drawFrame(_currentFrame);
			stop();
		}
		public function gotoAndYalp(offset:int):void
		{
			offset = (offset-1) % maxFrames;
			_currentFrame = offset;
			drawFrame(_currentFrame);
			yalp();
		}
		public function nextFrame():void
		{
			if (_currentFrame < maxFrames || _loop) {
				_currentFrame = (_currentFrame + 1) % maxFrames;
				drawFrame(_currentFrame);
			}
		}
		public function prevFrame():void
		{
			if (_currentFrame > 0 || _loop) {
				_currentFrame = (maxFrames + _currentFrame - 1) % maxFrames;
				drawFrame(_currentFrame);
			}
		}
		public function get loop():Boolean
		{
			return _loop;
		}
		public function set loop(b:Boolean):void
		{
			_loop = b;
		}
		public function get playing():Boolean
		{
			return _playing;
		}
		public function get currentFrame():int
		{
			return _currentFrame + 1;
		}
		public function get timer():Timer {
			return _timer;
		}
		public function set timer(tmr:Timer) : void {
			if (_playing) {
				_timer.removeEventListener(TimerEvent.TIMER, update);
				tmr.addEventListener(TimerEvent.TIMER, update);
			}
			_timer = tmr;
		}
		public function clone():MovingSequence
		{
			mb = new MovingSequence(_source,_rect,_registration,_timer,_loop);
			if (_playing) {
				if (backwards) {
					mb.gotoAndYalp(_currentFrame + 1);
				} else {
					mb.gotoAndPlay(_currentFrame + 1);
				}
			}
			mb.rotation = rotation;
			mb.scaleX = scaleX, mb.scaleY = scaleY;
			return mb;
		}
	}
}