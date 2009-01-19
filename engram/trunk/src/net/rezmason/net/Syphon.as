﻿/** * Syphon 1.5 * by Jeremy Sachs December 9, 2008 * * Let me know if you modify things. I'm interested.  * Don't delete this header. * * jeremysachs@rezmason.net *//* How to use Syphon: *  * In your resource SWF, export all your important Library assets for ActionScript. * Drop all of your important Library assets onto the Stage. * If your Library contains a font, export it for ActionScript and put its class name in a text box on the stage. *  * In your AS3 code, load() your resource SWF into Syphon and listen for its completion: * 		Syphon.addEventListener(Event.COMPLETE, proceed); * 		Syphon.load("./resources.swf"); * Fonts from your resource SWF can now be used as if they were in the main file.  * Other Library assets can be instantiated like so:		var thingie:MovieClip = new Syphon.library.Thingie; *  * Feel free to contact the author with any questions or suggestions. */package net.rezmason.net {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.display.Loader;	import flash.events.ErrorEvent;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLRequest;	import flash.system.ApplicationDomain;	import flash.system.LoaderContext;	import flash.text.Font;	import flash.text.StaticText;	import flash.utils.getQualifiedClassName;	public final class Syphon {				// CLASS PROPERTIES		public static const PATH_ERROR:String = "pathError", LOAD_ERROR:String = "loadError";		private static const PATH_ERROR_EVENT:ErrorEvent = new ErrorEvent(PATH_ERROR);		private static const LOAD_ERROR_EVENT:ErrorEvent = new ErrorEvent(LOAD_ERROR);		private static const COMPLETE_EVENT:Event = new Event(Event.COMPLETE);		private static const INSTANCE_ERROR:ArgumentError = new ArgumentError("Syphon class cannot be instantiated.");		private static const NO_LOADERS_ERROR:Error = new Error("Syphon has not been given any content to load.");		private static const DOUBLE_LOAD_ERROR:Error = new Error("Syphon.load called before previous operation completed.");				private static var init:Boolean = false, hasDomains:Boolean = false;		private static var buddy:EventDispatcher = new EventDispatcher();		private static var loader:Loader, urlRequest:URLRequest, context:LoaderContext;		private static var domains:Object = {};		public static var library:Object = {};				// CONSTRUCTOR		public function Syphon():void {			throw INSTANCE_ERROR;		}				// PUBLIC METHODS				public static function load(__url:String, domain:ApplicationDomain = null):void {						if(loader)			{				throw DOUBLE_LOAD_ERROR;			}						loader = new Loader;			urlRequest = new URLRequest;			context = new LoaderContext;			loader.contentLoaderInfo.addEventListener(Event.INIT, proceed);			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, relayError);			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, relayError);								urlRequest.url = __url;			context.applicationDomain = domain;			loader.load(urlRequest, context);		}				public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false,		 		priority:int = 0, useWeakReference:Boolean = false):void {			buddy.addEventListener(type, listener, useCapture, priority, useWeakReference);		}				public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {			buddy.removeEventListener(type, listener, useCapture);		}				public static function hasEventListener(type:String):Boolean {			return buddy.hasEventListener(type);		}				public static function registerFont(_name:String):void {			var _grr:int = _name.indexOf("\r");			var clazz:Class;						if (_grr != -1) {				_name = _name.substring(0, _grr);			}						clazz = getClass(_name);						if (new clazz is Font) {				Font.registerFont(clazz);			}		}				public static function getClass(_name:String, targetLibrary:String = null):Class {						if (!hasDomains) {				throw NO_LOADERS_ERROR;			}						if (targetLibrary) {				if (domains[targetLibrary].hasDefinition(_name)) {					library[_name] = domains[targetLibrary].getDefinition(_name) as Class;					return library[_name];				}			}						if (library[_name]) {				return library[_name];			}						if (!targetLibrary) {				for (var prop:String in domains) {					if (domains[prop].hasDefinition(_name)) {						library[_name] = domains[prop].getDefinition(_name) as Class;						return library[_name];					}				}			}						return null;		}				// PRIVATE METHODS				private static function relayError(event:ErrorEvent):void {			buddy.dispatchEvent(event);		}				private static function proceed(event:Event):void {						var child:DisplayObject;			var text:String;						domains[loader.name] = loader.contentLoaderInfo.applicationDomain;			hasDomains = true;						with (loader.content) {				while (numChildren) {					child = getChildAt(0);					if (child.hasOwnProperty("text")) {						registerFont(child.text);					} else {						getClass(getQualifiedClassName(getChildAt(0)));					}					removeChildAt(0);				}			}						loader.unload();			loader.contentLoaderInfo.removeEventListener(Event.INIT, proceed);			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, relayError);			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, relayError);			loader = null;			urlRequest = null;			context = null;						buddy.dispatchEvent(COMPLETE_EVENT);		}	}}