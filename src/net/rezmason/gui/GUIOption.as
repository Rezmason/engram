﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.getQualifiedClassName;		public class GUIOption extends GUIAbstract {				// CLASS PROPERTIES		private static const CHANGE_EVENT:GUIEvent = new GUIEvent(Event.CHANGE);				// INSTANCE PROPERTIES		private var _chosen:Boolean = false;		protected var _downState:DisplayObject, _upState:DisplayObject;		protected var evolved:Boolean;				// CONSTRUCTOR		public function GUIOption():void {			super(GUIAbstractEnforcer.INSTANCE);						if (!evolved) {				expectedChildren["downState"] = DisplayObject;				expectedChildren["upState"] = DisplayObject;			}						verifyChildren(this);						if (!evolved) {				_downState = downState;				_upState = upState;				addColorChild(downState);				addColorChild(upState);				_downState.visible = _chosen;				_upState.visible = !_chosen;			}						buttonMode = true;			useHandCursor = true;						addEventListener(MouseEvent.CLICK, dispatchChange);		}				// GETTERS & SETTERS				public function get chosen():Boolean {			return _chosen;		}				public function set chosen(value:Boolean):void {			if (_chosen != value) {								_chosen = value;				_downState.visible = _chosen;				_upState.visible = !_chosen;				if (_chosen) {					dispatchEvent(CHANGE_EVENT);				}			}		}				// PRIVATE METHODS				private function dispatchChange(event:Event):void {			chosen = true;		}	}}