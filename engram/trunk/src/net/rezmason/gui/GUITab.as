﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.events.Event;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;		public class GUITab extends GUIOption {				// CLASS PROPERTIES		private static const CHANGE_EVENT:GUIEvent = new GUIEvent(Event.CHANGE);				// INSTANCE PROPERTIES		private var _chosen:Boolean = false;		protected var _format:TextFormat;						public function GUITab():void {			evolved = true;						expectedChildren = {};			expectedChildren["txtLabel"] = TextField;			expectedChildren["tabUpState"] = DisplayObject;			expectedChildren["tabDownState"] = DisplayObject;						super();						addColorChild(tabDownState);			addColorChild(tabUpState, 1);						_downState = tabDownState;			_upState = tabUpState;			_downState.visible = _chosen;			_upState.visible = !_chosen;		}				// GETTERS & SETTERS				public function get text():String {			return txtLabel.text;		}				public function set text(value:String):void {			txtLabel.text = value;		}				public function set textAlign(str:String):void {			_format.align = str;			txtLabel.defaultTextFormat = _format;			txtLabel.text = txtLabel.text;		}	}}