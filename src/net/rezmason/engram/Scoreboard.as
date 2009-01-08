﻿package net.rezmason.engram {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filters.GlowFilter;		import net.rezmason.gui.AlertData;		public class Scoreboard extends MenuBase {				// CLASS PROPERTIES		private static const HILIGHT_FILTER:GlowFilter = new GlowFilter(0x000000, 1, 5, 5, 100, 2);				// INSTANCE PROPERTIES		private var scores:Array;		private var entries:Array = new Array;		private var _main:Main;		private var currentEntry:ScoreboardEntry;		private var settingsManager:SettingsManager = SettingsManager.INSTANCE;		private var wipeAlertData:AlertData = Alerts.CLEAR_SCORES.clone();				// CONSTRUCTOR		public function Scoreboard(__main:Main):void {						_main = __main;						wipeAlertData.rightButtons[0].func = clearScores;						btnReturn.addEventListener(MouseEvent.CLICK, _main.showLast);			btnErase.addEventListener(MouseEvent.CLICK, clearScoresConfirm);						entries = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10];						_defaultYes = _defaultNo = btnReturn;		}				// PUBLIC METHODS				public function prep(hilight:int = -1):void {			var ike:int;			scores = settingsManager.scores;						if (scores && scores.length) {				for (ike = 0; ike < scores.length; ike += 1) {					currentEntry = entries[ike] as ScoreboardEntry;					currentEntry.name = scores[ike].name;					currentEntry.score = scores[ike].score;					currentEntry.filters = [];				}								if (hilight != -1) {					currentEntry = entries[hilight] as ScoreboardEntry;					currentEntry.filters = [HILIGHT_FILTER];				}			}		}				// PRIVATE METHODS				private function clearScores(event:Event = null):void {			settingsManager.clearScores();			prep();		}				private function clearScoresConfirm(event:Event = null):void {			_main.showPrompt(null, wipeAlertData, AlertType.CANNOT_UNDO, true);		}	}}