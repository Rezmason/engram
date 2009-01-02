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


/* NAME: BlixEvent   PURPOSE: cooler than plain events, because it's got a frame # in it
 * unique properties of BlixEvent:
 * frame- the current frame of the target blix object
 * 
 */

 package net.rezmason.display.blix
{
	import flash.events.Event;

	public class BlixEvent extends Event
	{
		public static  const STOPPED:String = "blixStopped";
		public static  const ENTER_FRAME:String = "blixEnterFrame";
		public static  const CALIBRATED:String = "blixCalibrated";
		private var _frame:int;

		public function BlixEvent(type:String, f:int=1):void
		{
			super(type);
			_frame = f;
		}
		public function get frame():int
		{
			return _frame;
		}
		
		internal function setFrame(n:int):void {
			_frame = n;
		}
		
		public override function clone() : Event {
			return new BlixEvent(type, _frame);
		}
	}
}