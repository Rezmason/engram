﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.text.TextField;	import flash.text.TextFormatAlign;		import net.rezmason.engram.CommonSignals;	import net.rezmason.engram.modules.GameType;		public final class GameMenu extends MenuBase {				// CLASS PROPERTIES		private static const DESCRIPTION_BLURB:String = "Pick one. These are different modes of play. Mouse over them for a description.";		private static const ARCADE_BLURB:String = "Endless random mix of your enabled modules. Get your name up on the scoreboard.";		private static const STUDIO_BLURB:String = "Generate and save a picture by playing through the modules you selected.";		private static const DRILL_BLURB:String = "A place where you can break in those weird modules that you're unfamiliar with.";		private static const FUMIGATE_BLURB:String = "Fun and easy debugger/tester for all you module developers. All three of you.";				// INSTANCE PROPERTIES		private var _gameButtons:Sprite = new Sprite;		private var gameMenuKeyMatchings:Object = {};						public function GameMenu():void {						super(true, false);						buttonMap = {				btnCancel: CommonSignals.SHOW_LAST				};						mapButtons();						removeChild(btnFumigate);			addChild(_gameButtons);			_gameButtons.y = btnArcade.y;			btnArcade.y = btnDrill.y = btnStudio.y = btnFumigate.y = 0;			_gameButtons.addChild(btnArcade);			_gameButtons.addChild(btnDrill);			_gameButtons.addChild(btnStudio);			_gameButtons.x = -(_gameButtons.getBounds(_gameButtons).left + _gameButtons.width / 2);			removeChild(btnCancel);			removeChild(txtDescription);			btnCancel.text = "BACK";			btnCancel.textAlign = TextFormatAlign.LEFT;			btnCancel.x = getBounds(this).left + btnCancel.width / 2;			txtDescription.width = _gameButtons.getBounds(this).width - btnCancel.width * 1.25;			txtDescription.x = getBounds(this).right - txtDescription.width;			addChild(btnCancel);			addChild(txtDescription);						btnArcade.addEventListener(MouseEvent.CLICK, setGameType);			btnArcade.addEventListener(MouseEvent.MOUSE_OVER, showDescription);			btnDrill.addEventListener(MouseEvent.CLICK, setGameType);			btnDrill.addEventListener(MouseEvent.MOUSE_OVER, showDescription);			btnStudio.addEventListener(MouseEvent.CLICK, setGameType);			btnStudio.addEventListener(MouseEvent.MOUSE_OVER, showDescription);			btnFumigate.addEventListener(MouseEvent.CLICK, setGameType);			btnFumigate.addEventListener(MouseEvent.MOUSE_OVER, showDescription);						addEventListener(MouseEvent.MOUSE_OUT, resetDescription);						gameMenuKeyMatchings["A"] = btnArcade;			gameMenuKeyMatchings["S"] = btnStudio;			gameMenuKeyMatchings["D"] = btnDrill;			gameMenuKeyMatchings["F"] = btnFumigate;						_defaultYes = null;			_defaultNo = btnCancel;						resetDescription();		}				// PUBLIC METHODS				public function revealDebugButton(event:Event = null):void {			_gameButtons.addChild(btnFumigate);			_gameButtons.x = -(_gameButtons.getBounds(_gameButtons).x + _gameButtons.width / 2);			removeChild(btnCancel);			removeChild(txtDescription);			btnCancel.x = getBounds(this).left + btnCancel.width / 2;			txtDescription.width = _gameButtons.getBounds(this).width - btnCancel.width * 1.25;			txtDescription.x = getBounds(this).right - txtDescription.width;			addChild(txtDescription);			addChild(btnCancel);		}				override public function keyResponder(keyVal:String):void {			if (gameMenuKeyMatchings[keyVal] && gameMenuKeyMatchings[keyVal].stage) {				gameMenuKeyMatchings[keyVal].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));				gameMenuKeyMatchings[keyVal].dispatchEvent(new MouseEvent(MouseEvent.CLICK));			}		}				override public function prepare(...args):void {			if (args.length && args[0]) {				revealDebugButton();			}		}				// PRIVATE & PROTECTED METHODS				private function setGameType(event:Event):void {			switch (event.currentTarget) {				case btnArcade:					_command.param = GameType.ARCADE;				break;				case btnStudio:					_command.param = GameType.STUDIO;				break;				case btnDrill:					_command.param = GameType.DRILL;				break;				case btnFumigate:					_command.param = GameType.FUMIGATE;				break;				default:					_command.param = "";				break;			}						signal(null, CommonSignals.SHOW_GAME_GRID);		}				private function showDescription(event:MouseEvent):void {			switch (event.currentTarget) {				case btnArcade:					txtDescription.text = ARCADE_BLURB.toUpperCase();				break;				case btnDrill:					txtDescription.text = DRILL_BLURB.toUpperCase();				break;				case btnStudio:					txtDescription.text = STUDIO_BLURB.toUpperCase();				break;				case btnFumigate:					txtDescription.text = FUMIGATE_BLURB.toUpperCase();				break;			}		}				private function resetDescription(event:Event = null):void {			txtDescription.text = DESCRIPTION_BLURB.toUpperCase();		}	}}