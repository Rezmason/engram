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


/* NAME: SpinningSequence   PURPOSE: converts an angle to a frame in a rotational sequence
 * unique parameters of SpinningSequence:
 * reflect45- if true, SpinningSequence interprets the source bitmap as angles between 0 and 45
 * 	(rather than those between 0 and 360), and uses matrix transformation to fill in the 
 *	rest of the rotation
 * 
 * unique properties of SpinningSequence:
 * rotation- totally overloaded. Works like standard rotation, just know that it's not.
 *
 * unique functions of SpinningSequence:
 * clone- returns an exact copy of this SpinningSequence
 * 
 * (NOTE: the rectangle you pass to a SpinningSequence will always be made into a square.)
 * 
 */
 
package net.rezmason.display.blix
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//import fl.motion.MatrixTransformer;

	public class SpinningSequence extends Sequence
	{
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


		private var spinner:Matrix = new Matrix();
		private var offset:Point = new Point();
		private var _rotation:Number = 0, angle:Number = 0;
		private var _reflect45:Boolean = false;
		private var sb:SpinningSequence;

		public function SpinningSequence(source:BitmapData, rect:Rectangle, reg:Point = null, 
		reflect45:Boolean = false, dispatch:Boolean = false, reusable:Boolean = true):void
		{
			super(Sequence.KEY, source, rect, reg, reusable);
			// make sure _rect is a square
			_rect.width = _rect.height = (_rect.width > _rect.height) ? _rect.width : _rect.height;
			_reflect45 = reflect45;
			if (reusable){
				addEventListener(BlixEvent.CALIBRATED, safety);
			}
		}
		private function safety(be:BlixEvent) : void {
			rotation = rotation;
		}
		public override function get rotation():Number
		{
			return _rotation;
		}
		public override function set rotation(n:Number):void
		{
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
		public function clone():SpinningSequence {
			sb = new SpinningSequence(_source, _rect, _registration, _reflect45);
			sb.rotation = _rotation;
			sb.scaleX = scaleX, sb.scaleY = scaleY;
			return sb;
		}
	}
}