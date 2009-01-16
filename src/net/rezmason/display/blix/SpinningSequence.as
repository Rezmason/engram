/*
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
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//import fl.motion.MatrixTransformer;
	
	/**
	* 	Sequence that blits based on angle, and overloads the conventional rotation property.
	*	
	*	<p>The frame rectangle you pass to a SpinningSequence will always be made into a square.</p>
	* 
	*	@author Jeremy Sachs
	*	@langversion	ActionScript 3.0
	*	@playerversion	Flash 9
	*	@tiptext
	*/
	public class SpinningSequence extends Sequence {
		
		// CLASS PROPERTIES
		// Who likes matrices? Whoo hoo! Hee! Hum. hurr.
		private static  const MATRICES:Array = [
		 new Matrix( 1,  0,  0,  1, 0, 0),
		 new Matrix( 0,  1,  1,  0, 0, 0),
		 new Matrix( 0,  1, -1,  0, 2, 0),
		 new Matrix(-1,  0,  0,  1, 2, 0),
		 new Matrix(-1,  0,  0, -1, 2, 3),
		 new Matrix( 0, -1, -1,  0, 2, 3),
		 new Matrix( 0, -1,  1,  0, 0, 3),
		 new Matrix( 1,  0,  0, -1, 0, 3),
		 ];

		// INSTANCE PROPERTIES
		private var spinner:Matrix = new Matrix();
		private var offset:Point = new Point();
		private var _rotation:Number = 0, angle:Number = 0;
		private var _reflect45:Boolean = false;

		/**
		* Constructor for MovingSequence class.
		*
		*	@param	source	 The source sequence sheet.
		*	@param	rect	 The dimensions of a frame in the sequence sheet.
		*	@param	registrationPoint	 The center of the object relative to the sequence frame.
		*	@param	reflect45	 Determines whether to interpret the sequence as only an eighth turn.
		*	@param	dispatch	 Determines whether to dispatch events when the animation updates and stops.
		*	@param	reusable	 I honestly can't remember what this is for.
		*/
		public function SpinningSequence(source:BitmapData, rect:Rectangle, registrationPoint:Point = null, 
		reflect45:Boolean = false, dispatch:Boolean = false, reusable:Boolean = true):void {
			super(Sequence.KEY, source, rect, registrationPoint, reusable);
			// make sure _rect is a square
			_rect.width = _rect.height = (_rect.width > _rect.height) ? _rect.width : _rect.height;
			_reflect45 = reflect45;
			if (reusable) {
				addEventListener(BlixEvent.CALIBRATED, safety);
			}
		}
		
		// GETTERS & SETTERS
		
		override public function get rotation():Number {
			return _rotation;
		}
		
		override public function set rotation(n:Number):void {
			if (!isNaN(n)) {
				_rotation = n;
				// angle is _rotation mod 360.
				angle = _rotation;
				while (angle < 0) {
					angle += 360;
				}
				angle %= 360;
				if (_reflect45) {
					// matrix stuff- rotation and reflection
					spinner = MATRICES[int(angle / 45)];
					if (spinner.tx == 2) {
						spinner.tx = _rect.width;
					}
					if (spinner.ty == 3) {
						spinner.ty = _rect.height;
					}
					// angle adjustment
					angle %= 90;
					if (angle > 45) {
						angle = 90 - angle;
					}
					// draw the frame "closest" to the angle
					drawFrame( int(angle / 45 * maxFrames), spinner);
				} else {
					// draw the frame "closest" to the angle
					drawFrame( int(angle / 360 * maxFrames) );
				}
				// This function was such a b%$@# to figure out. Such a b%$@#.
			}
		}
		
		// PUBLIC METHODS
		
		/**
		* Creates a new SpinningSequence object with identical values.
		*
		*	@return		A new SpinningSequence object that is identical to the original.
		*/
		public function clone():SpinningSequence {
			var returnVal:SpinningSequence = new SpinningSequence(_source, _rect, _registration, _reflect45);
			returnVal.rotation = _rotation;
			returnVal.scaleX = scaleX, returnVal.scaleY = scaleY;
			return returnVal;
		}
		
		// PRIVATE METHODS
		
		private function safety(event:BlixEvent):void {
			rotation = _rotation;
		}
	}
}