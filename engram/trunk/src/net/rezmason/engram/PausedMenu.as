﻿package net.rezmason.engram {		// IMPORT STATEMENTS	import flash.events.MouseEvent;		public class PausedMenu extends MenuBase {				// CONSTRUCTOR		public function PausedMenu(__main:Main):void {						btnResumeGame.addEventListener(MouseEvent.CLICK, __main.resumeGame);			btnEndGame.addEventListener(MouseEvent.CLICK, __main.endGame);			btnSettings.addEventListener(MouseEvent.CLICK, __main.showSettings);									//logo.gotoAndStop("end");			_defaultNo = btnResumeGame;		}				// PUBLIC METHODS				public function activate():void {			//logo.gotoAndPlay(1);		}	}}