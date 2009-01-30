﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.display.InteractiveObject;	import flash.display.Stage;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.text.TextFormatAlign;		import net.rezmason.display.DisplayObjectSlider;	import net.rezmason.engram.IController;	import net.rezmason.engram.IView;	import net.rezmason.engram.SettingsManager;	import net.rezmason.engram.modules.ModuleKeyRoles;	import net.rezmason.gui.GUIAbstract;	import net.rezmason.gui.GUIButton;	import net.rezmason.gui.GUIBtnKey;	import net.rezmason.gui.GUICheckBox;	import net.rezmason.gui.GUIGroup;	import net.rezmason.media.SoundManager;	import net.rezmason.utils.keyboardEventToString;		import com.robertpenner.easing.Quartic;		public final class SettingsMenu extends MenuBase {				// INSTANCE PROPERTIES		private var _listening:Boolean = false;		private var options:Object;				private var keyPairs:Object, inverseKeyPairs:Object;				private var submenus:Object, submenuArray:Array;		private var currentMenuIndex:int = 0;		private var tabs:Array;		private var keySubmenu:KeySubmenu;		private var imageSubmenu:ImageSubmenu;		private var soundSubmenu:SoundSubmenu;		private var moduleSubmenu:ModuleSubmenu;		private var resetSubmenu:ResetSubmenu;				private var _keyGroup:GUIGroup = new GUIGroup, btnKeys:Array;		private var inputObject:InteractiveObject;		private var settingsManager:SettingsManager = SettingsManager.INSTANCE;		private var soundManager:SoundManager = SoundManager.INSTANCE;		private var _controller:IController;		private var _view:IView;		private var _stage:Stage;				private var slider:DisplayObjectSlider = new DisplayObjectSlider(500);		private var tabGroup:GUIGroup = new GUIGroup;						public function SettingsMenu(__controller:IController, __view:IView):void {						_controller = __controller;			_view = __view;			_stage = _view.stage;			inputObject = _view.stage;									keySubmenu = new KeySubmenu(this);			imageSubmenu = new ImageSubmenu(this);			soundSubmenu = new SoundSubmenu(this);			moduleSubmenu = new ModuleSubmenu(this);			resetSubmenu = new ResetSubmenu(this);						addChild(slider);			slider.addEventListener(Event.COMPLETE, finishSlide);						_defaultYes = null;			_defaultNo = btnReturn;						addColorChild(tabBar);						submenus = {				keys:keySubmenu,				image:imageSubmenu,				sound:soundSubmenu,				modules:moduleSubmenu,				reset:resetSubmenu			};						submenuArray = [keySubmenu, imageSubmenu, soundSubmenu, moduleSubmenu, resetSubmenu];						var prop:String;						for (prop in submenus) {				addColorChild(submenus[prop]);			}						tabGroup.addGUIAbstract(tbKeys);			tabGroup.addGUIAbstract(tbImage);			tabGroup.addGUIAbstract(tbSound);			tabGroup.addGUIAbstract(tbModules);			tabGroup.addGUIAbstract(tbReset);			tabGroup.defaultOption = tbKeys;			tabs = tabGroup.radioChildren;						tabGroup.addEventListener(Event.CHANGE, swapTabs);						btnReturn.addEventListener(MouseEvent.CLICK, revertKey);			btnReturn.addEventListener(MouseEvent.CLICK, applySettings);			btnReturn.addEventListener(MouseEvent.CLICK, _controller.interpretSettings);			btnReturn.addEventListener(MouseEvent.CLICK, _controller.showLast);						resetSubmenu.addEventListener("reset", resetSystem);			resetSubmenu.addEventListener("crashDump", _view.showCrashDump);			/*						chxEffects.addEventListener(MouseEvent.CLICK, chxResponder);			chxColors.addEventListener(MouseEvent.CLICK, chxResponder);			chxAudio.addEventListener(MouseEvent.CLICK, chxResponder);			chxSmoothing.addEventListener(MouseEvent.CLICK, chxResponder);						btnDefaults.addEventListener(MouseEvent.CLICK, defaults);			*/			btnKeys = [				keySubmenu.btnAKey, keySubmenu.btnBKey, 				keySubmenu.btnXKey, keySubmenu.btnYKey, 				keySubmenu.btnLKey, keySubmenu.btnRKey, 				keySubmenu.btnUKey, keySubmenu.btnDKey,			];			keySubmenu.btnDefault.addEventListener(MouseEvent.CLICK, defaultKeys);			btnKeys.forEach(initKey);						inverseKeyPairs = settingsManager.keyPairs;			keyPairs = {};			for (prop in inverseKeyPairs) {				keyPairs[inverseKeyPairs[prop]] = prop;			}						inputObject.addEventListener(KeyboardEvent.KEY_DOWN, btnKeyResponder);			inputObject.addEventListener(KeyboardEvent.KEY_UP, resetListening);						options = settingsManager.options;						syncKeys();			//syncCheckBoxes();		}				// GETTERS & SETTERS				override public function get listening():Boolean {			return _listening;		}				// PUBLIC METHODS				override public function prepare(...args):void {			currentMenuIndex = 0;			slider.show(keySubmenu, keySubmenu.standIn, 0, Quartic.easeInOut);			tabGroup.defaultOption = tbKeys;		}				// PRIVATE & PROTECTED METHODS				private function initKey(target:GUIBtnKey, index:int, arr:Array):void {			//addColorChild(target);			target.role = ModuleKeyRoles[target.name.substr(3).toUpperCase()];			target.flag = keySubmenu[target.name + "Flag"];			target.addEventListener(MouseEvent.CLICK, listen);			_keyGroup.addGUIAbstract(target);		}				private function enableMouse(event:Event = null):void {			mouseEnabled = mouseChildren = true;		}				private function disableMouse(event:Event = null):void {			mouseEnabled = mouseChildren = false;		}				private function applySettings(event:Event = null):void {						keyPairs = _keyGroup.keyPairs;						var inverseKeyPairs:Object = {};			for (var prop:String in keyPairs) {				inverseKeyPairs[keyPairs[prop]] = prop;			}			settingsManager.keyPairs = inverseKeyPairs;			settingsManager.options = options;		}				private function swapTabs(event:Event):void {						var menuName:String = tabGroup.chosenOption.name;			menuName = menuName.replace("tb", "").toLowerCase();						if (slider.currentSubject != submenus[menuName]) {				disableMouse();				var nextMenuIndex:int = submenuArray.indexOf(submenus[menuName]);				if (nextMenuIndex < currentMenuIndex) {					slider.show(submenus[menuName], submenus[menuName].standIn, 1, Quartic.easeInOut, 180);				} else {					slider.show(submenus[menuName], submenus[menuName].standIn, 1, Quartic.easeInOut);				}				currentMenuIndex = nextMenuIndex;			}		}				private function finishSlide(event:Event):void {			enableMouse();			(slider.currentSubject as Submenu).trigger();		}				private function resetSystem(event:Event):void {			_controller.resetSystem(event);			_controller.exit(event);		}				private function listen(event:MouseEvent):void {			_stage.focus = inputObject;			_listening = true;			soundManager.play("typeTikaSound");		}				private function revertKey(event:Event):void {			_keyGroup.listening = false;		}		/*		private function syncCheckBoxes():void {			chxEffects.state    = options.blnEffects;			chxColors.state     = options.blnColors;			chxAudio.state      = options.blnAudio;			chxSmoothing.state  = options.blnSmoothing;		}		*/		private function syncKey(target:GUIBtnKey, index:int, arr:Array):void {			target.char = keyPairs[ModuleKeyRoles[target.name.substr(3).toUpperCase()]];		}				private function syncKeys():void {			btnKeys.forEach(syncKey);			_keyGroup.syncKeys();		}				private function defaultKeys(event:Event = null):void {			soundManager.play("typePunkaSound");			_keyGroup.listening = false;			settingsManager.defaultKeys();			keyPairs = {};			inverseKeyPairs = settingsManager.keyPairs;			keyPairs = {};			for (var prop:String in inverseKeyPairs) {				keyPairs[inverseKeyPairs[prop]] = prop;			}			syncKeys();		}		/*		private function defaults(event:Event = null):void {						_keyGroup.listening = false;						settingsManager.defaults();						keyPairs = {};			var keyPairs:Object = settingsManager.keyPairs;			for (var prop:String in keyPairs) {				keyPairs[keyPairs[prop]] = prop;			}						options = settingsManager.options;						syncKeys();			syncCheckBoxes();		}		*/		private function btnKeyResponder(event:KeyboardEvent = null, oldValue:String = null):void {			if (_keyGroup.listening) {				var keyName:String;								keyName = keyboardEventToString(event);								if (keyName && keyName != "TAB" && keyName != "ENTER") {					if (keyName == "ESCAPE" || keyName == "`") {						_keyGroup.listening = false;						soundManager.play("typePunkaSound");					} else if (_keyGroup.tryKey(keyName)) {						soundManager.play("typeTakSound");						_stage.focus = _stage;					} else {						soundManager.play("mispressSound");						_view.zap();					}				}			}		}				private function resetListening(event:KeyboardEvent = null):void {			if (_listening && !_keyGroup.listening) {				_listening = false;			}		}		/*		private function chxResponder(event:MouseEvent):void {			var currentCheckBox:GUICheckBox = event.currentTarget as LargeCheckBox;			switch (currentCheckBox) {				case chxColors:					options.blnColors = currentCheckBox.state;				break;				case chxEffects:					options.blnEffects = currentCheckBox.state;				break;				case chxAudio:					options.blnAudio = currentCheckBox.state;				break;				case chxSmoothing:					options.blnSmoothing = currentCheckBox.state;				break;			}		}		*/	}}