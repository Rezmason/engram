﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.InteractiveObject;	import flash.display.SimpleButton;	import flash.events.Event;	import flash.events.MouseEvent;			public class GUIWindowWidget extends GUIAbstract {				//  CLASS PROPERTIES & CONSTANTS				// PRIVATE INSTANCE PROPERTIES		private static const CLOSE_WINDOW_EVENT:GUIEvent = new GUIEvent(GUIEvent.CLOSE_WINDOW);		private static const MINIMIZE_WINDOW_EVENT:GUIEvent = new GUIEvent(GUIEvent.MINIMIZE_WINDOW);		private static const MAXIMIZE_WINDOW_EVENT:GUIEvent = new GUIEvent(GUIEvent.MAXIMIZE_WINDOW);		private static const INTERRUPT_EVENT:GUIEvent = new GUIEvent(GUIEvent.INTERRUPT);		private var _closeButton:InteractiveObject;		private var _minimizeButton:InteractiveObject;		private var _maximizeButton:InteractiveObject;		private var _pauseButton:InteractiveObject;		protected var _offset:int;						public function GUIWindowWidget():void {			super(GUIAbstractEnforcer.INSTANCE);						var ike:int;			for (ike = 0; ike < numChildren; ike += 1) {				if (getChildAt(ike) is InteractiveObject && !(getChildAt(ike) is SimpleButton)) {					(getChildAt(ike) as InteractiveObject).mouseEnabled = false;				}			}						if (stage) {				grabStage();			} else {				addEventListener(Event.ADDED_TO_STAGE, grabStage);			}						verifyChildren(this);		}				// GETTERS & SETTERS				public final function get offset():Number{			return _offset;		}				public function set offset(value:Number):void {			_offset = Math.max(0, value);		}				protected final function get closeButton():InteractiveObject {			return _closeButton;		}				protected final function set closeButton(value:InteractiveObject):void {			if (_closeButton) {				removeColorChild(_closeButton);				_closeButton.removeEventListener(MouseEvent.CLICK, closeWindow);			}						_closeButton = value;			addColorChild(_closeButton);			_closeButton.addEventListener(MouseEvent.CLICK, closeWindow);					}				protected final function get minimizeButton():InteractiveObject {			return _minimizeButton;		}				protected final function set minimizeButton(value:InteractiveObject):void {			if (_minimizeButton) {				removeColorChild(_minimizeButton);				_minimizeButton.removeEventListener(MouseEvent.CLICK, minimizeWindow);			}						_minimizeButton = value;			addColorChild(_minimizeButton);			_minimizeButton.addEventListener(MouseEvent.CLICK, minimizeWindow);					}				protected final function get maximizeButton():InteractiveObject {			return _maximizeButton;		}				protected final function set maximizeButton(value:InteractiveObject):void {			if (_maximizeButton) {				removeColorChild(_maximizeButton);				_maximizeButton.removeEventListener(MouseEvent.CLICK, maximizeWindow);			}						_maximizeButton = value;			addColorChild(_maximizeButton);			_maximizeButton.addEventListener(MouseEvent.CLICK, maximizeWindow);					}				protected final function get pauseButton():InteractiveObject {			return _pauseButton;		}				protected final function set pauseButton(value:InteractiveObject):void {			if (_pauseButton) {				removeColorChild(_pauseButton);				_pauseButton.removeEventListener(MouseEvent.CLICK, interrupt);			}						_pauseButton = value;			addColorChild(_pauseButton);			_pauseButton.addEventListener(MouseEvent.CLICK, interrupt);					}				// PRIVATE & PROTECTED METHODS				protected function grabStage(event:Event = null):void {			removeEventListener(Event.ADDED_TO_STAGE, grabStage);		}				protected final function closeWindow(event:MouseEvent):void {			// do closing stuff			dispatchEvent(CLOSE_WINDOW_EVENT);		}				protected final function minimizeWindow(event:MouseEvent):void {			// do minimizing stuff			INTERRUPT_EVENT.interruptImmediately = true;			dispatchEvent(INTERRUPT_EVENT);			dispatchEvent(MINIMIZE_WINDOW_EVENT);		}				protected final function maximizeWindow(event:MouseEvent):void {			// do maximizing stuff			INTERRUPT_EVENT.interruptImmediately = true;			dispatchEvent(INTERRUPT_EVENT);			dispatchEvent(MAXIMIZE_WINDOW_EVENT);		}				protected final function interrupt(event:MouseEvent):void {			// do pausing stuff			INTERRUPT_EVENT.interruptImmediately = false;			dispatchEvent(INTERRUPT_EVENT);		}	}}