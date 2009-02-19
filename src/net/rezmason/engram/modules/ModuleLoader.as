﻿package net.rezmason.engram.modules {		// IMPORT STATEMENTS	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.InteractiveObject;	import flash.display.Sprite;	import flash.display.Stage;	import flash.display.Loader;	import flash.display.PixelSnapping;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.TimerEvent;	import flash.net.URLRequest;	import flash.system.LoaderContext;	import flash.utils.getQualifiedClassName;	import flash.utils.Timer;		import net.rezmason.net.Syphon;	import net.rezmason.utils.HeavyEvent;	import net.rezmason.utils.isAIR;		public final class ModuleLoader extends Loader {				// CLASS PROPERTIES		private static const BYTES_IN_A_MEGABYTE:int = 1048576;		private static const DONE_EVENT:ModuleLoaderEvent = new ModuleLoaderEvent(ModuleLoaderEvent.DONE);		private static const FAIL_EVENT:ModuleLoaderEvent = new ModuleLoaderEvent(ModuleLoaderEvent.FAIL);		public static const ICON_REZ:int = 512;		private static const PARENT_ERROR:SecurityError = new SecurityError("ModuleLoaders can't access their parent DisplayObjects.");		private static const STAGE_ERROR:SecurityError = new SecurityError("Guess what? ModuleLoaders can't access their Stage objects.");		private static const TAMPERING_ERROR:SecurityError = new SecurityError("ModuleLoader doesn't seem to have a public loading interface.");		private static const ADD_CHILD_ERROR:SecurityError = new SecurityError("ModuleLoader is not your friend.");				// INSTANCE PROPERTIES		private var _module:Object;		private var _moduleIcon:InteractiveObject;		private var _success:Boolean = false;		private var _url:String;		private var waitTimer:Timer = new Timer(500, 1);		private var _loaded:Boolean = false;								public function ModuleLoader():void {			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, beginWait, false, 0, true);			contentLoaderInfo.addEventListener(Event.INIT, processModule, false, -10, true);			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleFailure, false, 0, true);			mouseChildren = false;			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timeOut, false, 0, true);			addEventListener(HeavyEvent.HEAVY, cutoff);		}				// GETTERS & SETTERS				public function get module():Object {			return _module;		}				public function get success():Boolean {			return _success;		}				public function get moduleIcon():InteractiveObject {			if (!_moduleIcon) {				_moduleIcon = new (Syphon.getClass("DefaultIcon")) as InteractiveObject;			}			return _moduleIcon;		}				public function get moduleDescription():String {			return (_module.title + " v. " + _module.version) as String;		}				public function get relay():EventDispatcher {						if (_module && _module is Module) {				return _module as EventDispatcher;			}						return contentLoaderInfo.sharedEvents;		}				public function get url():String {			return _url;		}				public function get size():Number {			return contentLoaderInfo.bytesTotal / BYTES_IN_A_MEGABYTE;		}				public function get sizeString():String {			var returnVal:String = size.toString(10);			returnVal = returnVal.substr(0, returnVal.indexOf(".") + 2);			return returnVal;		}				// PUBLIC METHODS				public function loadOnce(request:URLRequest, context:LoaderContext = null):void {			if (!_loaded) {				_loaded = true;				_success = false;				_module = null;				_url = request.url;				super.load(request, context);				}		}				override public function load(request:URLRequest, context:LoaderContext = null):void {			throw TAMPERING_ERROR;		}				override public function unload():void {			throw TAMPERING_ERROR;		}				override public function addChild(child:DisplayObject):DisplayObject {			throw ADD_CHILD_ERROR;			return null;		}		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {			throw ADD_CHILD_ERROR;			return null;		}				override public function get parent():DisplayObjectContainer {			throw PARENT_ERROR;			return null;		}				override public function get stage():Stage {			throw STAGE_ERROR;			return null;		}				public function discard():void {			_success = false;			_module = null;			_url = null;			super.unload();		}				// PRIVATE & PROTECTED METHODS				private function beginWait(event:ProgressEvent):void {			if (waitTimer.running || event.bytesLoaded / event.bytesTotal > 0.5) {				waitTimer.reset();				waitTimer.start();			}		}				private function timeOut(event:Event):void {			FAIL_EVENT.timeOut = true;			dispatchEvent(FAIL_EVENT);		}				private function processModule(event:Event):void {						waitTimer.reset();						if (isAIR()) {				_module = contentLoaderInfo["childSandboxBridge"];				trace("AIR module:", _module);			} else {				_module = content;				trace("Flash module:", _module);			}						if (checksOut()) {				_success = true;				_module.unlock();								if (_module.hasIcon()) {										var iconData:BitmapData;										if (isAIR()) {						iconData = new BitmapData(ICON_REZ, ICON_REZ, true, 0x00000000);						try {							iconData.setPixels(iconData.rect, _module.getIcon(ICON_REZ, true));						} catch (error:Error) {							// Well, that'd be weird.						}					} else {						iconData = _module.getIcon(ICON_REZ);					}										if (iconData) {						_moduleIcon = new Sprite;						(_moduleIcon as Sprite).addChild(new Bitmap(iconData, PixelSnapping.AUTO, true));					}				}				dispatchEvent(DONE_EVENT);			} else {				handleFailure();			}		}				private function handleFailure(event:Event = null):void {			FAIL_EVENT.timeOut = false;			_moduleIcon = new (Syphon.getClass("FailIcon")) as InteractiveObject;			discard();			dispatchEvent(FAIL_EVENT);		}				private function checksOut():Boolean {			if (!_module) {				trace("no module");				return false;			}			if (!isAIR() && !(_module is Module)) {				trace("not a module");				return false;			}			if (!fitsDefinition(ModuleDefinition.MODULE)) {				trace("not like a module");				return false;			}			if (!fitsDefinition(ModuleDefinition.GAME)) {				trace("not like a game module");				return false;			}			return true;		}				private function fitsDefinition(definition:Object):Boolean {			var returnValue:Boolean = true;						var prop:String;						try {				for (prop in definition) {					if (!(_module[prop] is definition[prop])) {						trace("Missing", getQualifiedClassName(definition[prop]), prop);						return false;					}				}			} catch (error:Error) {				trace("Missing", getQualifiedClassName(definition[prop]), prop);				return false;			}						return true;		}				private function cutoff(event:Event):void {			event.stopImmediatePropagation();		}	}	}