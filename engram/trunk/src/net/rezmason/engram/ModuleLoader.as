﻿package net.rezmason.engram {		// IMPORT STATEMENTS	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.InteractiveObject;	import flash.display.Sprite;	import flash.display.Loader;	import flash.display.PixelSnapping;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.TimerEvent;	import flash.net.URLRequest;	import flash.system.LoaderContext;	import flash.utils.getQualifiedClassName;	import flash.utils.Timer;		import net.rezmason.utils.isAIR;		internal class ModuleLoader extends Loader {				// CLASS PROPERTIES		private static const DONE_EVENT:ModuleLoaderEvent = new ModuleLoaderEvent(ModuleLoaderEvent.DONE);		private static const FAIL_EVENT:ModuleLoaderEvent = new ModuleLoaderEvent(ModuleLoaderEvent.FAIL);		internal static const ICON_REZ:int = 512;				// INSTANCE PROPERTIES		private var _module:Object;		private var _moduleIcon:InteractiveObject;		private var _success:Boolean = false;		private var _url:String;		private var waitTimer:Timer = new Timer(500, 1);						// CONSTRUCTOR		public function ModuleLoader():void {			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, beginWait, false, 0, true);			contentLoaderInfo.addEventListener(Event.INIT, processModule, false, -10, true);			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleFailure, false, 0, true);			mouseChildren = false;			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timeOut, false, 0, true);		}				// GETTERS & SETTERS				public function get module():Object {			return _module;		}				public function get success():Boolean {			return _success;		}				public function get moduleIcon():InteractiveObject {			return _moduleIcon;		}				public function get moduleDescription():String {			return (_module.title + " v. " + _module.version) as String;		}				public function get relay():EventDispatcher {						if (_module && _module is Module) {				return _module as EventDispatcher;			}						return contentLoaderInfo.sharedEvents;		}				public function get url():String {			return _url;		}				// PUBLIC METHODS				override public function load(request:URLRequest, context:LoaderContext = null):void {			_success = false;			_module = null;			_url = request.url;			super.load(request, context);		}				override public function unload():void {			_success = false;			_module = null;			_url = null;			super.unload();		}				// PRIVATE METHODS				private function beginWait(event:ProgressEvent):void {			if (waitTimer.running || event.bytesLoaded / event.bytesTotal > 0.5) {				waitTimer.reset();				waitTimer.start();			}		}				private function timeOut(event:Event):void {			FAIL_EVENT.timeOut = true;			dispatchEvent(FAIL_EVENT);		}				private function processModule(event:Event):void {						waitTimer.reset();						if (isAIR()) {				_module = contentLoaderInfo["childSandboxBridge"];				trace("Has mixer:", contentLoaderInfo.applicationDomain.hasDefinition("flash.media.SoundMixer"));			} else {				_module = content;			}						if (checksOut()) {				_success = true;				_module.unlock();				if (_module.hasIcon()) {										var iconData:BitmapData;										if (isAIR()) {						iconData = new BitmapData(ICON_REZ, ICON_REZ, true, 0x00000000);						try {							iconData.setPixels(iconData.rect, _module.getIcon(ICON_REZ, true));						} catch (error:Error) {							trace("Well, that's weird.");						}					} else {						iconData = _module.getIcon(ICON_REZ);					}										if (iconData) {						_moduleIcon = new Sprite;						(_moduleIcon as Sprite).addChild(new Bitmap(iconData, PixelSnapping.AUTO, true));					}				}				dispatchEvent(DONE_EVENT);			} else {				handleFailure();			}		}				private function handleFailure(event:Event = null):void {			FAIL_EVENT.timeOut = false;			_moduleIcon = new FailIcon();			dispatchEvent(FAIL_EVENT);		}				private function checksOut():Boolean {			if (!_module || !fitsDefinition(ModuleDefinition.MODULE)) {				return false;			}						return fitsDefinition(ModuleDefinition.GAME);					}				private function fitsDefinition(definition:Object) : Boolean {			var returnValue:Boolean = true;						var prop;						try {				for (prop in definition) {					returnValue &&= (_module[prop] is definition[prop]);				}			} catch (error:Error) {				trace("Missing", getQualifiedClassName(definition[prop]), prop);				returnValue = false;			}						return returnValue;		}	}	}