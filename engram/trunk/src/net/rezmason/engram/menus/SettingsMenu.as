﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.display.InteractiveObject;	import flash.display.Stage;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.text.TextFormatAlign;		import net.rezmason.engram.Main;	import net.rezmason.engram.SettingsManager;	import net.rezmason.engram.modules.ModuleKeyRoles;	import net.rezmason.gui.GUIAbstract;	import net.rezmason.gui.GUIButton;	import net.rezmason.gui.GUIBtnKey;	import net.rezmason.gui.GUICheckBox;	import net.rezmason.gui.GUIGroup;	import net.rezmason.media.SoundManager;	import net.rezmason.utils.keyboardEventToString;		public final class SettingsMenu extends MenuBase {				// INSTANCE PROPERTIES		private var _listening:Boolean = false;		private var options:Object;				private var keyPairs:Object, inverseKeyPairs:Object;				private var keyGroup:GUIGroup = new GUIGroup, btnKeys:Array;		private var currentCheckBox:GUICheckBox;		private var inputObject:InteractiveObject;		private var settingsManager:SettingsManager = SettingsManager.INSTANCE;		private var soundManager:SoundManager = SoundManager.INSTANCE;		private var _main:Main;		private var _stage:Stage;						public function SettingsMenu(__main:Main):void {						_main = __main;			_stage = _main.stage;			inputObject = _main.stage;						addColorChild(btnDefaults);			addColorChild(btnReturn);			addColorChild(chxEffects);			addColorChild(chxColors);			addColorChild(chxAudio);			addColorChild(chxSmoothing);						btnDefaults.textAlign = TextFormatAlign.CENTER;						chxEffects.addEventListener(MouseEvent.CLICK, chxResponder);			chxColors.addEventListener(MouseEvent.CLICK, chxResponder);			chxAudio.addEventListener(MouseEvent.CLICK, chxResponder);			chxSmoothing.addEventListener(MouseEvent.CLICK, chxResponder);						btnDefaults.addEventListener(MouseEvent.CLICK, defaults);			btnReturn.addEventListener(MouseEvent.CLICK, revertKey);			btnReturn.addEventListener(MouseEvent.CLICK, applySettings);						btnReturn.addEventListener(MouseEvent.CLICK, _main.interpretSettings);			btnReturn.addEventListener(MouseEvent.CLICK, _main.showLast);						_defaultYes = null;			_defaultNo = btnReturn;						btnKeys = [btnAKey, btnBKey, btnXKey, btnLKey, btnRKey, btnUKey, btnDKey];			btnKeys.forEach(initKey);						inverseKeyPairs = settingsManager.keyPairs;			keyPairs = {};			for (var prop:String in inverseKeyPairs) {				keyPairs[inverseKeyPairs[prop]] = prop;			}						inputObject.addEventListener(KeyboardEvent.KEY_DOWN, keyResponder);			inputObject.addEventListener(KeyboardEvent.KEY_UP, resetListening);						options = settingsManager.options;						syncKeys();			syncCheckBoxes();		}				// GETTERS & SETTERS				public function get listening():Boolean {			return _listening;		}				// PRIVATE METHODS				private function initKey(target:GUIBtnKey, index:int, arr:Array):void {			addColorChild(target);			target.role = ModuleKeyRoles[target.name.substr(3).toUpperCase()];			target.flag = this[target.name.substr(0, 4) + "Flag"];			target.addEventListener(MouseEvent.CLICK, listen);			keyGroup.addGUIAbstract(target);		}				private function applySettings(event:Event = null):void {			keyPairs = keyGroup.keyPairs;						var inverseKeyPairs:Object = {};			for (var prop:String in keyPairs) {				inverseKeyPairs[keyPairs[prop]] = prop;			}			settingsManager.keyPairs = inverseKeyPairs;			settingsManager.options = options;		}				private function listen(event:MouseEvent):void {			_stage.focus = inputObject;			_listening = true;		}				private function revertKey(event:Event):void {			keyGroup.listening = false;		}				private function syncCheckBoxes():void {			chxEffects.state    = options.blnEffects;			chxColors.state     = options.blnColors;			chxAudio.state      = options.blnAudio;			chxSmoothing.state  = options.blnSmoothing;		}				private function syncKey(target:GUIBtnKey, index:int, arr:Array):void {			target.char = keyPairs[ModuleKeyRoles[target.name.substr(3).toUpperCase()]];		}				private function syncKeys():void {			btnKeys.forEach(syncKey);			keyGroup.syncKeys();		}				private function defaults(event:Event = null):void {						keyGroup.listening = false;						settingsManager.defaults();						keyPairs = {};			var keyPairs:Object = settingsManager.keyPairs;			for (var prop:String in keyPairs) {				keyPairs[keyPairs[prop]] = prop;			}						options = settingsManager.options;						syncKeys();			syncCheckBoxes();		}		private function keyResponder(event:KeyboardEvent = null, oldValue:String = null):void {			if (keyGroup.listening) {				var keyName:String;								keyName = keyboardEventToString(event);								if (keyName && keyName != "TAB" && keyName != "ENTER") {					if (keyName == "ESCAPE" || keyName == "`") {						keyGroup.listening = false;					} else if (keyGroup.tryKey(keyName)) {						soundManager.play("entrySound");						_stage.focus = stage;					} else {						soundManager.play("mispressSound");						_main.zap();					}				}			}		}				private function resetListening(event:KeyboardEvent = null):void {			if (_listening && !keyGroup.listening) {				_listening = false;			}		}				private function chxResponder(event:MouseEvent):void {			currentCheckBox = event.currentTarget as LargeCheckBox;			switch (currentCheckBox) {				case chxColors:					options.blnColors = currentCheckBox.state;				break;				case chxEffects:					options.blnEffects = currentCheckBox.state;				break;				case chxAudio:					options.blnAudio = currentCheckBox.state;				break;				case chxSmoothing:					options.blnSmoothing = currentCheckBox.state;				break;			}		}	}}