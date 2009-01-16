﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.events.TextEvent;	import flash.ui.Keyboard;		import net.rezmason.engram.Main;	import net.rezmason.gui.GUIButton;	import net.rezmason.media.SoundManager;		public final class ScoreInput extends MenuBase {				// CLASS PROPERTIES		private static const WOOHAHS:Array = ["YEAH BABY", "BOOYAH", "ZING", "OH SNAP", "HALLELUJAH"];				// INSTANCE PROPERTIES		private var soundManager:SoundManager = SoundManager.INSTANCE;						public function ScoreInput(__main:Main):void {						btnCancel.addEventListener(MouseEvent.CLICK, __main.showMainMenu);			addEventListener(Event.COMPLETE, __main.addScore);						btnEnter.addEventListener(MouseEvent.CLICK, showInput);			btnAccept.addEventListener(MouseEvent.CLICK, checkText);			nameInput.txtName.addEventListener(TextEvent.TEXT_INPUT, playTypeSound);						_defaultNo = btnCancel;						btnCancel.text = "WHATEVER";			btnEnter.text = "SWEET";		}				// GETTERS & SETTERS				override public function get defaultYes():GUIButton {			return (btnAccept.visible ? btnAccept : btnEnter);		}				// PUBLIC METHODS				public function prep():void {			btnAccept.text = WOOHAHS[int(Math.random() * WOOHAHS.length)];			btnAccept.visible = false;			btnEnter.visible = true;			nameInput.visible = false;		}				// PRIVATE METHODS				private function showInput(event:MouseEvent):void {			btnAccept.visible = true;			btnEnter.visible = false;			nameInput.visible = true;			nameInput.txtName.text = "";			stage.focus = nameInput.txtName;		}				public function checkText(event:MouseEvent):void		{			if (nameInput.txtName.text.length) {				stage.focus = stage;				dispatchEvent(new Event(Event.COMPLETE));			}		}				private function playTypeSound(event:TextEvent):void {			soundManager.play("typeSound");		}	}}