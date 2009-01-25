﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.MouseEvent;		import net.rezmason.display.Moment;	public class GUIGroup extends GUIAbstract {				// CLASS PROPERTIES				// INSTANCE PROPERTIES		protected var _defaultOption:GUIOption;		protected var _chosenOption:GUIOption;		protected var _guiChildren:Array = [], _radioChildren:Array = [], _keyChildren:Array = [];		private var _listening:Boolean = false;		private var _keyPairs:Object = {};		private var _usedKeys:Object = {};		private var currentGUIBtnKey:GUIBtnKey, currentFlag:Moment;						public function GUIGroup():void {			super(GUIAbstractEnforcer.INSTANCE);						var ike:int;			for (ike = 0; ike < _guiChildren.length; ike++) {				addColorChild(_guiChildren[ike]);			}		}				// GETTERS & SETTERS				override public function set enabled(value:Boolean):void {			_enabled = value;						mouseEnabled = _enabled;						_guiChildren.forEach(copyEnabledState);		}				public function get listening():Boolean {			return _listening;		}				public function set listening(value:Boolean):void {			if (_listening != value) {				_listening = value;								if (!_listening) {					if (currentFlag) {						currentFlag.stop();					}					if (currentGUIBtnKey) {						currentGUIBtnKey.pending = false;						_usedKeys[_keyPairs[currentGUIBtnKey.role]] = currentGUIBtnKey;					}					currentGUIBtnKey = null;				}			}		}				public function get guiChildren():Array {			return _guiChildren.slice();		}				public function get radioChildren():Array {			return _radioChildren.slice();		}				public function get keyChildren():Array {			return _keyChildren.slice();		}				public function get keyPairs():Object {			var returnVal:Object = {};			for (var prop:String in _keyPairs) {				returnVal[prop] = _keyPairs[prop];			}			return returnVal;		}				public function get defaultOption():GUIOption {			return _defaultOption;		}				public function set defaultOption(value:GUIOption):void {			addGUIAbstract(value);			_defaultOption = value;			if (_chosenOption) {				_chosenOption.chosen = false;			}			_chosenOption = _defaultOption;			_defaultOption.chosen = true;		}				public function get chosenOption():GUIOption {			return _chosenOption;		}				// PUBLIC METHODS				public function addGUIAbstract(child:GUIAbstract):void {			if (_guiChildren.indexOf(child) == -1) {				_guiChildren.push(child);								if (child is GUIOption) {					_radioChildren.push(child);					(child as GUIOption).chosen = false;					child.addEventListener(Event.CHANGE, changeChosenRadio);				} else if (child is GUIBtnKey) {					_keyChildren.push(child);					_keyPairs[(child as GUIBtnKey).role] = (child as GUIBtnKey).char;					_usedKeys[(child as GUIBtnKey).char] = child;					child.addEventListener(MouseEvent.CLICK, listen);				}			}		}				public function removeGUIAbstract(child:GUIAbstract):void {			var index:int = _guiChildren.indexOf(child);						if (index != -1) {				_guiChildren.splice(index, 1);								if (child is GUIOption) {					if (child == _chosenOption) {						_defaultOption.chosen = true;						_chosenOption.chosen = false;						if (_defaultOption == _chosenOption) {							_defaultOption = null;						}						_chosenOption = _defaultOption;					}					child.removeEventListener(Event.CHANGE, changeChosenRadio);					_radioChildren.splice(_radioChildren.indexOf(child), 1);				} else if (child is GUIBtnKey) {						child.removeEventListener(MouseEvent.CLICK, listen);					_keyPairs[(child as GUIBtnKey).role] = undefined;					_usedKeys[(child as GUIBtnKey).char] = undefined;					_keyChildren.splice(_keyChildren.indexOf(child), 1);				}			}		}				public function syncKeys(event:Event = null):void {			_keyPairs = {};			_usedKeys = {};			var ike:int;			for (ike = 0; ike < _keyChildren.length; ike++) {				_keyPairs[_keyChildren[ike].role] = _keyChildren[ike].char;				_usedKeys[_keyChildren[ike].char] = _keyChildren[ike];			}		}				public function tryKey(char:String):Boolean {			if (!_listening) {				return false;			}						if (currentFlag) {				currentFlag.stop();			}						if (_usedKeys[char]) {				currentFlag = _usedKeys[char].flag;				if (currentFlag) {					currentFlag.play();				}				return false;			}						_usedKeys[_keyPairs[currentGUIBtnKey.role]] = undefined;			_usedKeys[char] = currentGUIBtnKey;			_keyPairs[currentGUIBtnKey.role] = char;			currentGUIBtnKey.char = char;						currentGUIBtnKey = null;			_listening = false;			return true;		}				// PRIVATE & PROTECTED METHODS				private function copyEnabledState(target:GUIAbstract, index:int, arr:Array):void {			target.enabled = _enabled;		}				private function changeChosenRadio(event:Event):void {			var radioChild:GUIOption = event.currentTarget as GUIOption;			if (_chosenOption && _chosenOption != radioChild) {				_chosenOption.chosen = false;			}			_chosenOption = radioChild;			dispatchEvent(event);		}				private function listen(event:Event):void {			listening = false;			currentGUIBtnKey = event.currentTarget as GUIBtnKey;			_usedKeys[_keyPairs[currentGUIBtnKey.role]] = undefined;			currentGUIBtnKey.pending = true;			_listening = true;		}	}}