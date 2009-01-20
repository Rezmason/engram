﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filters.GlowFilter;			import net.rezmason.engram.Alerts;	import net.rezmason.engram.display.AlertType;	import net.rezmason.engram.SettingsManager;	import net.rezmason.engram.View;	import net.rezmason.engram.display.AlertType;	import net.rezmason.gui.AlertData;		public final class Scoreboard extends MenuBase {				// CLASS PROPERTIES		private static const HILIGHT_FILTER:GlowFilter = new GlowFilter(0x000000, 1, 5, 5, 100, 2);				// INSTANCE PROPERTIES		private var scores:Array;		private var entries:Array = new Array;		private var _view:View;		private var currentEntry:ScoreboardEntry;		private var settingsManager:SettingsManager = SettingsManager.INSTANCE;		private var wipeAlertData:AlertData = Alerts.CLEAR_SCORES.clone();						public function Scoreboard(__view:View):void {						_view = __view;						wipeAlertData.rightButtons[0].func = clearScores;						btnReturn.addEventListener(MouseEvent.CLICK, _view.showLast);			btnErase.addEventListener(MouseEvent.CLICK, clearScoresConfirm);						entries = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10];						_defaultYes = _defaultNo = btnReturn;		}				// PUBLIC METHODS				override public function prepare(...args):void {			var ike:int;			scores = settingsManager.scores;						if (args.length){				var hilight:int = args[0] || -1;			}						if (scores && scores.length) {				for (ike = 0; ike < scores.length; ike += 1) {					currentEntry = entries[ike];					currentEntry.name = scores[ike].name;					currentEntry.score = scores[ike].score;					currentEntry.filters = [];				}								if (hilight != -1) {					currentEntry = entries[hilight];					currentEntry.filters = [HILIGHT_FILTER];				}			}		}				// PRIVATE METHODS				private function clearScores(event:Event = null):void {			settingsManager.clearScores();			prepare();		}				private function clearScoresConfirm(event:Event = null):void {			_view.showPrompt(null, wipeAlertData, AlertType.CANNOT_UNDO, true);		}	}}