﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.InteractiveObject;	import flash.events.Event;	import flash.events.MouseEvent;		public class GUIPeeCeeWindowWidget extends GUIWindowWidget {				// CONSTRUCTOR		public function GUIPeeCeeWindowWidget():void {						reduceImage.visible = false;			reduceImage.y = maximizeImage.y;			reduceImage.mouseEnabled = false;			maximizeImage.mouseEnabled = false;			windowMaximizeButton.addEventListener(MouseEvent.CLICK, swapMaximizeImages);			expectedChildren = {};			expectedChildren["windowCloseButton"] = InteractiveObject;			expectedChildren["windowMinimizeButton"] = InteractiveObject;			expectedChildren["windowMaximizeButton"] = InteractiveObject;			expectedChildren["windowPauseButton"] = InteractiveObject;			super();			closeButton = windowCloseButton;			minimizeButton = windowMinimizeButton;			maximizeButton = windowMaximizeButton;			pauseButton = windowPauseButton;		}				// GETTERS & SETTERS				override public function set offset(value:Number):void {			super.offset = value;						if (_stage) {				x = _stage.stageWidth - _offset;				y = _offset;			}		}				// PRIVATE METHODS				override protected function grabStage(event:Event = null):void {			super.grabStage();						if (_stage) {				x = _stage.stageWidth - _offset;				y = _offset;			}		}				public function swapMaximizeImages(event:MouseEvent):void {			if (reduceImage.visible) {				reduceImage.visible = false;				maximizeImage.visible = true;			} else {				reduceImage.visible = true;				maximizeImage.visible = false;			}		}	}}