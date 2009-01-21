﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.display.InteractiveObject;	import flash.display.Stage;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.events.TextEvent;	import flash.ui.Keyboard;		import net.rezmason.engram.Controller;	import net.rezmason.engram.View;	import net.rezmason.gui.GUIButton;	import net.rezmason.media.SoundManager;		public final class ScoreInput extends MenuBase {				// CLASS PROPERTIES		private static const WOOHAHS:Array = ["YEAH BABY", "BOOYAH", "ZING", "OH SNAP", "HALLELUJAH"];				// INSTANCE PROPERTIES		private var _listening:Boolean = false;		private var _controller:Controller, _view:View;		private var _stage:Stage;		private var inputObject:InteractiveObject;		private var soundManager:SoundManager = SoundManager.INSTANCE;						public function ScoreInput(__controller:Controller, __view:View):void {						_controller = __controller;			_view = __view;			_stage = _view.stage;			inputObject = _view.stage;						btnCancel.addEventListener(MouseEvent.CLICK, _controller.showMainMenu);			addEventListener(Event.COMPLETE, addScore);						btnEnter.addEventListener(MouseEvent.CLICK, showInput);			btnAccept.addEventListener(MouseEvent.CLICK, checkText);			//nameInput.txtName.addEventListener(TextEvent.TEXT_INPUT, playTypeSound);						inputObject.addEventListener(KeyboardEvent.KEY_DOWN, typeResponder);									_defaultNo = btnCancel;						btnCancel.text = "WHATEVER";			btnEnter.text = "SWEET";		}				// GETTERS & SETTERS				override public function get listening():Boolean {			return _listening;		}				override public function get defaultYes():GUIButton {			return (btnAccept.visible ? btnAccept : btnEnter);		}				// PUBLIC METHODS				override public function prepare(...args):void {			btnAccept.text = WOOHAHS[int(Math.random() * WOOHAHS.length)];			btnAccept.visible = false;			btnEnter.visible = true;			nameInput.visible = false;		}				public function checkText(event:MouseEvent):void {			if (nameInput.txtName.text.length) {				_view.stage.focus = _view.stage;				_listening = false;				dispatchEvent(new Event(Event.COMPLETE));			}		}				// PRIVATE METHODS				private function showInput(event:MouseEvent):void {			_listening = true;			btnAccept.visible = true;			btnEnter.visible = false;			nameInput.visible = true;			nameInput.txtName.text = "";		}				private function typeResponder(event:KeyboardEvent):void {						if (!_listening) {				return;			}						var currentText:String = nameInput.txtName.text;			if (event.keyCode == Keyboard.BACKSPACE) {				nameInput.txtName.text = currentText.substr(0, currentText.length);			} else {				nameInput.txtName.text = currentText + String.fromCharCode(event.charCode);			}			soundManager.play("typeSound");		}				private function addScore(event:Event = null):void {			_controller.addScore(event, nameInput.txtName.text);		}	}}