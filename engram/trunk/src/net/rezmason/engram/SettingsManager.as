﻿package net.rezmason.engram {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.NetStatusEvent;	import flash.net.SharedObject;	import flash.ui.Keyboard;	import flash.utils.ByteArray;	import flash.utils.getDefinitionByName;		import net.rezmason.engram.modules.ModuleKeyRoles;	import net.rezmason.utils.isAIR;	import net.rezmason.utils.ResEditCrap;		public final class SettingsManager {				// CLASS PROPERTIES		private static const _INSTANCE:SettingsManager = new SettingsManager(SingletonEnforcer);		private static var _initialized:Boolean = false;		private static const SETTINGS_VERSION:String = "3.1.3";				// INSTANCE PROPERTIES		private var settings:Object;		private var settingsSO:SharedObject;		private var EncryptedLocalStore:Class;		private var dataFromELS:ByteArray;		private var attemptFlush:Boolean = true;						public function SettingsManager(enf:Class):void {			if (enf != SingletonEnforcer) {				throw new ArgumentError("You do not create a SettingsManager; you must ask SettingsManager for its sole INSTANCE.");			}		}				// STATIC GETTERS & SETTERS				public static function get INSTANCE():SettingsManager {			if (!_initialized) {				_initialized = true;				_INSTANCE.init();			}			return _INSTANCE;		}				public static function get settingsVersion():String {			return SETTINGS_VERSION;		}				// GETTERS & SETTERS				public function get options():Object {			var obj:Object = {};			for (var prop:String in settings.options) {				obj[prop] = settings.options[prop];			}			return obj;		}				public function set options(value:Object):void {			settings.options = {};			for (var prop:String in value) {				settings.options[prop] = value[prop];			}			save();		}				public function get keyPairs():Object {						var obj:Object = {};			for (var prop:String in settings.keyPairs) {				obj[prop] = settings.keyPairs[prop];			}			return obj;		}				public function set keyPairs(value:Object):void {			settings.keyPairs = {};			for (var prop:String in value) {				settings.keyPairs[prop] = value[prop];			}			save();		}				public function get lastMix():Array {			return (settings.lastMix as Array || new Array()).slice();		}				public function set lastMix(value:Array):void {			settings.lastMix = value.slice();			save();		}				public function get scores():Array {			return settings.scores.slice();		}				public function get moduleList():Object {			return settings.moduleList;		}				public function set moduleList(value:Object):void {			settings.moduleList = value;			save();		}				public function get moduleSettings():Object {			return settings.moduleSettings;		}				public function set moduleSettings(value:Object):void {			settings.moduleSettings = value;			save();		}				public function get coreDump():String {			var strings:Array = [];			var prop:String;						for (prop in settings.options) {				strings.push(prop);			}						for (prop in settings.scores) {				strings.push(settings.scores[prop].name + "__._" + settings.scores[prop].score);			}						return ResEditCrap.generate(300, strings, 80);		}				// PUBLIC METHODS				public function defaults():void {			settings.options = makeOptions();			settings.keyPairs = makeKeyPairs();			save();		}				public function scoreRank(scr:int):int {			var ike:int;						if (scr == 0) {				return -1;			}			if (!settings.scores || !settings.scores.length) {				return 0;			}			for (ike = 0; ike < settings.scores.length; ike += 1) {				if (settings.scores[ike].score < scr) {					return ike;				}			}			if (ike < 10) {				return ike;			}			return -1;		}				public function save():void {			if (isAIR()) {								if (!dataFromELS) {					dataFromELS = new ByteArray();				}								dataFromELS.position = 0;				dataFromELS.writeObject(settings);				EncryptedLocalStore["setItem"]("settings", dataFromELS);							} else if (attemptFlush) {				settingsSO.data.settings = settings;				try {	                settingsSO.flush(10000);	            } catch (error:Error) {					// whatever	            }			}		}				public function addScore(name:String, rnk:int, scr:int):void {			if (name != "") {				settings.scores.splice(rnk, 0, {name:name, score:scr});				if (settings.scores.length > 10) {					settings.scores.pop();				}			}			save();		}				public function clearScores():void {			settings.scores = makeScores();			save();		}				public function wipeEverything():void {			settings = {};			save();		}				// PRIVATE & PROTECTED METHODS				private function init():void {			if (isAIR()) {								EncryptedLocalStore = getDefinitionByName("flash.data.EncryptedLocalStore") as Class;								try {					dataFromELS = EncryptedLocalStore["getItem"]("settings");					settings = dataFromELS.readObject();					if (!settings.settingsVersion || settings.settingsVersion < SETTINGS_VERSION) {						settings = {};					}				} catch (error:Error) {					settings = {};				}								} else {								settingsSO = SharedObject.getLocal("Engram", "/");				settingsSO.addEventListener(NetStatusEvent.NET_STATUS, giveUp);								if (					!settingsSO.data.settings || 					!settingsSO.data.settings.settingsVersion || 					settingsSO.data.settings.settingsVersion < SETTINGS_VERSION					) {					settingsSO.data.settings = {};									}				settings = settingsSO.data.settings;			}						settings.settingsVersion ||= settingsVersion;			settings.keyPairs ||= makeKeyPairs();			settings.options ||= makeOptions();			settings.scores ||= makeScores();			settings.lastMix ||= [];			settings.moduleList ||= {};			settings.moduleSettings ||= {};						save();		}				private function makeKeyPairs():Object {			var obj:Object = {};			obj["Z"] = 		ModuleKeyRoles.AKEY;			obj["X"] = 		ModuleKeyRoles.BKEY;			obj["A"] = 		ModuleKeyRoles.XKEY;			obj["S"] = 		ModuleKeyRoles.YKEY;			obj["LEFT"] = 	ModuleKeyRoles.LKEY;			obj["RIGHT"] = 	ModuleKeyRoles.RKEY;			obj["UP"] = 	ModuleKeyRoles.UKEY;			obj["DOWN"] = 	ModuleKeyRoles.DKEY;			return obj;		}				private function makeOptions():Object {			var obj:Object = {};			obj.blnEffects = true;			obj.blnColors = true;			obj.blnAudio = true;			obj.blnSmoothing = true;			return obj;		}				private function makeScores():Array {			var arr:Array = new Array;			var ike:int;			for (ike = 0; ike < 10; ike += 1) {				arr[ike] = {name:'NOBODY', score:0};			}			return arr;		}				private function giveUp(event:Event = null):void {			attemptFlush = false;		}	}}internal final class SingletonEnforcer{}