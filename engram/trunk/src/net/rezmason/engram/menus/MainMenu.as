﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.MouseEvent;		import net.rezmason.engram.Controller;	import net.rezmason.engram.View;		public final class MainMenu extends MenuBase {						public function MainMenu(__controller:Controller, __view:View):void {			btnNewGame.addEventListener(MouseEvent.CLICK, __controller.showGameMenu);			btnSettings.addEventListener(MouseEvent.CLICK, __controller.showSettings);			btnAbout.addEventListener(MouseEvent.CLICK, __controller.showAboutBox);			btnHighScores.addEventListener(MouseEvent.CLICK, __controller.showScoreboard);			glowTraceLogo.addEventListener(Event.COMPLETE, __view.revealDebugButton);			//logo.gotoAndStop("end");		}	}}