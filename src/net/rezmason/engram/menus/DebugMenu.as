﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.Event;		import net.rezmason.engram.Main;		import com.robertpenner.easing.Quartic;	import gs.TweenLite;		public final class DebugMenu extends MenuBase {				// INSTANCE PROPERTIES		private var _main:Main;		private var _blurb:String = "";				// CONSTRUCTOR		public function DebugMenu(__main:Main):void {						super(true, false);			_main = __main;		}				// GETTERS & SETTERS				public function set blurb(value:String):void {			_blurb = value.toUpperCase();			txtDescription.text = _blurb;		}				// PUBLIC METHODS						// PRIVATE METHODS						private function showDescription(event:Event):void {			txtDescription.text = "boop!";		}				private function hideDescription(event:Event):void {			txtDescription.text = _blurb;		}	}}