﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.MouseEvent;		import net.rezmason.engram.IController;	import net.rezmason.engram.IView;		public final class PausedMenu extends MenuBase {						public function PausedMenu(__controller:IController, __view:IView):void {						btnResumeGame.addEventListener(MouseEvent.CLICK, __controller.resumeGame);			btnEndGame.addEventListener(MouseEvent.CLICK, __controller.endGame);			btnSettings.addEventListener(MouseEvent.CLICK, __controller.showSettings);									//logo.gotoAndStop("end");			_defaultNo = btnResumeGame;		}				// PUBLIC METHODS				public function activate():void {			//logo.gotoAndPlay(1);		}	}}