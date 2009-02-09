﻿package net.rezmason.engram {	// IMPORT STATEMENTS	import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.KeyboardEvent;	import flash.events.TimerEvent;	import flash.net.navigateToURL;	import flash.net.URLRequest;	import flash.utils.Timer;		import net.rezmason.engram.CommonEvents;	import net.rezmason.engram.display.*;	import net.rezmason.engram.modules.GameType;	import net.rezmason.engram.modules.ModuleDefinition;	import net.rezmason.engram.modules.ModuleEvent;	import net.rezmason.engram.modules.ModuleLoader;	import net.rezmason.engram.modules.ModuleManager;	import net.rezmason.gui.GUIEvent;	import net.rezmason.utils.HeavyEvent;	import net.rezmason.utils.keyboardEventToString;		public final class Controller extends EventDispatcher {		// CLASS PROPERTIES		// INSTANCE PROPERTIES		private var _useMouse:Boolean = true;		private var currentRank:int = -1, currentScore:int = 0;		private var gameType:String = GameType.ARCADE;		private var moduleLoaders:Array;		private var lastMix:Array;		private var keyPairs:Object = {};		private var options:Object;		private var currentModule:Object;		private var proceedTimer:Timer = new Timer(500, 1);		private var currentModuleLoader:ModuleLoader;		private var settingsManager:SettingsManager;		private var moduleManager:ModuleManager;		private var _view:View;		private var methodMap:Object;						public function Controller(view:View):void {			_view = view;			_view.controller = this;						if (_view.ready) {				initialize();			} else {				_view.addEventListener(Event.COMPLETE, initialize);			}						methodMap = {				(CommonEvents.NEW_GAME as String): showGameMenu,				(CommonEvents.SHOW_LAST as String): showLast,				(CommonEvents.SHOW_MAIN_MENU as String): showMainMenu,				(CommonEvents.SHOW_SETTINGS as String): showSettings,				(CommonEvents.SHOW_ABOUT_BOX as String): showAboutBox,				(CommonEvents.SHOW_HIGH_SCORES as String): showScoreboard,				(CommonEvents.SHOW_GAME_GRID as String): setGameType,				(CommonEvents.START_GAME as String): startGame,				(CommonEvents.RESUME_GAME as String): resumeGame,				(CommonEvents.END_GAME as String): endGame,				(CommonEvents.ADD_SCORE as String): addScore,				(CommonEvents.SETTINGS_UPDATED as String): interpretSettings,				(CommonEvents.RESET_SYSTEM as String): resetSystem,				(CommonEvents.REMOVE_MODULE as String): removeModule			}		}				// GETTERS & SETTERS				internal function get view():Sprite {			return _view;		}				// PUBLIC METHODS				public function showMainMenu(event:Event = null):void {			_view.show(ViewStates.MAIN_MENU);		}		public function showGameMenu(event:Event = null):void {			if (!moduleLoaders.length) {				_view.alertUser(null, Alerts.NO_MODULES, AlertType.PROBLEM, true);			} else {				_view.show(ViewStates.GAME_MENU);			}		}				public function setGameType(event:HeavyEvent):void {			var blurb:String = _view.setGameType(event.param);						switch (event.param) {								default :				case GameType.ARCADE :					showGridMenu(true, blurb);				break;				case GameType.STUDIO :					showGridMenu(true, blurb);				break;				case GameType.DRILL :					showGridMenu(false, blurb);				break;				case GameType.FUMIGATE :					showDebugMenu();				break;			}		}				public function showGridMenu(allowMultipleSelections:Boolean = true, blurb:String = null):void {			_view.show(ViewStates.GRID_MENU, false, moduleLoaders, lastMix, allowMultipleSelections, blurb);		}		public function showDebugMenu(event:Event = null):void {			_view.show(ViewStates.DEBUG_MENU);		}		public function showSettings(event:Event = null):void {			_view.show(ViewStates.SETTINGS_MENU, false, moduleLoaders);		}		public function showAboutBox(event:Event = null):void {			_view.show(ViewStates.ABOUT_BOX);		}		public function showScoreboard(event:Event = null):void {			if (event) {				currentRank = -1;			}			_view.show(ViewStates.SCOREBOARD, false, currentRank);		}		public function showLast(event:Event = null):void {			switch (_view.lastState) {				case ViewStates.PAUSED_MENU:					_view.show(_view.lastState);					break;				case ViewStates.GAME_MENU:					if (_view.state == ViewStates.DEBUG_MENU) {						showMainMenu();					} else {						showGameMenu();					}					break;				default:					showMainMenu();					break;			}		}				public function startGame(event:HeavyEvent):void {			var mix:Array = event.param as Array;			if (_view.state == ViewStates.GRID_MENU) {				lastMix = mix;				settingsManager.lastMix = moduleManager.loadersToNames(mix);				currentModuleLoader = mix[0];				currentModule = currentModuleLoader.module;				listenToModuleRelay(currentModuleLoader.relay);								currentModule.reset();				showGame(null, false);			}		}		public function endGame(event:Event = null):void {			currentModule.end();						if (gameType == GameType.ARCADE) {				currentScore = currentModule.score;				currentRank = settingsManager.scoreRank(currentScore);				if (currentRank != -1) {					showScoreInput();				} else {					showMainMenu();				}			} else {				showMainMenu(); // for now			}			currentModuleLoader = null;			currentModule = null;		}		public function resumeGame(event:Event = null):void {			showGame(null, true);		}				public function addScore(event:HeavyEvent):void {			settingsManager.addScore(event.param, currentRank, currentScore);			interpretSettings();			showScoreboard();		}		public function interpretSettings(event:Event = null):void {			options = settingsManager.options;			lastMix = moduleManager.namesToLoaders(settingsManager.lastMix);			// update key bindings			keyPairs = settingsManager.keyPairs;			moduleManager.interpretSettings();			_view.interpretSettings(options);		}				public function resetSystem(event:Event):void {			// wipe the added modules			moduleManager.jettisonAddedModules();			// wipe the settings			settingsManager.wipeEverything();			// if there is any other data about the User, it goes.						// maybe exit, maybe reset			event.stopPropagation();			exit();		}				// INTERNAL METHODS				internal function pauseGame(event:Event = null):void {			if (_view.busy) {				return; // Kind of weird, but oh well			}			if (_view.state == ViewStates.GAME) {				currentModule.pause();				_view.show(ViewStates.PAUSED_MENU, event && event.type == GUIEvent.INTERRUPT && GUIEvent(event).interruptImmediately);			}		}				internal function rerezModules(event:Event):void {			moduleManager.rerez(_view.guiManager.sizeRatio);		}				// PRIVATE & PROTECTED METHODS		private function initialize(event:Event = null):void {						_view.removeEventListener(Event.COMPLETE, initialize);			_view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyResponder, false, 0, true);			_view.stage.addEventListener(KeyboardEvent.KEY_UP, keyResponder, false, 0, true);						moduleManager = new ModuleManager(_view.modulePlayground);			moduleManager.grid = _view.startup;						settingsManager = SettingsManager.INSTANCE;						_view.guiManager.claimFileType(ModuleDefinition.MODULE_EXTENSION);						proceedTimer.addEventListener(TimerEvent.TIMER_COMPLETE, proceed);			moduleManager.addEventListener(Event.COMPLETE, startProceedTimer);			moduleManager.beginMainLoad();		}		private function startProceedTimer(event:Event):void {			proceedTimer.start();		}		private function proceed(event:Event):void {						_view.setupMenus();			moduleManager.removeEventListener(Event.COMPLETE, startProceedTimer);			moduleManager.addEventListener(Event.COMPLETE, grabSupplementalModules);			_view.guiManager.addEventListener(GUIEvent.INVOCATION, grabNewModules);			_view.guiManager.addEventListener(GUIEvent.REREZ, rerezModules);			_view.guiManager.bestowDroppability(_view, [ModuleDefinition.MODULE_EXTENSION, ModuleDefinition.SWF_EXTENSION]);			_view.addEventListener(GUIEvent.FILE_DROP, grabNewModules);			_view.addEventListener(View.SLIDE_FINISHED, slideFinished);			_view.addEventListener(GUIEvent.INTERRUPT, pauseGame);						_view.addEventListener(HeavyEvent.HEAVY, interpretHeavy);						moduleLoaders = moduleManager.goodLoaderArray;			interpretSettings();			//showIntro();			showMainMenu();						if (!moduleLoaders.length) {				_view.alertUser(null, Alerts.NO_MODULES, AlertType.PROBLEM);			}		}				private function interpretHeavy(event:HeavyEvent):void {			var func:Function = (methodMap[event.flavor] as Function);			if (func != null) {				func(event);			}		}				private function grabSupplementalModules(event:Event):void {			trace("grabSupplementalModules");		}		private function listenToModuleRelay(relay:EventDispatcher):void {			if (!relay.hasEventListener(ModuleEvent.PLAYER_SUCCEED)) {				relay.addEventListener(ModuleEvent.PLAYER_FAIL, gameResponder, false, 0, true);				relay.addEventListener(ModuleEvent.PLAYER_SUCCEED, gameResponder, false, 0, true);			}		}				private function showIntro(event:Event = null):void {			_view.show(ViewStates.EXHIBITION_INTRO);		}		private function showGame(event:Event = null, returning:Boolean = false):void {			_view.show(ViewStates.GAME, false, currentModuleLoader, returning);			currentModule.showGame();		}				private function showScoreInput(event:Event = null):void {			_view.show(ViewStates.SCORE_INPUT, false);		}				private function gameResponder(event:Event):void {			// We should only respond to events from the current game			if (event.currentTarget != currentModuleLoader.relay) {				return;			}			if (event.type == ModuleEvent.PLAYER_FAIL) {				endGame();			} else if (event.type == ModuleEvent.PLAYER_SUCCEED) {								_view.cycleColor();								if (gameType == GameType.STUDIO || gameType == GameType.ARCADE) {					// I dunno.				}			}		}		private function slideFinished(event:Event = null):void {			if (_view.state == 1) {				if (!currentModule.isPlaying) {					currentModule.start(null, gameType);				} else if (currentModule.isPaused) {					currentModule.resume();				}			}		}				private function keyResponder(event:KeyboardEvent):void {						if (_view.busy) {				return;			}			var keyIsDown:Boolean = (event.type == KeyboardEvent.KEY_DOWN);			var keyVal:String = keyboardEventToString(event);			if (_view.promptOnscreen || _view.state != ViewStates.GAME) {				_view.interpretKey(keyVal, keyIsDown);			} else {				// keyPairs is an Object in the settings.				if (keyPairs[keyVal]) {					currentModule.inputResponder(keyPairs[keyVal], keyIsDown);				} else if (keyIsDown && (keyVal == "ESCAPE" || keyVal == "`")) {					pauseGame();				}			}		}				private function grabNewModules(event:GUIEvent):void {			pauseGame();			var isPlaying:Boolean = (_view.state == ViewStates.GAME);			var isDebugging:Boolean = (_view.state == ViewStates.DEBUG_MENU);			if (event.type == GUIEvent.INVOCATION) {				moduleManager.testCandidates(_view.guiManager.invocations, isPlaying, isDebugging);			} else if (event.type == GUIEvent.FILE_DROP) {				moduleManager.testCandidates(event.fileArray, isPlaying, isDebugging);			}		}				private function removeModule(event:HeavyEvent):void {			trace("Remove module!     Spit module out?", !event.param);		}				private function refreshBrowser():Boolean {			var refreshRequest:URLRequest = new URLRequest("javascript:refreshPage()");			navigateToURL(refreshRequest, "_self");			return true;		}				private function exit(event:Event = null):void {			_view.guiManager.exit() || refreshBrowser();		}	}}