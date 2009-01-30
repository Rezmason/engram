﻿package net.rezmason.engram {	// IMPORT STATEMENTS	import flash.display.Sprite;	import flash.display.Stage;	import flash.display.StageQuality;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.KeyboardEvent;	import flash.events.TimerEvent;	import flash.media.SoundMixer;	import flash.media.SoundTransform;	import flash.utils.Timer;		import net.rezmason.engram.display.*;	import net.rezmason.engram.modules.GameType;	import net.rezmason.engram.modules.ModuleDefinition;	import net.rezmason.engram.modules.ModuleEvent;	import net.rezmason.engram.modules.ModuleLoader;	import net.rezmason.engram.modules.ModuleManager;	import net.rezmason.gui.GUIEvent;	import net.rezmason.utils.keyboardEventToString;		public final class Controller extends EventDispatcher implements IController {		// CLASS PROPERTIES		private static const			SPLASH:String =			"\n   ___________     ___________       ___________    _____________       _________      _____  ____    " +			"\n  /           `   |            `    /           `   |            `     /         `    |     ^^     `  " +			"\n |  ,-------,__|  |  +-------,  |  |  ,-------,  |  |  +-------,  |   /  /-----`  `   |  +-,  ,--,  | " +			"\n `  |___          |  |       |  |  |  |       `__/  |  |       |  |  |  |       |  |  |  | `__/  |  | " +			"\n  >  ___)         |  |       |  |  |  |             |  |       |  |  |  |       |  |  |  |       |  | " +			"\n /  /             |  |       |  |  |  |    _____    |  |    ___/  /  `  `_______/  /  |  |       |  | " +			"\n |  |        _    |  |       |  |  |  |   (___  `   |  |   (__  <    /   _______   `  |  |       |  | " +			"\n |  |       / `   |  |       |  |  |  |       |  |  |  |      `  `   |  |       |  |  |  |       |  | " +			"\n |  `-------'  |  |  |       |  |  |  `-------'  |  |  |       |  |  |  |       |  |  |  |       |  | " +			"\n `____________/   |__|       |__|   `___________/   |__|       |__/  |__|       |__|  |__|       |__| " ,			MESSAGE:String =			"\n\nHey, friend! This project needs contributors. If you're Flash-savvy, why not shoot me a quick note at" +			"\n\n	jeremysachs@rezmason.net \n\n and let me know whether you're interested. Enjoy the video games. \n" ;		private static const EXHIBITION:Boolean = false;				private static const APP_VERSION:Number = 3.13;		private static const QUIET:SoundTransform = new SoundTransform(0);		private static const MASTER_SOUND_TRANSFORM:SoundTransform = new SoundTransform();		private static const BAD_DEVELOPER:String = "Yo, cupcake! Take your fucking mitts off my global sound transform!";		private static const BAD_DEVELOPER_ERROR:Error = new Error(BAD_DEVELOPER);		private static const REBOOT_EVENT:Event = new Event("reboot");		// INSTANCE PROPERTIES		private var _useMouse:Boolean = true;		private var currentRank:int = -1, currentScore:int = 0;		private var gameType:String = GameType.ARCADE;		private var moduleLoaders:Array;		private var lastMix:Array;		private var keyPairs:Object = {};		private var options:Object;		private var currentModule:Object;		private var proceedTimer:Timer = new Timer(500, 1);		private var soundCheckTimer:Timer = new Timer(5000);		private var currentModuleLoader:ModuleLoader;		private var settingsManager:SettingsManager;		private var moduleManager:ModuleManager;		private var _stage:Stage;		private var _view:View;						public function Controller(view:View):void {			_view = view;			_view.controller = this;						if (_view.ready) {				initialize();			} else {				_view.addEventListener(Event.COMPLETE, initialize);			}		}				// GETTERS & SETTERS				internal function get view():Sprite {			return _view;		}				// PUBLIC METHODS				public function showMainMenu(event:Event = null):void {			_view.show(ViewStates.MAIN_MENU);		}		public function showGameMenu(event:Event = null):void {			if (!moduleLoaders.length) {				_view.alertUser(null, Alerts.NO_MODULES, AlertType.PROBLEM, true);			} else {				_view.show(ViewStates.GAME_MENU);			}		}				public function pickGame(type:String = null):void {			var blurb:String = _view.pickGame(type);						switch (type) {								default :				case GameType.ARCADE :					showGridMenu(true, blurb);				break;				case GameType.DRILL :					showGridMenu(true, blurb);				break;				case GameType.STUDIO :					showGridMenu(false, blurb);				break;				case GameType.FUMIGATE :					showDebugMenu();				break;			}		}				public function showGridMenu(allowMultipleSelections:Boolean = true, blurb:String = null):void {			_view.show(ViewStates.GRID_MENU, false, moduleLoaders, lastMix, allowMultipleSelections, blurb);		}		public function showDebugMenu(event:Event = null):void {			_view.show(ViewStates.DEBUG_MENU);		}		public function showSettings(event:Event = null):void {			_view.show(ViewStates.SETTINGS_MENU);			}		public function showAboutBox(event:Event = null):void {			_view.show(ViewStates.ABOUT_BOX);		}		public function showScoreboard(event:Event = null):void {			if (event) {				currentRank = -1;			}			_view.show(ViewStates.SCOREBOARD, false, currentRank);		}		public function showLast(event:Event = null):void {			switch (_view.lastState) {				case ViewStates.PAUSED_MENU:					_view.show(_view.lastState);					break;				case ViewStates.GAME_MENU:					if (_view.state == ViewStates.DEBUG_MENU) {						showMainMenu();					} else {						showGameMenu();					}					break;				default:					showMainMenu();					break;			}		}				public function startGame(mix:Array):void {			if (_view.state == ViewStates.GRID_MENU) {				lastMix = mix;				settingsManager.lastMix = moduleManager.loadersToNames(mix);				currentModuleLoader = mix[0];				currentModule = currentModuleLoader.module;				listenToModuleRelay(currentModuleLoader.relay);								currentModule.reset();				showGame(null, false);			}		}		public function endGame(event:Event = null):void {			currentModule.end();						if (gameType == GameType.ARCADE) {				currentScore = currentModule.score;				currentRank = settingsManager.scoreRank(currentScore);				if (currentRank != -1) {					showScoreInput();				} else {					showMainMenu();				}			} else {				showMainMenu(); // for now			}			currentModuleLoader = null;			currentModule = null;		}		public function resumeGame(event:Event = null):void {			showGame(null, true);		}				public function addScore(event:Event = null, playerName:String = null):void {			settingsManager.addScore(playerName, currentRank, currentScore);			interpretSettings();			showScoreboard();		}		public function interpretSettings(event:Event = null):void {			options = settingsManager.options;			lastMix = moduleManager.namesToLoaders(settingsManager.lastMix);			// adjust smoothing instantly			if (options.blnSmoothing == true) {				_stage.quality = StageQuality.HIGH;			} else if (options.blnSmoothing == false) {				_stage.quality = StageQuality.MEDIUM;			}			// turn on and off audio			SoundMixer.soundTransform = (options.blnAudio ? MASTER_SOUND_TRANSFORM : QUIET);			// update key bindings			keyPairs = settingsManager.keyPairs;			moduleManager.interpretSettings();						// check the screen size			if (_stage.stageWidth != options.windowSize.width) {				trace("resize the window:", options.windowSize);			}		}				public function resetSystem(event:Event):void {			// wipe the added modules			moduleManager.jettisonAddedModules();			// wipe the settings			settingsManager.wipeEverything();			// if there is any other data about the User, it goes.		}				public function exit(event:Event = null):void {			_view.guiManager.exit();		}				// INTERNAL METHODS				internal function pauseGame(event:Event = null):void {			if (_view.busy) {				return; // Kind of weird, but oh well			}			if (_view.state == ViewStates.GAME) {				currentModule.pause();				_view.show(ViewStates.PAUSED_MENU, event && event.type == GUIEvent.INTERRUPT && GUIEvent(event).interruptImmediately);			}		}				// PRIVATE & PROTECTED METHODS		private function initialize(event:Event = null):void {						_view.removeEventListener(Event.COMPLETE, initialize);			_stage = _view.stage;						_view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyResponder);			_view.stage.addEventListener(KeyboardEvent.KEY_UP, keyResponder);						moduleManager = new ModuleManager(_view.modulePlayground);			moduleManager.grid = _view.startup;						settingsManager = SettingsManager.INSTANCE;						_view.guiManager.claimFileType(ModuleDefinition.MODULE_EXTENSION);						soundCheckTimer.addEventListener(TimerEvent.TIMER, checkSoundMixer);			proceedTimer.addEventListener(TimerEvent.TIMER_COMPLETE, proceed);			moduleManager.addEventListener(Event.COMPLETE, startProceedTimer);			moduleManager.beginMainLoad();		}		private function checkSoundMixer(event:Event):void {			if (_view.state == ViewStates.SETTINGS_MENU) {				return;			}			var soundTransform:SoundTransform = SoundMixer.soundTransform;			var valid:Boolean = true;			with (soundTransform) {				valid &&= ((volume == 1) == settingsManager.options.blnAudio);				valid &&= leftToLeft == 1 && rightToRight == 1 && leftToRight == 0 && rightToLeft == 0;				valid &&= (pan == 0);			}			if (!valid) {				// GRRRRRRR!				SoundMixer.soundTransform = (settingsManager.options.blnAudio ? MASTER_SOUND_TRANSFORM : QUIET);				throw BAD_DEVELOPER_ERROR;			}		}		private function startProceedTimer(event:Event):void {			proceedTimer.start();		}		private function proceed(event:Event):void {			trace(SPLASH + "v. " + APP_VERSION);			trace(MESSAGE);						_view.setupMenus();			moduleManager.removeEventListener(Event.COMPLETE, startProceedTimer);			moduleManager.addEventListener(Event.COMPLETE, grabSupplementalModules);			_view.guiManager.addEventListener(GUIEvent.INVOCATION, grabNewModules);			_view.guiManager.bestowDroppability(_view, [ModuleDefinition.MODULE_EXTENSION, ModuleDefinition.SWF_EXTENSION]);			_view.addEventListener(GUIEvent.FILE_DROP, grabNewModules);			_view.addEventListener(View.SLIDE_FINISHED, slideFinished);			_view.addEventListener(GUIEvent.INTERRUPT, pauseGame);						moduleLoaders = moduleManager.goodLoaderArray;			interpretSettings();			if (EXHIBITION) {				showIntro();			} else {				showMainMenu();			}						soundCheckTimer.start();						if (!moduleLoaders.length) {				_view.alertUser(null, Alerts.NO_MODULES, AlertType.PROBLEM);			}		}				private function grabSupplementalModules(event:Event):void {			trace("grabSupplementalModules");		}		private function listenToModuleRelay(relay:EventDispatcher):void {			if (!relay.hasEventListener(ModuleEvent.PLAYER_SUCCEED)) {				relay.addEventListener(ModuleEvent.PLAYER_FAIL, gameResponder, false, 0, true);				relay.addEventListener(ModuleEvent.PLAYER_SUCCEED, gameResponder, false, 0, true);			}		}				private function showIntro(event:Event = null):void {			_view.show(ViewStates.EXHIBITION_INTRO);		}		private function showGame(event:Event = null, returning:Boolean = false):void {			_view.show(ViewStates.GAME, false, currentModuleLoader, returning);			currentModule.showGame();		}				private function showScoreInput(event:Event = null):void {			_view.show(ViewStates.SCORE_INPUT, false);		}				private function adjustSize(event:Event = null):void {			_view.adjustSize();			moduleManager.adjustSizes(_view.guiManager.sizeRatio);		}		private function gameResponder(event:Event):void {			// We should only respond to events from the current game			if (event.currentTarget != currentModuleLoader.relay) {				return;			}			if (event.type == ModuleEvent.PLAYER_FAIL) {				endGame();			} else if (event.type == ModuleEvent.PLAYER_SUCCEED) {								_view.cycleColor();								if (gameType == GameType.STUDIO || gameType == GameType.ARCADE) {					// I dunno.				}			}		}		private function slideFinished(event:Event = null):void {			if (_view.state == 1) {				if (!currentModule.isPlaying) {					currentModule.start(null, gameType);				} else if (currentModule.isPaused) {					currentModule.resume();				}			}		}				private function keyResponder(event:KeyboardEvent):void {						if (_view.busy) {				return;			}			var keyIsDown:Boolean = (event.type == KeyboardEvent.KEY_DOWN);			var keyVal:String = keyboardEventToString(event);			if (_view.promptOnscreen || _view.state != ViewStates.GAME) {				_view.interpretKey(keyVal, keyIsDown);			} else {				// keyPairs is an Object in the settings.				if (keyPairs[keyVal]) {					currentModule.inputResponder(keyPairs[keyVal], keyIsDown);				} else if (keyIsDown && (keyVal == "ESCAPE" || keyVal == "`")) {					pauseGame();				}			}		}				private function grabNewModules(event:GUIEvent):void {			pauseGame();			var isPlaying:Boolean = (_view.state == ViewStates.GAME);			var isDebugging:Boolean = (_view.state == ViewStates.DEBUG_MENU);			if (event.type == GUIEvent.INVOCATION) {				moduleManager.testCandidates(_view.guiManager.invocations, isPlaying, isDebugging);			} else if (event.type == GUIEvent.FILE_DROP) {				moduleManager.testCandidates(event.fileArray, isPlaying, isDebugging);			}		}	}}