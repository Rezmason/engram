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
	import flash.events.Event;
	
	/**
	* 	Event class that contains frame data from a blix-based animation.
	* 
	*	@author Jeremy Sachs
	*	@langversion	ActionScript 3.0
	*	@playerversion	Flash 9
	*	@tiptext
	*/
	public class BlixEvent extends Event {
		
		// CLASS PROPERTIES
		public static const STOPPED:String = "blixStopped";
		public static const ENTER_FRAME:String = "blixEnterFrame";
		public static const CALIBRATED:String = "blixCalibrated";
		
		// INSTANCE PROPERTIES
		private var _frame:int;
		
		/**
		* Creates a BlixEvent object to pass as a parameter to event listeners.
		*
		* @param	type	 The type of event that the instance represents.
		* @param	frame	 The current frame of the event target.
		*	
		*/
		public function BlixEvent(type:String, frame:int = 1):void {
			super(type);
			_frame = frame;
		}
		
		/**
		* The current frame of the event target.
		*
		*/
		public function get frame():int {
			return _frame;
		}
		
		internal function setFrame(value:int):void {
			_frame = value;
		}
		
		override public function clone():Event {
			return new BlixEvent(type, _frame);
		}
	}
}