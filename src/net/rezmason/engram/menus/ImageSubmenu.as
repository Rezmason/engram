﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Rectangle;		import net.rezmason.engram.display.WindowSizes;	import net.rezmason.gui.GUICheckBox;	import net.rezmason.gui.GUIGroup;	import net.rezmason.media.SoundManager;	import net.rezmason.utils.isAIR;	public final class ImageSubmenu extends Submenu {				// CLASS PROPERTIES				// INSTANCE PROPERTIES		private var sizeGroup:GUIGroup = new GUIGroup;		private var soundManager:SoundManager = SoundManager.INSTANCE;				public function ImageSubmenu(__settingsMenu:SettingsMenu):void {			super(__settingsMenu);						sizeGroup.addGUIAbstract(radSmall);			sizeGroup.addGUIAbstract(radMedium);			sizeGroup.addGUIAbstract(radLarge);			sizeGroup.addEventListener(Event.CHANGE, changeSize);						addColorChild(chxSmoothing);			addColorChild(chxBuffer);			addColorChild(monitor.littleWallpaper, 1);			addColorChild(monitor.littleScreen);			addColorChild(radSmall);			addColorChild(radMedium);			addColorChild(radLarge);			if (!isAIR()) {				sizeGroup.enabled = false;			}						chxSmoothing.addEventListener(MouseEvent.CLICK, chxResponder);			chxBuffer.addEventListener(MouseEvent.CLICK, chxResponder);						addSounds(this);		}				// GETTERS & SETTERS				override internal function get description():String {			return "Here you can change the game's resolution and smoothness, and toggle the buffer feature.";		}				// INTERNAL METHODS				override internal function trigger(event:Event = null):void {					}				override internal function rerez(ratio:Number = 1):void {			monitor.littleGameWindow.rerez(ratio);		}				// PRIVATE & PROTECTED METHODS				override protected function prepare(event:Event = null):void {			var currentSize:Rectangle = new Rectangle();			currentSize.width = _settingsMenu.options.windowSize.width;			currentSize.height = _settingsMenu.options.windowSize.height;						switch (currentSize.width) {				case WindowSizes.SMALL.width:					sizeGroup.defaultOption = radSmall;				break;				case WindowSizes.MEDIUM.width:					sizeGroup.defaultOption = radMedium;				break;				case WindowSizes.LARGE.width:					sizeGroup.defaultOption = radLarge;				break;			}						chxBuffer.state = _settingsMenu.options.blnBuffer;			chxSmoothing.state = _settingsMenu.options.blnSmoothing;		}				override protected function reset(event:Event = null):void {					}				private function ditto(event:Event):void {			dispatchEvent(event);		}				private function changeSize(event:Event):void {			var newSize:Rectangle;			switch (sizeGroup.chosenOption) {				case radSmall:					newSize = WindowSizes.SMALL.clone();				break;				case radMedium:					newSize = WindowSizes.MEDIUM.clone();				break;				case radLarge:					newSize = WindowSizes.LARGE.clone();				break;			}						_settingsMenu.options.windowSize = {width:newSize.width, height:newSize.height};			_settingsMenu.resizeWindow(newSize);		}				private function chxResponder(event:MouseEvent):void {						var currentCheckBox:GUICheckBox = event.currentTarget as LargeCheckBox;			switch (currentCheckBox) {				case chxSmoothing:					_settingsMenu.options.blnSmoothing = currentCheckBox.state;				break;				case chxBuffer:					_settingsMenu.options.blnBuffer = currentCheckBox.state;				break;			}		}	}}