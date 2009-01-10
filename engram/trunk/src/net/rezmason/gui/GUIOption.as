﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.getQualifiedClassName;		public class GUIOption extends GUIAbstract {				// CLASS PROPERTIES		private static const PUSH_EVENT:GUIEvent = new GUIEvent(GUIEvent.RADIO_PUSH);				// INSTANCE PROPERTIES		private var _chosen:Boolean = false;		protected var _downState:DisplayObject, _upState:DisplayObject;				// CONSTRUCTOR		public function GUIOption():void {			super(GUIAbstractEnforcer.INSTANCE);						var pure:Boolean = getQualifiedClassName(this).indexOf("GUIOption") != -1;						if (pure) {				expectedChildren["downState"] = DisplayObject;				expectedChildren["upState"] = DisplayObject;			}						verifyChildren(this);						if (pure) {				_downState = downState;				_upState = upState;				addColorChild(downState);				addColorChild(upState);				chosen = false;			}						addEventListener(MouseEvent.CLICK, dispatchPush);		}				// GETTERS & SETTERS				public function get chosen():Boolean {			return _chosen;		}				public function set chosen(value:Boolean):void {			if (_chosen != value) {								_chosen = value;								_downState.visible = _chosen;				_upState.visible = !_chosen;				if (_chosen) {					dispatchEvent(PUSH_EVENT);				}			}		}				// PRIVATE METHODS				private function dispatchPush(event:Event):void {			chosen = true;		}	}}