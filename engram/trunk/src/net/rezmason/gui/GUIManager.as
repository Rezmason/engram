﻿package net.rezmason.gui {		// IMPORT STATEMENTS	//import flash.desktop.NativeApplication;	//import flash.display.NativeMenu;	//import flash.display.NativeWindow;	import flash.display.Shape;	import flash.display.Stage;	import flash.display.StageDisplayState;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.FullScreenEvent;	import flash.events.MouseEvent;	import flash.geom.ColorTransform;	import flash.utils.getDefinitionByName;		import net.rezmason.utils.isAIR;	import net.rezmason.utils.isMac;		public final class GUIManager extends EventDispatcher {				//  CLASS PROPERTIES & CONSTANTS		private static var _initialized:Boolean = false;		private static var _enableAbstract:Function = defaultEnableAbstract;		private static var _disableAbstract:Function = defaultDisableAbstract;		private static const SUSPEND_EVENT:GUIEvent = new GUIEvent(GUIEvent.SUSPEND, true, false, 0, false);		private static const _INSTANCE:GUIManager = new GUIManager(SingletonEnforcer);		// PRIVATE INSTANCE PROPERTIES		private const REREZ_EVENT:GUIEvent = new GUIEvent(GUIEvent.REREZ);		private var _fullScreenEnabled:Boolean = false;		private var _startingWidth:int, _sizeRatio:Number = 1;		private var _window;		private var _menu;		private var _stage:Stage;		private var fullScreenBack:Shape;		private var NativeApplication:Class, NativeMenu:Class, NativeWindow:Class;						// CONSTRUCTOR		public function GUIManager(enf:Class):void {			if (enf != SingletonEnforcer) {				throw new Error("You do not create a ModuleManager; it is a Singleton.");			}		}				// GETTERS & SETTERS				public static function get INSTANCE():GUIManager {			if (!_initialized) {				_INSTANCE.init();				_initialized = true;			}			return _INSTANCE;		}				public function set stage(value:Stage):void {			if (value && !_stage) {				_stage = value;				_stage.addEventListener(FullScreenEvent.FULL_SCREEN, forceFullscreenOff);				_startingWidth = _stage.stageWidth;			}		}				public function get sizeRatio():Number {			return _sizeRatio;		}				public function get fullScreenEnabled():Boolean {			return _fullScreenEnabled;		}				public static function get enableAbstract():Function {			return _enableAbstract;		}				public static function set enableAbstract(value:Function):void {			try {				value(new TestAbstract(GUIAbstractEnforcer.INSTANCE));				_enableAbstract = value;			} catch (error:Error) {			}		}				public static function get disableAbstract():Function {			return _disableAbstract;		}				public static function set disableAbstract(value:Function):void {			try {				value(new TestAbstract(GUIAbstractEnforcer.INSTANCE));				_disableAbstract = value;			} catch (error:Error) {			}		}				// INTERNAL METHODS				internal function toggleFullScreen():void {						if (!_stage) {				return;			}						var ike:int;			var sWidth:Number, sHeight:Number;						_fullScreenEnabled = !_fullScreenEnabled;						if (_fullScreenEnabled) {				_stage.displayState = "fullScreenInteractive";				_stage.addChildAt(fullScreenBack, 0);				with (fullScreenBack.graphics) {					clear();					beginFill(0x000000);					sWidth = _stage.stageWidth;					sHeight = _stage.stageHeight;					drawRect(-sWidth, -sHeight, 2 * sWidth, 2 * sHeight);					endFill();				}			} else {				_stage.displayState = StageDisplayState.NORMAL;				if (_stage.contains(fullScreenBack)) {					_stage.removeChild(fullScreenBack);					}			}						rerez();		}				internal function close():void {			if (isAIR()) {				NativeApplication.nativeApplication.exit();			}		}				internal function minimize():void {			_fullScreenEnabled = true;			toggleFullScreen();						if (isAIR()) {				NativeApplication.nativeApplication.activeWindow.minimize();			}		}				public function claimFileType(extension:String):void {			if (isAIR()) {				try {					NativeApplication.nativeApplication.setAsDefaultApplication(extension);					} catch (error:Error) {									}			}		}				public function moveWindow(event:MouseEvent):void {			if (!_fullScreenEnabled) {				_window.startMove();			}		}				// PRIVATE STATIC METHODS				private static function defaultEnableAbstract(subject:GUIAbstract):void {			subject.transform.colorTransform = new ColorTransform();		}				private static function defaultDisableAbstract(subject:GUIAbstract):void {			subject.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 128, 128, 128);		}				// PRIVATE & PROTECTED METHODS				private function init():void {						if (isAIR()) {				// throw up them AIR classes!				NativeApplication = getDefinitionByName("flash.desktop.NativeApplication") as Class;				NativeMenu = getDefinitionByName("flash.display.NativeMenu") as Class;				NativeWindow = getDefinitionByName("flash.display.NativeWindow") as Class;				// do AIR things				_window = NativeApplication.nativeApplication.openedWindows[0];				if (NativeApplication.supportsMenu) {					// quench the default menus					_menu = NativeApplication.nativeApplication.menu;					while (_menu.numItems > 1) {						_menu.removeItemAt(1);					}					_menu.getItemAt(0).submenu.removeItemAt(0);				}								NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, autoSuspend);			}						fullScreenBack = new Shape();		}				private function autoSuspend(event:Event):void {			dispatchEvent(SUSPEND_EVENT);		}				private function forceFullscreenOff(event:FullScreenEvent):void {			if (!event.fullScreen) {				_fullScreenEnabled = false;								rerez();			}		}				private function rerez():void {			if (_stage) {				_sizeRatio = _stage.stageWidth / _startingWidth;				dispatchEvent(REREZ_EVENT);			}		}	}}// IMPORT STATEMENTSimport net.rezmason.gui.GUIAbstract;// Helper class: SingletonEnforcerinternal final class SingletonEnforcer{}// Helper class: TestAbstractinternal final class TestAbstract extends GUIAbstract {		public function TestAbstract(instance:*):void {		super(instance);		graphics.lineStyle(1);		graphics.drawRect(0, 0, 10, 10);	}}