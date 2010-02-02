﻿package net.rezmason.events {	import flash.events.Event;		/**	*	Email wouldn't be very useful without the feature	*	of attachments. Similarly, Event objects ought to	*	be capable of carrying references to related	*	objects. HeavyEvents let an untyped reference 	*	ride through the event system, so that the 	*	event's listeners do not need to jump through 	*	hoops to determine how to respond.	*		*	@author Jeremy Sachs	*	@langversion	ActionScript 3.0	*	@playerversion	Flash 9	*	@tiptext	*/	public class HeavyEvent extends Event {				public static const HEAVY:String = "heavyEvent";				public var flavor:String = "unspecified";		public var freight:*;		public function HeavyEvent(flav:String, frgt:* = null, cancelable:Boolean = false):void {			super(HEAVY, true, cancelable);			flavor = flav;			freight = frgt;		}		override public function clone():Event {			return new HeavyEvent(flavor, freight, cancelable);		}				override public function toString():String {			var superstring:String = super.toString();			superstring = superstring.substr(0, superstring.indexOf("]"));			return superstring + " flavor=\"" + flavor + "\" freight=" + freight.toString() + "]";		}	}}