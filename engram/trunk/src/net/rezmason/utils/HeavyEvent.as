﻿package net.rezmason.utils {	import flash.events.Event;		/**	*	Email wouldn't be very useful without the feature	*	of attachments. Similarly, Event objects ought to	*	be capable of containing references to related	*	objects. HeavyEvents let an untyped reference 	*	come along for the ride through the event system,	*	so that the event's listeners do not need to 	*	discern its source to determine how to respond.	*		*	@author Jeremy Sachs	*	@langversion	ActionScript 3.0	*	@playerversion	Flash 9	*	@tiptext	*/	public class HeavyEvent extends Event {				public static const HEAVY:String = "heavyEvent";				public var flavor:String = "vanilla";		public var param:*;		public function HeavyEvent(flav:String, parameter:* = null, cancelable:Boolean = false):void {			super(HEAVY, true, cancelable);			flavor = flav;			param = parameter;		}		override public function clone():Event {			return new HeavyEvent(flavor, param, cancelable);		}	}}