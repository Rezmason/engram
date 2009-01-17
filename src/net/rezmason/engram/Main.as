package net.rezmason.engram {

	// IMPORT STATEMENTS
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	

	import net.rezmason.display.ColorManager;
	import net.rezmason.display.ColorSprite;
	import net.rezmason.engram.display.*;
	import net.rezmason.engram.menus.AboutBox;
	import net.rezmason.engram.menus.DebugMenu;
	import net.rezmason.engram.menus.ExhibitionIntro;
	import net.rezmason.engram.menus.GameMenu;
	import net.rezmason.engram.menus.GridMenu;
	import net.rezmason.engram.menus.MainMenu;
	import net.rezmason.engram.menus.MenuBase;
	import net.rezmason.engram.menus.PausedMenu;
	import net.rezmason.engram.menus.Scoreboard;
	import net.rezmason.engram.menus.ScoreInput;
	import net.rezmason.engram.menus.SettingsMenu;
	import net.rezmason.engram.modules.GameType;
	import net.rezmason.engram.modules.ModuleDefinition;
	import net.rezmason.engram.modules.ModuleEvent;
	import net.rezmason.engram.modules.ModuleLoader;
	import net.rezmason.engram.modules.ModuleManager;
	import net.rezmason.gui.AlertData;
	import net.rezmason.gui.GUIEvent;
	import net.rezmason.gui.GUIManager;
	import net.rezmason.gui.GUIWindowWidget;
	import net.rezmason.media.SoundManager;
	import net.rezmason.utils.isAIR;
	import net.rezmason.utils.isMac;
	import net.rezmason.utils.keyboardEventToString;
	
	public final class Main {

		// CLASS PROPERTIES
		private static  const

			SPLASH:String =
			"\n   ___________     ___________       ___________    _____________       _________      _____  ____    " +
			"\n  /           `   |            `    /           `   |            `     /         `    |     ^^     `  " +
			"\n |  ,-------,__|  |  +-------,  |  |  ,-------,  |  |  +-------,  |   /  /-----`  `   |  +-,  ,--,  | " +
			"\n `  |___          |  |       |  |  |  |       `__/  |  |       |  |  |  |       |  |  |  | `__/  |  | " +
			"\n  >  ___)         |  |       |  |  |  |             |  |       |  |  |  |       |  |  |  |       |  | " +
			"\n /  /             |  |       |  |  |  |    _____    |  |    ___/  /  `  `_______/  /  |  |       |  | " +
			"\n |  |        _    |  |       |  |  |  |   (___  `   |  |   (__  <    /   _______   `  |  |       |  | " +
			"\n |  |       / `   |  |       |  |  |  |       |  |  |  |      `  `   |  |       |  |  |  |       |  | " +
			"\n |  `-------'  |  |  |       |  |  |  `-------'  |  |  |       |  |  |  |       |  |  |  |       |  | " +
			"\n `____________/   |__|       |__|   `___________/   |__|       |__/  |__|       |__|  |__|       |__| " ,

			MESSAGE:String =
			"\n\nHey, friend! This project needs contributors. If you're Flash-savvy, why not shoot me a quick note at" +
			"\n\n	jeremysachs@rezmason.net \n\n and let me know whether you're interested. Enjoy the video games. \n" ;

		private static  const EXHIBITION:Boolean = false;

		private static  const APP_VERSION:Number = 3.13;
		private static  const QUIET:SoundTransform = new SoundTransform(0);
		private static  const MASTER_SOUND_TRANSFORM:SoundTransform = new SoundTransform();
		private static  const BAD_DEVELOPER:String = "Yo, cupcake! Take your fucking mitts off my global sound transform!";
		private static  const BAD_DEVELOPER_ERROR:Error = new Error(BAD_DEVELOPER);

		private static  const ARCADE_BLURB:String = "These are your installed modules. Choose which ones you'd like to play.";
		private static  const STUDIO_BLURB:String = "Let's see what you got, Picasso. Here, make your art palette."
		private static  const DRILL_BLURB:String = "Practice makes perfect. Choose which module you'd like to play.";

		// INSTANCE PROPERTIES
		private var _useMouse:Boolean = true;
		private var state:int = 0;
		private var currentRank:int = -1, currentScore:int = 0;
		private var currentModuleColor:int = 0;
		private var keyPairs:Object = {};
		private var options:Object;
		private var proceedTimer:Timer = new Timer(500, 1);
		private var currentModuleLoader:ModuleLoader;
		private var currentModule:Object;
		private var clickPoint:Point = new Point();
		private var maskShape:Shape;
		private var hexSlider:HexSlider;
		private var moduleColorManager:ColorManager, guiColorManager:ColorManager;
		private var settingsManager:SettingsManager;
		private var mainMenu:MainMenu;
		private var gameMenu:GameMenu;
		private var gridMenu:GridMenu;
		private var debugMenu:DebugMenu;
		private var intro:ExhibitionIntro;
		private var settingsMenu:SettingsMenu;
		private var aboutBox:AboutBox;
		private var pausedMenu:PausedMenu;
		private var menus:Array;
		private var scoreInput:ScoreInput;
		private var scoreboard:Scoreboard;
		private var backdrop:WindowSurface;
		private var startup:Startup;
		private var moduleManager:ModuleManager;
		private var soundManager:SoundManager;
		private var windowButtons:GUIWindowWidget;
		private var guiManager:GUIManager;
		private var sounds:Object = {}, channels:Object = {}, loops:Object = {};
		private var moduleContainer:Sprite = new Sprite;
		private var soundCheckTimer:Timer = new Timer(5000);
		private var backgroundIndex:int;
		private var gameType:String = GameType.ARCADE;
		private var canvas:Canvas;
		private var canvasBlur:BlurFilter = new BlurFilter(4, 4, 1);
		private var canvasFilter:ColorMatrixFilter = new ColorMatrixFilter([
			0.5, 0.5, 0.5, 0, -0.5,
			0.5, 0.5, 0.5, 0, -0.5,
			0.5, 0.5, 0.5, 0, -0.5,
			0, 0, 0, 1, 0,
			]);
		private var moduleLoaders:Array;
		private var lastMix:Array;
		private var errorStatic:ErrorStatic;
		private var prompt:Prompt;
		
		private var _stage:Stage;
		private var _cell:Sprite;
		private var centerSprite:ColorSprite = new ColorSprite;
		
		
		public function Main(cell:Sprite):void {
			
			_cell = cell;
			
			_cell.mouseEnabled = false;
			
			_stage = cell.stage;
			
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.tabChildren = stage.stageFocusRect = false;
			stage.showDefaultContextMenu = false;
			
			centerSprite.mouseEnabled = false;
			centerSprite.x = stage.stageWidth / 2;
			centerSprite.y = stage.stageHeight / 2;

			_cell.loaderInfo.addEventListener(Event.INIT, init);
		}
		
		// PUBLIC METHODS
		
		public function get stage():Stage {
			return _stage;
		}
		
		public function showPrompt(event:Event, alert:AlertData, type:AlertType = null, nearClick:Boolean = false):void {
			grabMousePoint();
			prompt.alertType = type || AlertType.PROBLEM;
			prompt.show(alert, (nearClick ? clickPoint : null));
		}

		public function showMainMenu(event:Event = null):void {
			soundManager.stopChannel(1);
			state = 0;
			hexSlider.show(mainMenu, null, 1.4);
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[0]);
			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[0]);
		}

		public function showGameMenu(event:Event = null):void {
			soundManager.stopChannel(1);

			if (!moduleLoaders.length) {
				showPrompt(null, Alerts.NO_MODULES, AlertType.PROBLEM, true);
				return;
			}

			state = 8;
			hexSlider.show(gameMenu, null, 1.4);
		}

		public function showGridMenu(allowMultipleSelections:Boolean = true, blurb:String = ARCADE_BLURB):void {
			soundManager.stopChannel(1);
			state = 9;
			gridMenu.allowMultipleSelections = allowMultipleSelections;
			gridMenu.blurb = blurb;
			gridMenu.makeGrids(moduleLoaders, lastMix);
			hexSlider.show(gridMenu, null, 1.4);
		}

		public function showDebugMenu(event:Event = null):void {
			soundManager.stopChannel(1);
			state = 10;
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[6]);
			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[6]);
			hexSlider.show(debugMenu, null, 1.4);
		}

		public function showSettings(event:Event = null):void {
			soundManager.stopChannel(1);
			state = 3;
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[7]);
			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[7]);
			hexSlider.show(settingsMenu, null, 1.4);
		}

		public function showAboutBox(event:Event = null):void {
			soundManager.stopChannel(1);
			state = 5;
			soundManager.play("aboutSound");
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[5]);
			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[5]);
			hexSlider.show(aboutBox, null, 1.4);
		}

		public function showDebugButton(event:Event = null):void {
			soundManager.stopChannel(1);
			gameMenu.showDebugButton();
		}

		public function showScoreboard(event:Event = null):void {
			soundManager.stopChannel(1);
			if (event) {
				currentRank = -1;
			}
			soundManager.play("scoresSound");
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[4]);
			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[4]);
			scoreboard.prep(currentRank);
			state = 2;
			hexSlider.show(scoreboard, null, 1.4);
		}

		public function showLast(event:Event = null):void {
			switch (hexSlider.lastSubject) {
				case pausedMenu :
				guiColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);
				showPausedMenu();
				break;
				case gameMenu :
				case gridMenu :
				showGameMenu();
				default :
				guiColorManager.applyColors(GamePalette.MENU_PALETTES[0]);
				moduleColorManager.applyColors(GamePalette.MENU_PALETTES[0]);
				showMainMenu();
				break;
			}
		}
		
		public function chooseGame(event:Event = null):void {

			switch (event.type) {
				default :
				case GameType.ARCADE :
				backgroundIndex = 2;
				break;
				case GameType.DRILL :
				backgroundIndex = 1;
				break;
				case GameType.STUDIO :
				case GameType.FUMIGATE :
				backgroundIndex = 3;
				break;
			}

			guiColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);// for now
			cycleColor(0);

			if (event.type == GameType.ARCADE) {
				showGridMenu(true, ARCADE_BLURB);
			} else if (event.type == GameType.STUDIO) {
				showGridMenu(true, STUDIO_BLURB);
			} else if (event.type == GameType.DRILL) {
				showGridMenu(false, DRILL_BLURB);
			} else if (event.type == GameType.FUMIGATE) {
				showDebugMenu();
			}
		}

		public function startGame(mix:Array):void {
			if (state == 9) {

				lastMix = mix;
				settingsManager.lastMix = mix;
				currentModuleLoader = mix[0];
				currentModule = currentModuleLoader.module;
				listenToModuleRelay(currentModuleLoader.relay);
				
				currentModule.reset();
				showGame();
			}
		}

		public function endGame(event:Event = null):void {
			currentModule.end();

			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);

			if (gameType == GameType.ARCADE) {
				currentScore = currentModule.score;
				currentRank = settingsManager.scoreRank(currentScore);

				if (currentRank != -1) {
					showScoreInput();
				} else {
					showMainMenu();
				}
			} else {
				showMainMenu();
			}

			currentModuleLoader = null;
			currentModule = null;
		}

		public function resumeGame(event:Event = null):void {
			cycleColor(currentModuleColor);
			showGame();
		}
		
		public function addScore(event:Event = null):void {
			settingsManager.addScore(scoreInput.nameInput.txtName.text, currentRank, currentScore);
			interpretSettings();
			showScoreboard();
		}

		public function interpretSettings(event:Event = null):void {
			options = settingsManager.options;
			lastMix = settingsManager.lastMix;

			// adjust smoothing instantly
			if (options.blnSmoothing == true) {
				stage.quality = StageQuality.HIGH;
			} else if (options.blnSmoothing == false) {
				stage.quality = StageQuality.MEDIUM;
			}

			// turn on and off audio
			SoundMixer.soundTransform = (options.blnAudio ? MASTER_SOUND_TRANSFORM : QUIET);

			// update key bindings
			keyPairs = settingsManager.keyPairs;
			moduleManager.interpretSettings();
		}
		
		public function zap(event:Event = null):void {
			errorStatic.play();
			soundManager.play("errorSound");
		}

		// PRIVATE METHODS

		private function init(event:Event):void {
			
			_cell.loaderInfo.removeEventListener(Event.INIT, init);
			
			SettingsManager.appVersion = APP_VERSION;
			moduleManager = new ModuleManager;
			moduleManager.grid = startup = new Startup;
			
			guiManager = GUIManager.INSTANCE;
			guiManager.stage = stage;
			settingsManager = SettingsManager.INSTANCE;
			soundManager = SoundManager.INSTANCE;
			
			GUIManager.disableAbstract = Scribble.scribbleOut;
			GUIManager.enableAbstract = Scribble.removeScribble;
			
			guiManager.claimFileType(ModuleDefinition.MODULE_EXTENSION);

			canvas = new Canvas;
			canvas.mouseEnabled = canvas.mouseChildren = false;
			hexSlider = new HexSlider(stage.stageWidth / 2, canvas, 0.2);
			//canvas.filters = [canvasBlur];
			canvas.filters = [canvasFilter];
			canvas.blendMode = BlendMode.MULTIPLY;

			menus = [
				mainMenu = new MainMenu(this),
				gameMenu = new GameMenu(this),
				gridMenu = new GridMenu(this),
				debugMenu = new DebugMenu(this),
				intro = new ExhibitionIntro(this),
				settingsMenu = new SettingsMenu(this),
				aboutBox = new AboutBox(this),
				pausedMenu = new PausedMenu(this),
				scoreInput = new ScoreInput(this),
				scoreboard = new Scoreboard(this),
				];

			moduleColorManager = new ColorManager(moduleManager);

			backdrop = new WindowSurface(stage.stageWidth, stage.stageHeight);
			backdrop.cacheAsBitmap = true;
			centerSprite.addColorChild(backdrop);

			guiColorManager = new ColorManager(centerSprite);
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[0], 0);

			_cell.mask = maskShape = new Shape;
			redrawMask(backdrop.width, backdrop.height);

			if (isAIR()) {
				backdrop.addEventListener(MouseEvent.MOUSE_DOWN, guiManager.moveWindow);
			}

			sounds.buttonSound = new ButtonSound;
			sounds.typeSound = new TypeSound;
			sounds.settingSound = new SettingSound;
			sounds.mispressSound = new MispressSound;
			sounds.entrySound = new EntrySound;
			sounds.errorSound = new ErrorSound;
			
			sounds.scoresSound = new ScoresSound, channels.scoresSound = 1;
			sounds.harumphSound = new HarumphSound, channels.harumphSound = 1;
			sounds.promptSound = new PromptSound, channels.promptSound = 1;
			sounds.aboutSound = new AboutSound, channels.aboutSound = 1;
			
			sounds.peelSound = new PeelSound, channels.peelSound = 2;
			sounds.stickerSound = new StickerSound, channels.stickerSound = 2;
			
			soundManager.enlistSounds(sounds, channels, loops);

			soundCheckTimer.addEventListener(TimerEvent.TIMER, checkSoundMixer);
			proceedTimer.addEventListener(TimerEvent.TIMER_COMPLETE, proceed);
			moduleManager.addEventListener(Event.COMPLETE, startProceedTimer);
			moduleManager.beginMainLoad();
			
			errorStatic = new ErrorStatic();
			errorStatic.blendMode = BlendMode.MULTIPLY;
			errorStatic.width = stage.stageWidth;
			errorStatic.scaleY = errorStatic.scaleX;
			
			prompt = new Prompt(stage);
			
			_cell.addChild(backdrop);
			_cell.addChild(errorStatic);
			_cell.addChild(startup);
		}

		private function checkSoundMixer(event:Event):void {

			if (state == 3) {
				return;
			}

			var soundTransform:SoundTransform = SoundMixer.soundTransform;
			var valid:Boolean = true;
			with (soundTransform) {
				valid &&= ((volume == 1) == settingsManager.options.blnAudio);
				valid &&= leftToLeft == 1 && rightToRight == 1 && leftToRight == 0 && rightToLeft == 0;
				valid &&= (pan == 0);
			}
			if (!valid) {
				// GRRRRRRR!
				SoundMixer.soundTransform = (settingsManager.options.blnAudio ? MASTER_SOUND_TRANSFORM : QUIET);
				throw BAD_DEVELOPER_ERROR;
			}

		}

		private function startProceedTimer(event:Event):void {
			proceedTimer.start();
		}

		private function proceed(event:Event):void {

			trace(SPLASH + "v. " + APP_VERSION);
			trace(MESSAGE);

			var ike:int;

			moduleManager.removeEventListener(Event.COMPLETE, startProceedTimer);
			moduleManager.addEventListener(Event.COMPLETE, grabSupplementalModules);
			guiManager.addEventListener(GUIEvent.INVOCATION, grabNewModules);
			guiManager.bestowDroppability(_cell, [ModuleDefinition.MODULE_EXTENSION, ModuleDefinition.SWF_EXTENSION]);
			_cell.addEventListener(GUIEvent.FILE_DROP, grabNewModules);
			
			moduleLoaders = moduleManager.goodLoaderArray;

			interpretSettings();

			_cell.removeChild(startup);
			_cell.addChild(centerSprite);
			_cell.addChild(prompt);
			
			prompt.addEventListener(Prompt.ONSCREEN, refuseMouse);
			prompt.addEventListener(Prompt.OFFSCREEN, allowMouse);
			
			//stage.addEventListener(MouseEvent.CLICK, grabMousePoint);
			
			centerSprite.addChild(canvas);
			centerSprite.addChild(hexSlider);
			hexSlider.addEventListener(Event.COMPLETE, afterHexSlider);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyResponder);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyResponder);

			for (ike = 0; ike < menus.length; ike += 1) {
				centerSprite.addColorChild(menus[ike]);
			}
			
			// get window and pause controls
			windowButtons = makeWindowWidget();
			guiManager.registerWindowWidget(windowButtons);
			windowButtons.offset = 12;
			_cell.addChild(windowButtons);
			windowButtons.addEventListener(GUIEvent.SUSPEND, pauseGame);
			guiManager.addEventListener(GUIEvent.SUSPEND, pauseGame);
			guiManager.addEventListener(GUIEvent.REREZ, adjustSize);
			//windowButtons.addEventListener(GUIEvent.CLOSE_WINDOW, function(event:Event):void{});
			centerSprite.addColorChild(windowButtons);

			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[0], 0);
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[0], 0);

			if (EXHIBITION) {
				showIntro();
			} else {
				showMainMenu();
			}
			
			if (!moduleLoaders.length) {
				showPrompt(null, Alerts.NO_MODULES, AlertType.PROBLEM);
			}

			soundCheckTimer.start();
			
			//stage.addChild(new ActiveGraph(0, true, true, 2));
			//showRedrawRegions(true, 0xFFFFFF);
		}
		
		private function grabSupplementalModules(event:Event):void {
			trace("grabSupplementalModules");
		}

		private function listenToModuleRelay(relay:EventDispatcher):void {
			if (!relay.hasEventListener(ModuleEvent.PLAYER_SUCCEED)) {
				relay.addEventListener(ModuleEvent.PLAYER_FAIL, gameResponder, false, 0, true);
				relay.addEventListener(ModuleEvent.PLAYER_SUCCEED, gameResponder, false, 0, true);
			}
		}
		
		private function refuseMouse(event:Event = null):void {
			centerSprite.mouseChildren = false;
		}
		
		private function allowMouse(event:Event = null):void {
			centerSprite.mouseChildren = true;
		}
		
		private function killMouse(event:Event = null):void {
			
		}
		
		private function reviveMouse(event:Event = null):void {
			
		}
		
		private function grabMousePoint(event:Event = null):void {
			clickPoint.x = _cell.mouseX;
			clickPoint.y = _cell.mouseY;
		}
		
		private function showIntro(event:Event = null):void {
			soundManager.stopChannel(1);
			soundManager.play("harumphSound");
			state = -1;
			hexSlider.show(intro, null, 1.4);
			guiColorManager.applyColors(GamePalette.MENU_PALETTES[6]);
			moduleColorManager.applyColors(GamePalette.MENU_PALETTES[6]);
		}

		private function showGame(event:Event = null):void {
			soundManager.stopChannel(1);
			state = 1;
			canvas.filters = [];
			hexSlider.show(currentModuleLoader, currentModule.centerpiece, 1.4);
			currentModule.showGame();
		}

		private function pauseGame(event:Event = null):void {
			if (state == 1) {
				currentModule.pause();
				moduleColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);
				showPausedMenu(event);
			}
		}

		private function showPausedMenu(event:Event = null):void {
			soundManager.stopChannel(1);
			state = 4;
			if (event && event.type == GUIEvent.SUSPEND && GUIEvent(event).suspendImmediately) {
				hexSlider.show(pausedMenu, null, 0);
			} else {
				hexSlider.show(pausedMenu, null, 1.4);
			}
		}

		private function showScoreInput(event:Event = null):void {
			soundManager.stopChannel(1);
			scoreInput.prep();
			state = 6;
			hexSlider.show(scoreInput, null, 1.4);
		}

		private function adjustSize(event:Event = null):void {
			backdrop.rerez(guiManager.sizeRatio);
			prompt.rerez(guiManager.sizeRatio);
			redrawMask(backdrop.width, backdrop.height);
			moduleManager.adjustSizes(guiManager.sizeRatio);
		}

		private function redrawMask(w:Number, h:Number):void {
			with (maskShape.graphics) {
				clear();
				beginFill(0x000000);
				drawRect(0, 0, w, h);
				endFill();
			}
		}
		
		private function makeWindowWidget():GUIWindowWidget {
			var returnVal:GUIWindowWidget;
			if (isAIR()) {
				if (isMac()) {
					returnVal = new MacWindowWidget();
				} else {
					returnVal = new PeeCeeWindowWidget();
				}
			} else {
				returnVal = new PauseWidget();
			}

			return returnVal;
		}

		private function gameResponder(event:Event):void {

			// We should only respond to events from the current game

			if (event.currentTarget != currentModuleLoader.relay) {
				return;
			}

			if (event.type == ModuleEvent.PLAYER_FAIL) {
				endGame();
			} else if (event.type == ModuleEvent.PLAYER_SUCCEED) {
				if (options.blnColors) {
					cycleColor();
				}
				if (gameType == GameType.STUDIO || gameType == GameType.ARCADE) {
					// I dunno.
				}
			}
		}

		private function cycleColor(overload:int = -1, now:Boolean = false):void {

			if (overload != -1) {
				currentModuleColor = overload;
			} else {
				currentModuleColor = currentModuleColor + 1;
			}

			currentModuleColor %= GamePalette.COLOR_PALETTES.length;
			moduleColorManager.applyColors(GamePalette.COLOR_PALETTES[currentModuleColor], (now ? 0 : 1000));
		}

		private function afterHexSlider(event:Event = null):void {
			canvas.filters = [canvasFilter];
			//Mouse.show();
			switch (state) {

				case 0 :
				// main menu
				mainMenu.activate();
				break;

				case 1 :
				// game
				canvas.filters = [];
				if (!currentModule.isPlaying) {
					currentModule.start(null, gameType);
				} else if (currentModule.isPaused) {
					currentModule.resume();
				}
				//Mouse.hide();
				break;

				case 2 :
				// high score
				break;

				case 3 :
				// settings menu

				break;

				case 4 :
				// paused menu
				break;

				case 5 :
				// about box
				break;

				case 6 :
				// high score input
				break;

				case 7 :
				// whiney message
				break;

				case 8 :
				// game menu
				break;

				case 9 :
				// grid menu
				break;
				
				case 10 :
				// debug menu
				break;
			}
		}

		private function keyResponder(event:KeyboardEvent):void {

			if (hexSlider.busy) {
				return;
			}

			var keyIsDown:Boolean = (event.type == KeyboardEvent.KEY_DOWN);
			var keyVal:String = keyboardEventToString(event);
			
			if (prompt.onscreen) {
				handleMenuDefaults(keyVal);
				return;
			}
			
			switch (hexSlider.currentSubject) {

				case currentModuleLoader :
				// keyPairs is an Object in the settings.
				if (keyPairs[keyVal]) {
					currentModule.inputResponder(keyPairs[keyVal], keyIsDown);
				} else if (keyIsDown && (keyVal == "ESCAPE" || keyVal == "`")) {
					pauseGame();
				}
				break;

				case gameMenu :
				if (keyIsDown) {
					gameMenu.keyResponder(keyVal);
					handleMenuDefaults(keyVal);
				}
				break;
				
				case settingsMenu :
				if (keyIsDown && !settingsMenu.listening) {
					handleMenuDefaults(keyVal);
				}
				break;

				default :
				if (keyIsDown) {
					handleMenuDefaults(keyVal);
				}
				break;
			}
		}

		private function handleMenuDefaults(keyVal:String):void {
			if (prompt.onscreen) {
				if (prompt.defaultNo && (keyVal == "ESCAPE" || keyVal == "`")) {
					prompt.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					prompt.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				} else if (prompt.defaultYes && keyVal == "ENTER") {
					prompt.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					prompt.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				return;
			}
			
			var currentMenu:MenuBase = hexSlider.currentSubject as MenuBase;
			if (currentMenu) {
				if (currentMenu.defaultNo && (keyVal == "ESCAPE" || keyVal == "`")) {
					currentMenu.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					currentMenu.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				} else if (currentMenu.defaultYes && keyVal == "ENTER") {
					currentMenu.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					currentMenu.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}
		
		private function grabNewModules(event:GUIEvent):void {
			pauseGame();
			if (event.type == GUIEvent.INVOCATION) {
				moduleManager.testCandidates(guiManager.invocations, (state == 1), (state == 10));
			} else if (event.type == GUIEvent.FILE_DROP) {
				moduleManager.testCandidates(event.fileArray, (state == 1), (state == 10));
			}
		}
	}
}