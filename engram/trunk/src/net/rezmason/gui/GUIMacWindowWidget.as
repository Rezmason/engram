﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.display.Stage;		public class GUIMacWindowWidget extends GUIWindowWidget {				// CONSTRUCTOR		public function GUIMacWindowWidget():void {			super();						try {				windowCloseButton;			} catch (error:Error) {				throw new GUIError(this, "windowCloseButton", "InteractiveObject");			}						try {				windowMinimizeButton;			} catch (error:Error) {				throw new GUIError(this, "windowMinimizeButton", "InteractiveObject");			}						try {				windowMaximizeButton;			} catch (error:Error) {				throw new GUIError(this, "windowMaximizeButton", "InteractiveObject");			}						try {				windowPauseButton;			} catch (error:Error) {				throw new GUIError(this, "windowPauseButton", "InteractiveObject");			}		}				// PUBLIC METHODS				override public function addToStage(stg:Stage):void {			stg.addChild(this);						x = y = _offset;		}				override public function init(offset:int):void {						_closeButton = windowCloseButton;			_minimizeButton = windowMinimizeButton;			_maximizeButton = windowMaximizeButton;			_pauseButton = windowPauseButton;						super.init(offset);		}	}}