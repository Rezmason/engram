﻿package net.rezmason.engram {		// IMPORT STATEMENTS	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.text.TextField;	import flash.text.TextFormatAlign;		public class GameMenu extends MenuBase {				// CLASS PROPERTIES		private static const DESCRIPTION_BLURB:String = "Pick one. These are different modes of play. Mouse over them for a description.";		private static const ARCADE_BLURB:String = "Endless random mix of your enabled modules. Get your name up on the scoreboard.";		private static const STUDIO_BLURB:String = "Generate and save a picture by playing through the modules you selected.";		private static const DRILL_BLURB:String = "A place where you can break in those weird modules that you're unfamiliar with.";		private static const FUMIGATE_BLURB:String = "Fun and easy debugger/tester for all you module developers. All three of you.";				// INSTANCE PROPERTIES		private var _gameButtons:Sprite = new Sprite;		private var gameMenuKeyMatchings:Object = {};						// CONSTRUCTOR		public function GameMenu(__main:Main):void {						super(true, false);						removeChild(btnFumigate);			addChild(_gameButtons);			_gameButtons.y = btnArcade.y;			btnArcade.y = btnDrill.y = btnStudio.y = btnFumigate.y = 0;			_gameButtons.addChild(btnArcade);			_gameButtons.addChild(btnDrill);			_gameButtons.addChild(btnStudio);			_gameButtons.x = -(_gameButtons.getBounds(_gameButtons).left + _gameButtons.width / 2);			removeChild(btnCancel);			removeChild(txtDescription);			btnCancel.text = "BACK";			btnCancel.textAlign = TextFormatAlign.LEFT;			btnCancel.x = getBounds(this).left + btnCancel.width / 2;			txtDescription.width = _gameButtons.getBounds(this).width - btnCancel.width * 1.25;			txtDescription.x = getBounds(this).right - txtDescription.width;			addChild(btnCancel);			addChild(txtDescription);						btnArcade.addEventListener(MouseEvent.CLICK, dispatchArcade);			btnArcade.addEventListener(MouseEvent.MOUSE_OVER, showDescription);			btnDrill.addEventListener(MouseEvent.CLICK, dispatchDrill);			btnDrill.addEventListener(MouseEvent.MOUSE_OVER, showDescription);			btnStudio.addEventListener(MouseEvent.CLICK, dispatchStudio);			btnStudio.addEventListener(MouseEvent.MOUSE_OVER, showDescription);			btnFumigate.addEventListener(MouseEvent.CLICK, dispatchFumigate);			btnFumigate.addEventListener(MouseEvent.MOUSE_OVER, showDescription);						addEventListener(MouseEvent.MOUSE_OUT, resetDescription);						gameMenuKeyMatchings["A"] = btnArcade;			gameMenuKeyMatchings["S"] = btnStudio;			gameMenuKeyMatchings["D"] = btnDrill;			gameMenuKeyMatchings["F"] = btnFumigate;						btnCancel.addEventListener(MouseEvent.CLICK, __main.showLast);			addEventListener(GameType.ARCADE, __main.chooseGame);			addEventListener(GameType.DRILL, __main.chooseGame);			addEventListener(GameType.STUDIO, __main.chooseGame);			addEventListener(GameType.FUMIGATE, __main.chooseGame);						_defaultAffirmative = null;			_defaultNegative = btnCancel;						resetDescription();		}				// GETTERS & SETTERS				internal function get gameButtons():Sprite {			return _gameButtons;		}				// INTERNAL METHODS				internal function showDebugButton(event:Event = null):void {			_gameButtons.addChild(btnFumigate);			_gameButtons.x = -(_gameButtons.getBounds(_gameButtons).x + _gameButtons.width / 2);			removeChild(btnCancel);			removeChild(txtDescription);			btnCancel.x = getBounds(this).left + btnCancel.width / 2;			txtDescription.width = _gameButtons.getBounds(this).width - btnCancel.width * 1.25;			txtDescription.x = getBounds(this).right - txtDescription.width;			addChild(txtDescription);			addChild(btnCancel);		}				internal function keyResponder(keyVal:String):void {			if (gameMenuKeyMatchings[keyVal] && gameMenuKeyMatchings[keyVal].stage) {				gameMenuKeyMatchings[keyVal].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));				gameMenuKeyMatchings[keyVal].dispatchEvent(new MouseEvent(MouseEvent.CLICK));			}		}				// PRIVATE METHODS				private function dispatchArcade(event:Event):void		{			dispatchEvent(new Event(GameType.ARCADE));		}				private function dispatchDrill(event:Event):void		{			dispatchEvent(new Event(GameType.DRILL));		}				private function dispatchStudio(event:Event):void		{			dispatchEvent(new Event(GameType.STUDIO));		}				private function dispatchFumigate(event:Event):void		{			dispatchEvent(new Event(GameType.FUMIGATE));		}				private function showDescription(event:MouseEvent):void {			switch (event.currentTarget) {				case btnArcade:					txtDescription.text = ARCADE_BLURB.toUpperCase();				break;				case btnDrill:					txtDescription.text = DRILL_BLURB.toUpperCase();				break;				case btnStudio:					txtDescription.text = STUDIO_BLURB.toUpperCase();				break;				case btnFumigate:					txtDescription.text = FUMIGATE_BLURB.toUpperCase();				break;			}		}				private function resetDescription(event:Event = null):void {			txtDescription.text = DESCRIPTION_BLURB.toUpperCase();		}	}}