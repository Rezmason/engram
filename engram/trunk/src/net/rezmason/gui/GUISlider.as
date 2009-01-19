﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.Timer;		public class GUISlider extends GUIAbstract {				// CLASS PROPERTIES		private static const HORIZONTAL_AXIS:String = "horizontalAxis", VERTICAL_AXIS:String = "verticalAxis";		private static const CHANGE_EVENT:GUIEvent = new GUIEvent(Event.CHANGE);				// INSTANCE PROPERTIES		protected var _encloseThumb:Boolean;		protected var _scrollToMouse:Boolean;		protected var _scrollingToMouse:Boolean = false;		protected var _draggingThumb:Boolean = false;		protected var _scrollSpeed:Number;		protected var _defaultPosition:Number;		protected var _position:Number;		protected var scrollStep:Number;		protected var _axis:String;		protected var _backArrows:Array, _forthArrows:Array;		protected var grasp:Point = new Point;		protected var _center:Point = new Point;		protected var scrollTimer:Timer = new Timer(10);		protected var _thumb:Sprite, _track:Sprite;		protected var _stage:Stage;						public function GUISlider():void {						super(GUIAbstractEnforcer.INSTANCE);						_axis ||= HORIZONTAL_AXIS;			_backArrows||= [];			_forthArrows ||= [];			_scrollSpeed ||= 5;			_scrollToMouse ||= false;			_defaultPosition ||= 0;			_encloseThumb ||= false;									if (!_thumb) {				expectedChildren["thumb"] = Sprite;			}						if (!_track) {				expectedChildren["track"] = Sprite;			}						verifyChildren(this);						if (!_thumb) {				_thumb = getChildByName("thumb") as Sprite;				addColorChild(_thumb, 1);			}						if (!_track) {				_track = getChildByName("track") as Sprite;				addColorChild(_track);			}						_thumb.buttonMode = true;			_thumb.useHandCursor = true;			centerX = _thumb.x;			centerY = _thumb.y;						var ike:int;			for (ike = 0; ike < numChildren; ike++) {				var child:DisplayObject = getChildAt(ike);				var childName:String = child.name;				if (childName.indexOf("backArrow") != -1) {					_backArrows.push(child);					child.addEventListener(MouseEvent.MOUSE_DOWN, startScroll);					addColorChild(child);				} else if (childName.indexOf("forthArrow") != -1) {					_forthArrows.push(child);					child.addEventListener(MouseEvent.MOUSE_DOWN, startScroll);					addColorChild(child);				}			}						_thumb.addEventListener(MouseEvent.MOUSE_DOWN, grabThumb);			_track.addEventListener(MouseEvent.MOUSE_DOWN, startScroll);						position = defaultPosition;						scrollTimer.addEventListener(TimerEvent.TIMER, updateScroll);						if (stage) {				addStageListeners();			} else {				addEventListener(Event.ADDED_TO_STAGE, addStageListeners);			}		}				// GETTERS & SETTERS				public function get axis():String {			return _axis;		}				public function set axis(value:String):void {			_axis = value || HORIZONTAL_AXIS;		}				public function get scrollSpeed():Number {			return _scrollSpeed;		}				public function set scrollSpeed(value:Number):void {			_scrollSpeed = Math.max(0, value);		}				public function get scrollToMouse():Boolean {			return _scrollToMouse;		}				public function set scrollToMouse(value:Boolean):void {			_scrollToMouse = value;		}				public function get defaultPosition():Number{			return _defaultPosition;		}				public function set defaultPosition(value:Number):void {			_defaultPosition = Math.min(1, Math.max(0, value)) || 0;		}				public function get centerX():Number {			return _center.x;		}				public function set centerX(value:Number):void {			_center.x = value;						var bounds:Rectangle = trackBounds();			_center.x = Math.max(bounds.left, Math.min(bounds.right , _center.x));		}				public function get centerY():Number {			return _center.y;		}				public function set centerY(value:Number):void {			_center.y = value;						var bounds:Rectangle = trackBounds();			_center.y = Math.max(bounds.top , Math.min(bounds.bottom, _center.y));		}				public function get position():Number {			return _position;		}				public function set position(value:Number):void {			_position = Math.min(1, Math.max(0, value)) || _defaultPosition;			var bounds:Rectangle = trackBounds();			if (_axis == HORIZONTAL_AXIS) {				_thumb.x = bounds.left + _position * bounds.width;				_thumb.y = _center.y;			} else if (_axis == VERTICAL_AXIS) {				_thumb.y = bounds.right + _position * bounds.height;				_thumb.x = _center.x;			}			}				public function get encloseThumb():Boolean {			return _encloseThumb;		}				public function set encloseThumb(value:Boolean):void {			_encloseThumb = value;		}				// PUBLIC METHODS				public function letGo(event:MouseEvent = null):void {			stopScroll(event);			if (_draggingThumb) {				dropThumb(event);			}		}						// PRIVATE & PROTECTED METHODS				protected function addStageListeners(event:Event = null):void {			_stage = stage;			_stage.addEventListener(MouseEvent.MOUSE_UP, letGo);			removeEventListener(Event.ADDED_TO_STAGE, addStageListeners);						var bounds:Rectangle = trackBounds();			if (_axis == HORIZONTAL_AXIS) {				_thumb.x = Math.max(bounds.left, Math.min(bounds.right , _thumb.x));				_thumb.y = _center.y;			} else if (_axis == VERTICAL_AXIS) {				_thumb.y = Math.max(bounds.top , Math.min(bounds.bottom, _thumb.y));					_thumb.x = _center.x;			}		}				protected function startScroll(event:MouseEvent):void {			var target:DisplayObject = event.currentTarget as DisplayObject;			scrollStep = _scrollSpeed;			if (target == _track && _scrollToMouse) {				scrollStep *= 2;				_scrollingToMouse = true;			} else {				if (target.name.indexOf("backArrow") != -1) {					scrollStep *= -1;				}			}			updateScroll(event);			scrollTimer.start();		}				protected function stopScroll(event:MouseEvent):void {			_scrollingToMouse = false;			scrollTimer.stop();		}				protected function updateScroll(event:Event):void {			var bounds:Rectangle = trackBounds();			if (_axis == HORIZONTAL_AXIS) {				if (_scrollingToMouse) {					if (Math.abs(mouseX - _thumb.x) < scrollStep) {						_thumb.x = mouseX;					} else {						_thumb.x += scrollStep * (_thumb.x < mouseX ? 1 : -1);					}				} else {					_thumb.x += scrollStep;				}				_thumb.x = Math.max(bounds.left, Math.min(bounds.right , _thumb.x));				_position = (_thumb.x - bounds.x) / bounds.width;				_thumb.y = _center.y;							} else if (_axis == VERTICAL_AXIS) {				if (_scrollingToMouse) {					if (Math.abs(mouseY - _thumb.y) < scrollStep) {						_thumb.y = mouseY;					} else {						_thumb.y += scrollStep * (_thumb.y < mouseY ? 1 : -1);					}				} else {					_thumb.y += scrollStep;				}				_thumb.y = Math.max(bounds.top , Math.min(bounds.bottom, _thumb.y));				_position = (_thumb.y - bounds.y) / bounds.height;				_thumb.x = _center.x;			}			dispatchChange();		}				protected function grabThumb(event:Event):void {			if (_stage) {				_draggingThumb = true;				grasp.x = _thumb.mouseX;				grasp.y = _thumb.mouseY;								_stage.addEventListener(MouseEvent.MOUSE_MOVE, dragThumb);			}		}				protected function dropThumb(event:Event):void {			if (_stage) {				_draggingThumb = false;				dragThumb(event);				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragThumb);			}		}				protected function dragThumb(event:Event):void {			var bounds:Rectangle = trackBounds();			if (_axis == HORIZONTAL_AXIS) {				_thumb.x = Math.max(bounds.left, Math.min(bounds.right,  mouseX + grasp.x));				_position = (_thumb.x - bounds.x) / bounds.width;				_thumb.y = _center.y;			} else if (_axis == VERTICAL_AXIS) {				_thumb.y = Math.max(bounds.top,  Math.min(bounds.bottom, mouseY + grasp.y));				_position = (_thumb.y - bounds.y) / bounds.height;				_thumb.x = _center.x;			}			dispatchChange();		}				protected function trackBounds():Rectangle {			var returnVal:Rectangle = _track.getBounds(this);			if (_encloseThumb) {				var thumbBounds:Rectangle = _thumb.getBounds(_thumb);				returnVal.width -= thumbBounds.width;				returnVal.x -= thumbBounds.x;				returnVal.height -= thumbBounds.height;				returnVal.y -= thumbBounds.y;			}			return returnVal;		}				protected function dispatchChange():void {			CHANGE_EVENT.position = _position;			dispatchEvent(CHANGE_EVENT);		}	}}