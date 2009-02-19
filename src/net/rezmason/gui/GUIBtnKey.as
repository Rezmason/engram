﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.text.TextField;		import net.rezmason.display.Moment;		public class GUIBtnKey extends GUIAbstract {				// CLASS PROPERTIES		public static const NONE:String = "  ";				// INSTANCE PROPERTIES		public var flag:Moment;		private var _role:String = NONE;		private var _char:String = NONE;		private var _pending:Boolean = false;		protected var _textArea:TextField;		protected var _upState:DisplayObject, _pendingState:DisplayObject;				public function GUIBtnKey():void {						super(GUIAbstractEnforcer.INSTANCE);						TextField;						expectedChildren["upState"] = DisplayObject;			expectedChildren["pendingState"] = DisplayObject;			verifyChildren(this);						buttonMode = true;			useHandCursor = true;			_textArea = getChildByName("textArea") as TextField;			_textArea.mouseEnabled = false;						_upState = getChildByName("upState");			_pendingState = getChildByName("pendingState");			pending = false;			addColorChild(_upState, 1);			addColorChild(_pendingState, 0);		}				// GETTERS & SETTERS				public function get char():String {			return _char;		}				public function set char(value:String):void {			_char ||= "";			_char = value;			pending = false;		}				public function get pending():Boolean {			return _pending;		}		public function set pending(value:Boolean):void {			if (_pending != value) {				_pending = value;			}			_textArea.text = (_pending || !_char) ? "" : _char;			_pendingState.visible = _pending;			_upState.visible = !_pending;		}				public function get role():String {			return _role;		}				public function set role(value:String):void {			_role = value || "";		}	}}