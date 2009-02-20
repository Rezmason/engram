﻿package net.rezmason.engram.games.tetris {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.TimerEvent;	import flash.utils.Timer;		import net.rezmason.engram.modules.Game;	import net.rezmason.engram.modules.ModuleEvent;	import net.rezmason.engram.modules.GameModule;	import net.rezmason.engram.modules.GameType;	import net.rezmason.engram.modules.ModuleKeyRoles;	import net.rezmason.engram.modules.ModuleView;	import net.rezmason.media.SoundManager;		import flash.media.SoundTransform;	import flash.utils.getDefinitionByName;		public final class Tetris extends GameModule {				// CLASS PROPERTIES				// INSTANCE PROPERTIES		private var dasGate:Boolean = false;		private var dasSafety:Boolean = false;		private var lastTetris:Boolean = false;		private var gees:int = 1;		private var level:int = 0;		private var totalLines:int = 0;		private var totalPieces:int = 0;		private var totalScore:int = 0;		private var fallSpeed:Number = 0;		private var lastTSpin:int = 0;		private var pausedTimers:Array;		private var presses:Object = {};		private var repeatInputTimer:Timer = new Timer(20);		private var fallTimer:Timer = new Timer(1067);		private var dasTimer:Timer = new Timer(180, 1);		private var dasSafeTimer:Timer = new Timer(200, 1);		//private var newPieceTimer:Timer = new Timer(400, 1);		private var soundManager:SoundManager = SoundManager.INSTANCE;		private var newPieceTimer:Timer = new Timer(400, 1);		private var clearLinesTimer:Timer = new Timer(600, 1);		private var freezeTimer:Timer = new Timer(1000, 1);		private var gameOverTimer:Timer = new Timer(1200, 1);		private var _tetrisGame:TetrisGame = new TetrisGame;		private var _tetrisView:TetrisView = new TetrisView(_tetrisGame);		private var _tetrisSettingsView:TetrisSettingsView = new TetrisSettingsView(_tetrisGame);						public function Tetris():void {						_defaultSettings["Show Ghost"] = true;						_game = _tetrisGame as Game;			_view = _tetrisView as ModuleView;			_settingsView = _tetrisSettingsView as ModuleView;						addColorChild(_view);						_title = "Tetris";			_version = "2.0";			_author = "Rezmason";						addChild(new StopSign);						_icon = new TetrisIcon;						_sounds.freezeSound = new FreezeSound, _channels.freezeSound = 1;			_sounds.rotateSound = new RotateSound, _channels.rotateSound = 1;			_sounds.shiftSound = new ShiftSound, _channels.shiftSound = 1;			_sounds.slamSound = new SlamSound;			_sounds.stuckSound = new StuckSound, _channels.stuckSound = 1;			_sounds.wallKickSound = new WallKickSound, _channels.wallKickSound = 1;			_sounds.zipSound = new ZipSound, _channels.zipSound = 1;			_sounds.newPieceSound = new NewPieceSound, _channels.newPieceSound = 2;			_sounds.swapSound = new SwapSound, _channels.swapSound = 2;			_sounds.beamOnSound = new BeamOnSound, _channels.beamOnSound = 3;			_sounds.beamOffSound = new BeamOffSound, _channels.beamOffSound = 3;			_sounds.bravoSound = new BravoSound;			_sounds.sweatSound = new SweatSound, _channels.sweatSound = 4;			_sounds.phewSound = new PhewSound, _channels.phewSound = 4;			_sounds.lineSound = new LineSound, _channels.lineSound = 5;			_sounds.tSpinSound = new TSpinSound, _channels.tSpinSound = 5;			_sounds.tetrisSound = new TetrisSound, _channels.tetrisSound = 5;			_sounds.gameOverSound = new GameOverSound;						_tetrisGame.addEventListener(ModuleEvent.PLAYER_FAIL, prepGameOver, false, 0, true);			_tetrisGame.addEventListener(TetrisEvent.NEW_PIECE, prepNewPiece, false, 0, true);			_tetrisGame.addEventListener(TetrisEvent.CLEARED_LINES, prepClearLines, false, 0, true);			_tetrisGame.addEventListener(TetrisEvent.FREEZING, startFreeze, false, 0, true);			_tetrisGame.addEventListener(TetrisEvent.THAWED, stopFreeze, false, 0, true);			_tetrisGame.addEventListener(TetrisEvent.HOLD, hold, false, 0, true);			_tetrisGame.addEventListener(TetrisEvent.TSPIN, tallyScore, false, 0, true);			_tetrisGame.addEventListener(TetrisEvent.BANG, makeBang, false, 0, true);						repeatInputTimer.addEventListener(TimerEvent.TIMER, repeatInput, false, 0, true);			dasTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dasDone, false, 0, true);			dasSafeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, armDas, false, 0, true);			fallTimer.addEventListener(TimerEvent.TIMER, fallCycle, false, 0, true);			newPieceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, newPiece, false, 0, true);			clearLinesTimer.addEventListener(TimerEvent.TIMER_COMPLETE, clearLines, false, 0, true);			freezeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, freeze, false, 0, true);			gameOverTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gameOver, false, 0, true);		}				// GETTERS & SETTERS				override public function get score():int {			return totalScore;		}				// PUBLIC METHODS				override public function unlock():void {			super.unlock();		}				override public function reset(event:Event = null):void {			super.reset();						level = 1;			totalLines = 0;			totalPieces = 0;			totalScore = 0;			lastTSpin = 0;			lastTetris = false;		}				override public function resize(ratio:Number = 1, updateView:Boolean = false):void {			_tetrisView.resize(ratio);			if (updateView) {				_tetrisView.updatePiece();				_tetrisView.updateBoard();			}		}				override public function start(event:Event = null, gameType:String = null, debug:Boolean = false):void {						//(getDefinitionByName("flash.media.SoundMixer") as Class).soundTransform = new SoundTransform(0);						super.start();						interpretSettings();						if (debug) {				_tetrisGame.debug();			}						switch (_gameType) {				default :				case GameType.ARCADE :					trace("ARCADE!");				break;				case GameType.STUDIO :					trace("STUDIO!");				break;				case GameType.DRILL :					trace("DRILL!");				break;			}						dasSafety = false;			dasSafeTimer.start();						fallTimer.start();			repeatInputTimer.start();						adjustSpeeds();						newPieceTimer.start();			_tetrisView.showBoardText();			_tetrisView.updatePiece();			_tetrisView.updateBoard();		}				override public function pause(event:Event = null):void {			fallTimer.stop();			repeatInputTimer.stop();						dasTimer.reset();			dasSafeTimer.reset();						pausedTimers = [				newPieceTimer.running,				clearLinesTimer.running,				freezeTimer.running,				gameOverTimer.running,			];						newPieceTimer.reset();			clearLinesTimer.reset();			freezeTimer.reset();			gameOverTimer.reset();						super.pause();		}				override public function resume(event:Event = null):void {			super.resume();						fallTimer.start();			repeatInputTimer.start();						if (pausedTimers[0]) {				newPieceTimer.start();			}						if (pausedTimers[1]) {				clearLinesTimer.start();			}						if (pausedTimers[2]) {				freezeTimer.start();			}						if (pausedTimers[3]) {				gameOverTimer.start();			}						pausedTimers = [];						dasSafety = false;			dasSafeTimer.start();						_tetrisView.updatePiece();		}				override public function end(event:Event = null):void {			super.end();		}				// PRIVATE & PROTECTED METHODS				override protected function handleKeyA(keyDown:Boolean):void {			if (!keyDown) {				return;			}			if (!presses[ModuleKeyRoles.AKEY]) {				switch (_tetrisGame.rotate(Spins.COUNTER_CLOCKWISE)) {					case 1:					soundManager.play("rotateSound");					break;					case 2:					soundManager.play("wallKickSound");					break;					default:					soundManager.play("stuckSound");					break;				};				_tetrisView.updatePiece();				presses[ModuleKeyRoles.AKEY] = true;			}		}		override protected function handleKeyB(keyDown:Boolean):void {			if (!keyDown) {				return;			}			if (!presses[ModuleKeyRoles.BKEY]) {				switch (_tetrisGame.rotate(Spins.CLOCKWISE)) {					case 1:					soundManager.play("rotateSound");					break;					case 2:					soundManager.play("wallKickSound");					break;					default:					soundManager.play("stuckSound");					break;				};				_tetrisView.updatePiece();				presses[ModuleKeyRoles.BKEY] = true;				}		}		override protected function handleKeyX(keyDown:Boolean):void {			if (!keyDown) {				return;			}			if (!presses[ModuleKeyRoles.XKEY]) {				_tetrisGame.hold();				presses[ModuleKeyRoles.XKEY] = true;			}		}		override protected function handleKeyY(keyDown:Boolean):void {			if (!keyDown) {				return;			}			trace("Nothing yet!");		}		override protected function handleKeyU(keyDown:Boolean):void {			if (!keyDown) {				return;			}			if (!presses[ModuleKeyRoles.UKEY]) {				if (_tetrisGame.slam()) {					soundManager.play("slamSound");				}				_tetrisView.updatePiece();				_tetrisView.updateBoard();				presses[ModuleKeyRoles.UKEY] = true;			}		}		override protected function handleKeyD(keyDown:Boolean):void {			if (!keyDown) {				return;			}		}		override protected function handleKeyL(keyDown:Boolean):void {			if (!keyDown) {				return;			}			if (!presses[ModuleKeyRoles.LKEY]) {				presses[ModuleKeyRoles.LKEY] = true;				if (!keys[ModuleKeyRoles.RKEY] || dasGate) {					presses[ModuleKeyRoles.RKEY] = false;					if (_tetrisGame.shift(Shifts.LEFT_POINT)) {						soundManager.play("shiftSound");					} else {						soundManager.play("stuckSound");					}					_tetrisView.updatePiece();					dasGate = false;					dasTimer.reset();					dasTimer.start();				}			}		}		override protected function handleKeyR(keyDown:Boolean):void {			if (!keyDown) {				return;			}			if (!presses[ModuleKeyRoles.RKEY]) {				presses[ModuleKeyRoles.RKEY] = true;				if (!keys[ModuleKeyRoles.LKEY] || dasGate) {					presses[ModuleKeyRoles.LKEY] = false;					if (_tetrisGame.shift(Shifts.RIGHT_POINT)) {						soundManager.play("shiftSound");					} else {						soundManager.play("stuckSound");					}					_tetrisView.updatePiece();					dasGate = false;					dasTimer.reset();					dasTimer.start();				}			}		}				override protected function handleKeyUp(inputType:String):void {			presses[inputType] = false;			if (!(keys[ModuleKeyRoles.RKEY] || keys[ModuleKeyRoles.LKEY])) {				dasGate = false;				dasTimer.reset();			}		}				override protected function interpretSettings():void {						if (_settings["Show Ghost"] != undefined) {				_tetrisView.ghostEnabled = _settings["Show Ghost"];			}						if (_generalOptions.blnEffects) {				_tetrisGame.addEventListener(TetrisEvent.CRISIS, startSweat, false, 0, true);				_tetrisGame.addEventListener(TetrisEvent.CRISIS_AVERTED, stopSweat, false, 0, true);				_tetrisGame.addEventListener(TetrisEvent.CLAP_ON, showBeam, false, 0, true);				_tetrisGame.addEventListener(TetrisEvent.CLAP_OFF, hideBeam, false, 0, true);			} else {				_tetrisGame.removeEventListener(TetrisEvent.CRISIS, startSweat);				_tetrisGame.removeEventListener(TetrisEvent.CRISIS_AVERTED, stopSweat);				_tetrisGame.removeEventListener(TetrisEvent.CLAP_ON, showBeam);				_tetrisGame.removeEventListener(TetrisEvent.CLAP_OFF, hideBeam);				_tetrisView.hideBeam();				_tetrisView.stopSweat();			}		}				private function tallyScore(event:TetrisEvent):void {						var pts:int = 0;			var lev:int = 0;						_tetrisView.updatePiece();			_tetrisView.updateBoard();						totalLines += event.worth;			lev = totalLines / 10 + 1;						if (level != lev) {				succeed();				level = lev;			}						adjustSpeeds();			switch (event.worth) {				case 1:				pts = 40;				break;				case 2:				pts = 100;				break;				case 3:				pts = 300;				break;				case 4:				if (lastTetris) {					pts = 1800;				} else {					pts = 1200;				}				break;			}						if (event.worth != 4) {			soundManager.play("lineSound");				lastTetris = false;			} else {					soundManager.play("tetrisSound");				lastTetris = true;			}						// check for bravo			if (event.bravo) {				soundManager.play("bravoSound");				pts += 1800;			}						// check for tSpin and lastTSpin			if (event.tSpin) {				soundManager.play("tSpinSound");				if (lastTSpin) {					pts += 200 * event.tSpin;				} else {					pts += 100 * event.tSpin;				}				lastTSpin = event.tSpin;			} else {				lastTSpin = 0;			}						pts *= level + 1;			totalScore += pts;			_tetrisView.setScore(totalScore);			_tetrisView.respondToScore(event, _generalOptions.blnEffects);		}				private function adjustSpeeds():void {			fallSpeed = 1067 - 6 * (totalLines + totalPieces / 2);			fallTimer.delay = Math.max(16, fallSpeed);			if (fallSpeed < 16) {				fallTimer.delay = 16;				gees = (-fallSpeed) / 500 * 20;				gees = Math.min(20, Math.max(1, gees));			} else {				gees = 1;			}			freezeTimer.delay = Math.max(600, 1067 - (totalLines + totalPieces / 2));			clearLinesTimer.delay = Math.max(300, 600 - (totalLines + totalPieces / 2) / 2);		}				private function dasDone(event:TimerEvent):void {			dasGate = true;		}				private function repeatInput(event:Event = null):void {						if (keys[ModuleKeyRoles.DKEY] && !keys[ModuleKeyRoles.UKEY]) {				if (_tetrisGame.shift(Shifts.DOWN_POINT)) {					soundManager.play("shiftSound");				};				_tetrisView.updatePiece();			}						if (dasGate && dasSafety) {				if (presses[ModuleKeyRoles.RKEY] && !presses[ModuleKeyRoles.LKEY]) {					if (_tetrisGame.shift(Shifts.RIGHT_POINT)) {						soundManager.play("zipSound");					}					_tetrisView.updatePiece();				} else if (presses[ModuleKeyRoles.LKEY] && !presses[ModuleKeyRoles.RKEY]) {					if (_tetrisGame.shift(Shifts.LEFT_POINT)) {						soundManager.play("zipSound");					}					_tetrisView.updatePiece();				}			}		}				private function armDas(event:TimerEvent):void {			dasSafety = true;		}				private function fallCycle(event:TimerEvent):void {			var ike:int;			for (ike = 0; ike < gees; ike += 1) {				_tetrisGame.fallCycle();			}			_tetrisView.updatePiece();		}				private function freeze(event:TimerEvent):void {			soundManager.play("freezeSound");			_tetrisGame.freeze(event);		}				private function startSweat(event:TetrisEvent):void {			soundManager.play("sweatSound");			_tetrisView.startSweat(event);		}				private function stopSweat(event:TetrisEvent):void {			soundManager.play("phewSound");			_tetrisView.stopSweat(event);		}				private function showBeam(event:TetrisEvent):void {			soundManager.play("beamOnSound");			_tetrisView.showBeam(event);		}						private function hideBeam(event:TetrisEvent):void {			soundManager.play("beamOffSound");			_tetrisView.hideBeam(event);		}				private function prepGameOver(event:ModuleEvent):void {			soundManager.stopAll();			soundManager.play("gameOverSound");			_tetrisView.lose();						gameOverTimer.start();							fallTimer.stop();			repeatInputTimer.stop();						newPieceTimer.reset();			clearLinesTimer.reset();			freezeTimer.reset();			dasTimer.reset();		}				private function prepNewPiece(event:TetrisEvent):void {			dasSafety = false;			dasSafeTimer.start();						if (event.tSpin) {				tallyScore(event);			}						fallTimer.reset();			fallTimer.start();			newPieceTimer.start();			_tetrisView.hideBeam();			_tetrisView.updatePiece();			_tetrisView.updateBoard();		}				private function newPiece(event:TimerEvent):void {			totalPieces += 1;			adjustSpeeds();			_tetrisGame.newPiece();			_tetrisView.stopBang();			_tetrisView.updatePiece();			_tetrisView.updateNextDisplay();			_tetrisView.matureHoldDisplay();			soundManager.play("newPieceSound");		}				private function prepClearLines(event:TetrisEvent):void {			tallyScore(event);						fallTimer.reset();			fallTimer.start();			clearLinesTimer.start();		}				private function clearLines(event:TimerEvent):void {			_tetrisGame.clearLines();			_tetrisView.updatePiece();			_tetrisView.updateBoard();		}				private function hold(event:TetrisEvent):void {			soundManager.play("swapSound");			_tetrisView.updatePiece();			_tetrisView.updateHoldDisplay();			_tetrisView.updateNextDisplay();		}				private function startFreeze(event:TetrisEvent):void {			freezeTimer.start();			_tetrisView.startFreezing(null, freezeTimer.delay / 1000);		}				private function stopFreeze(event:TetrisEvent):void {			freezeTimer.reset();			_tetrisView.resetFreezing();		}				private function makeBang(event:TetrisEvent):void {			_tetrisView.updatePiece();			_tetrisView.startBang();		}	}}