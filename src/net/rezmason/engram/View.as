﻿package net.rezmason.engram {		// IMPORT STATEMENTS	import flash.display.BlendMode;	import flash.display.DisplayObject;	import flash.display.Shape;	import flash.display.Sprite;	import flash.display.Stage;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.geom.Point;	import flash.filters.ColorMatrixFilter;	import flash.media.Sound;	import flash.utils.Timer;		import net.rezmason.display.ColorManager;	import net.rezmason.display.ColorSprite;	import net.rezmason.display.Moment;	import net.rezmason.engram.display.*;	import net.rezmason.engram.menus.MenuBase;	import net.rezmason.engram.modules.GameType;	import net.rezmason.gui.AlertData;	import net.rezmason.gui.GUIEvent;	import net.rezmason.gui.GUIManager;	import net.rezmason.gui.GUIWindowWidget;	import net.rezmason.media.SoundManager;	import net.rezmason.net.Syphon;	import net.rezmason.utils.isAIR;	import net.rezmason.utils.isMac;	public final class View extends Sprite implements IView {				// CLASS PROPERTIES		private static const RESOURCE_URL:String = "./resources/resources.swf";		private static const READY_EVENT:Event = new Event(Event.COMPLETE);				internal static const SLIDE_FINISHED:String = "slideFinished";		private static const SLIDE_FINISHED_EVENT:Event = new Event(SLIDE_FINISHED);				[Embed(source="../../../../resources/startupdialog.swf")]		private static const StartupDialog:Class;				private static const ARCADE_BLURB:String = "These are your installed modules. Choose which ones you'd like to play.";		private static const STUDIO_BLURB:String = "Let's see what you got, Picasso. Here, make your art palette."		private static const DRILL_BLURB:String = "Practice makes perfect. Choose which module you'd like to play.";				// INSTANCE PROPERTIES		private var _state:int = 0, _lastState:int = 0;		private var backgroundIndex:int;		private var currentModuleColor:int = 0;		private var clickPoint:Point = new Point();		private var maskShape:Shape;		private var menus:Object;		private var _modulePlayground:ColorSprite = new ColorSprite;		private var centerSprite:ColorSprite = new ColorSprite;		private var errorStatic:Moment;		private var mainMenu:MenuBase;		private var gameMenu:MenuBase;		private var gridMenu:MenuBase;		private var debugMenu:MenuBase;		private var intro:MenuBase;		private var oldSettingsMenu:MenuBase;		private var settingsMenu:MenuBase;		private var aboutBox:MenuBase;		private var pausedMenu:MenuBase;		private var scoreInput:MenuBase;		private var scoreboard:MenuBase;		private var backdrop:WindowSurface;		private var moduleColorManager:ColorManager, guiColorManager:ColorManager;		private var windowButtons:GUIWindowWidget;		private var sounds:Object = {}, channels:Object = {}, loops:Object = {};		private var canvas:Canvas;		private var hexSlider:HexSlider;		private var _startup:Startup;		private var _startupDialog:DisplayObject;		private var _guiManager:GUIManager;		private var soundManager:SoundManager;		private var prompt:Prompt;		private var canvasFilter:ColorMatrixFilter = new ColorMatrixFilter([			0.5, 0.5, 0.5, 0, -0.5,			0.5, 0.5, 0.5, 0, -0.5,			0.5, 0.5, 0.5, 0, -0.5,			0, 0, 0, 1, 0,		]);		private var _controller:Controller;		private var _ready:Boolean = false;		private var crashDump:CrashDump;		private var crashDumpTimer:Timer = new Timer(5);		private var _stage:Stage;				public function View():void {			super();						if (stage) {				loadResources();			} else {				addEventListener(Event.ADDED_TO_STAGE, loadResources);			}		}				// GETTERS & SETTERS				internal function get controller():Controller {			return _controller;		}				internal function set controller(value:Controller):void {			_controller = value;		}				internal function get ready():Boolean {			return _ready;		}				internal function get busy():Boolean {			return hexSlider.busy;		}				internal function get promptOnscreen():Boolean {			return prompt.onscreen;		}				internal function get state():int {			return _state;		}				internal function get lastState():int {			return _lastState;		}				internal function get startup():Startup {			return _startup;		}				internal function get guiManager():GUIManager {			return _guiManager;		}				internal function get modulePlayground():ColorSprite {			return _modulePlayground		}				// PUBLIC METHODS				public function alertUser(event:Event, alert:AlertData, type:AlertType = null, nearClick:Boolean = false):void {			grabMousePoint();			prompt.alertType = type || AlertType.PROBLEM;			prompt.show(alert, (nearClick ? clickPoint : null));		}				public function zap(event:Event = null):void {			errorStatic.play();			soundManager.play("errorSound");		}				public function revealDebugButton(event:Event = null):void {			soundManager.stopChannel(1);			gameMenu.prepare(true);		}				public function showCrashDump(event:Event = null):void {				vibrateCrashDump();			addChild(crashDump);			crashDump.width = _stage.stageWidth;			crashDump.scaleY = crashDump.scaleX;			crashDumpTimer.addEventListener(TimerEvent.TIMER, vibrateCrashDump);			crashDumpTimer.start();			soundManager.play("panicSound", 0.4);			soundManager.play("badDiskSound");		}				// INTERNAL METHODS				internal function setupMenus():void {			//_stage.addEventListener(MouseEvent.CLICK, grabMousePoint);			removeChild(_startup);			centerSprite.removeChild(_startupDialog);			addChild(centerSprite);			addChild(prompt);			centerSprite.addChild(canvas);			centerSprite.addChild(hexSlider);			prompt.addEventListener(Prompt.ONSCREEN, refuseMouse);			prompt.addEventListener(Prompt.OFFSCREEN, allowMouse);			hexSlider.addEventListener(Event.COMPLETE, afterHexSlider);						// get window and pause controls			windowButtons = makeWindowWidget();			_guiManager.registerWindowWidget(windowButtons);			windowButtons.offset = 12;			addChild(windowButtons);			windowButtons.addEventListener(GUIEvent.INTERRUPT, ditto);			_guiManager.addEventListener(GUIEvent.INTERRUPT, ditto);			_guiManager.addEventListener(GUIEvent.REREZ, adjustSize);			//windowButtons.addEventListener(GUIEvent.CLOSE_WINDOW, function(event:Event):void{});			centerSprite.addColorChild(windowButtons);						moduleColorManager.applyColors(GamePalette.MENU_PALETTES[0], 0);			guiColorManager.applyColors(GamePalette.MENU_PALETTES[0], 0);		}				internal function adjustSize(event:Event = null):void {			backdrop.rerez(_guiManager.sizeRatio);			prompt.rerez(_guiManager.sizeRatio);			redrawMask(backdrop.width, backdrop.height);		}				internal function pickGame(type:String = null):String {						var returnVal:String;						switch (type) {				default :				case GameType.ARCADE :					backgroundIndex = 2;					returnVal = ARCADE_BLURB;				break;				case GameType.DRILL :					backgroundIndex = 1;					returnVal = STUDIO_BLURB;				break;				case GameType.STUDIO :					backgroundIndex = 3;					returnVal = DRILL_BLURB;				break;				case GameType.FUMIGATE :					backgroundIndex = 1; // for now				break;			}						guiColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);// for now			cycleColor(0);						return returnVal;		}				internal function interpretKey(keyVal:String, keyIsDown:Boolean = false):void {			if (hexSlider.busy) {				return;			}			if (prompt.onscreen) {				handleMenuDefaults(keyVal);			} else {				switch (hexSlider.currentSubject) {					case gameMenu :					if (keyIsDown) {						gameMenu.keyResponder(keyVal);						handleMenuDefaults(keyVal);					}					break;										case oldSettingsMenu :					if (keyIsDown && !oldSettingsMenu.listening) {						handleMenuDefaults(keyVal);					}					break;										case settingsMenu :					if (keyIsDown && !settingsMenu.listening) {						handleMenuDefaults(keyVal);					}					break;										case scoreInput :					if (keyIsDown && !scoreInput.listening) {						handleMenuDefaults(keyVal);					}					break;					default :					if (keyIsDown) {						handleMenuDefaults(keyVal);					}					break;				}			}		}				internal function show(viewType:int, instantly:Boolean = false, ...args):void {			_lastState = _state;			_state = viewType;						var speed:Number = (instantly ? 0 : 1.4);						soundManager.stopChannel(1);						switch (_state) {				case ViewStates.MAIN_MENU:					hexSlider.show(mainMenu, null, speed);					guiColorManager.applyColors(GamePalette.MENU_PALETTES[0]);					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[0]);				break;				case ViewStates.GAME_MENU:					hexSlider.show(gameMenu, null, speed);				break;				case ViewStates.GRID_MENU:					gridMenu.prepare.apply(gridMenu, args);					hexSlider.show(gridMenu, null, speed);				break;				case ViewStates.DEBUG_MENU:					guiColorManager.applyColors(GamePalette.MENU_PALETTES[6]);					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[6]);					hexSlider.show(debugMenu, null, speed);				break;				case ViewStates.SETTINGS_MENU:					guiColorManager.applyColors(GamePalette.MENU_PALETTES[7]);					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[7]);					settingsMenu.prepare();					hexSlider.show(settingsMenu, null, speed);				break;				case ViewStates.OLD_SETTINGS_MENU:					//guiColorManager.applyColors(GamePalette.MENU_PALETTES[7]);					//moduleColorManager.applyColors(GamePalette.MENU_PALETTES[7]);					//hexSlider.show(oldSettingsMenu, null, speed);				break;				case ViewStates.ABOUT_BOX:					soundManager.play("aboutSound");					guiColorManager.applyColors(GamePalette.MENU_PALETTES[5]);					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[5]);					hexSlider.show(aboutBox, null, speed);				break;				case ViewStates.SCOREBOARD:					soundManager.play("scoresSound");					guiColorManager.applyColors(GamePalette.MENU_PALETTES[4]);					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[4]);					scoreboard.prepare.apply(scoreboard, args);					hexSlider.show(scoreboard, null, speed);				break;				case ViewStates.EXHIBITION_INTRO:					soundManager.play("harumphSound");					hexSlider.show(intro, null, speed);					guiColorManager.applyColors(GamePalette.MENU_PALETTES[6]);					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[6]);				break;				case ViewStates.GAME:					soundManager.stopChannel(1);					_state = ViewStates.GAME;					canvas.filters = [];					hexSlider.show(args[0], args[0].module.centerpiece, speed);					if (args[1]) {						cycleColor(currentModuleColor);						}				break;				case ViewStates.PAUSED_MENU:					guiColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);					hexSlider.show(pausedMenu, null, speed);				break;				case ViewStates.SCORE_INPUT:					moduleColorManager.applyColors(GamePalette.MENU_PALETTES[backgroundIndex]);					scoreInput.prepare();					hexSlider.show(scoreInput, null, speed);				break;			}		}				internal function cycleColor(overload:int = -1, now:Boolean = false):void {						if (overload != -1) {				currentModuleColor = overload;			} else {				currentModuleColor = currentModuleColor + 1;			}						currentModuleColor %= GamePalette.COLOR_PALETTES.length;			moduleColorManager.applyColors(GamePalette.COLOR_PALETTES[currentModuleColor], (now ? 0 : 1000));		}				// PRIVATE & PROTECTED METHODS				private function loadResources(event:Event = null):void {			removeEventListener(Event.ADDED_TO_STAGE, loadResources);						mouseEnabled = false;						_stage = stage;			_stage.scaleMode = StageScaleMode.SHOW_ALL;			_stage.tabChildren = _stage.stageFocusRect = false;			_stage.showDefaultContextMenu = false;			_stage.focus = _stage;			centerSprite.mouseEnabled = false;			centerSprite.x = _stage.stageWidth / 2;			centerSprite.y = _stage.stageHeight / 2;						moduleColorManager = new ColorManager(_modulePlayground);			guiColorManager = new ColorManager(centerSprite);			guiColorManager.applyColors(GamePalette.MENU_PALETTES[0], 0);						backdrop = new WindowSurface(_stage.stageWidth, _stage.stageHeight);			backdrop.cacheAsBitmap = true;			centerSprite.addColorChild(backdrop);			mask = maskShape = new Shape;			redrawMask(backdrop.width, backdrop.height);			addChild(backdrop);			addChild(centerSprite);						_startup = new Startup();			_startupDialog = new StartupDialog as DisplayObject;			addChild(_startup);			centerSprite.addChild(_startupDialog);						Syphon.addEventListener(Event.COMPLETE, assignResources);			Syphon.load(RESOURCE_URL);		}				private function assignResources(event:Event):void {			Syphon.removeEventListener(Event.COMPLETE, assignResources);						_stage.focus = _stage;			_stage.addEventListener(MouseEvent.MOUSE_UP, forceFocus);						_guiManager = GUIManager.INSTANCE;			_guiManager.stage = _stage;			soundManager = SoundManager.INSTANCE;						if (isAIR()) {				backdrop.addEventListener(MouseEvent.MOUSE_DOWN, _guiManager.moveWindow);			}						crashDump = new CrashDump();			GUIManager.disableAbstract = Scribble.scribbleOut;			GUIManager.enableAbstract = Scribble.removeScribble;			canvas = new Canvas;			canvas.mouseEnabled = canvas.mouseChildren = false;			hexSlider = new HexSlider(_stage.stageWidth * 0.75, canvas, 0.2);			canvas.filters = [canvasFilter];			canvas.blendMode = BlendMode.MULTIPLY;			menus = {				(ViewStates.MAIN_MENU):mainMenu = fetchMenu("MainMenu"),				(ViewStates.GAME_MENU):gameMenu = fetchMenu("GameMenu"),				(ViewStates.GRID_MENU):gridMenu = fetchMenu("GridMenu"),				(ViewStates.DEBUG_MENU):debugMenu = fetchMenu("DebugMenu"),				(ViewStates.EXHIBITION_INTRO):intro = fetchMenu("ExhibitionIntro"),				//(ViewStates.OLD_SETTINGS_MENU):oldSettingsMenu = fetchMenu("OldSettingsMenu"),				(ViewStates.SETTINGS_MENU):settingsMenu = fetchMenu("SettingsMenu"),				(ViewStates.ABOUT_BOX):aboutBox = fetchMenu("AboutBox"),				(ViewStates.PAUSED_MENU):pausedMenu = fetchMenu("PausedMenu"),				(ViewStates.SCORE_INPUT):scoreInput = fetchMenu("ScoreInput"),				(ViewStates.SCOREBOARD):scoreboard = fetchMenu("Scoreboard")			};						for (var prop:String in menus) {				centerSprite.addColorChild(menus[prop]);			}			sounds.buttonSound = fetchSound("ButtonSound");			sounds.typeSound = fetchSound("TypeSound");			sounds.settingSound = fetchSound("SettingSound");			sounds.mispressSound = fetchSound("MispressSound");			sounds.entrySound = fetchSound("EntrySound");			sounds.errorSound = fetchSound("ErrorSound");			sounds.scoresSound = fetchSound("ScoresSound"), channels.scoresSound = 1;			sounds.harumphSound = fetchSound("HarumphSound"), channels.harumphSound = 1;			sounds.promptSound = fetchSound("PromptSound"), channels.promptSound = 1;			sounds.aboutSound = fetchSound("AboutSound"), channels.aboutSound = 1;			sounds.peelSound = fetchSound("PeelSound"), channels.peelSound = 2;			sounds.stickerSound = fetchSound("StickerSound"), channels.stickerSound = 2;						sounds.panicSound = fetchSound("PanicSound");			sounds.badDiskSound = fetchSound("BadDiskSound");						loops.panicSound = ["panicSound"];			loops.badDiskSound = ["badDiskSound"];						soundManager.enlistSounds(sounds, channels, loops);			errorStatic = new (Syphon.getClass("ErrorStatic")) as Moment;			errorStatic.blendMode = BlendMode.MULTIPLY;			errorStatic.width = _stage.stageWidth;			errorStatic.scaleY = errorStatic.scaleX;			prompt = new Prompt(_stage);			addChild(errorStatic);						_ready = true;			dispatchEvent(READY_EVENT);		}				private function redrawMask(w:Number, h:Number):void {			with (maskShape.graphics) {				clear();				beginFill(0x000000);				drawRect(0, 0, w, h);				endFill();			}		}				private function makeWindowWidget():GUIWindowWidget {			var returnVal:GUIWindowWidget;			if (isAIR()) {				if (isMac()) {					returnVal = new (Syphon.getClass("MacWindowWidget")) as GUIWindowWidget;				} else {					returnVal = new (Syphon.getClass("PeeCeeWindowWidget")) as GUIWindowWidget;				}			} else {				returnVal = new (Syphon.getClass("PauseWidget")) as GUIWindowWidget;			}			return returnVal;		}				private function handleMenuDefaults(keyVal:String):void {			if (prompt.onscreen) {				if (prompt.defaultNo && (keyVal == "ESCAPE" || keyVal == "`")) {					prompt.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));					prompt.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));				} else if (prompt.defaultYes && keyVal == "ENTER") {					prompt.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));					prompt.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.CLICK));				}				return;			}						var currentMenu:MenuBase = hexSlider.currentSubject as MenuBase;			if (currentMenu) {				if (currentMenu.defaultNo && (keyVal == "ESCAPE" || keyVal == "`")) {					currentMenu.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));					currentMenu.defaultNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));				} else if (currentMenu.defaultYes && keyVal == "ENTER") {					currentMenu.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));					currentMenu.defaultYes.dispatchEvent(new MouseEvent(MouseEvent.CLICK));				}			}		}				private function afterHexSlider(event:Event = null):void {			if (_state == 1) {				canvas.filters = [];			} else {				canvas.filters = [canvasFilter];			}						dispatchEvent(SLIDE_FINISHED_EVENT);		}				private function grabMousePoint(event:Event = null):void {			clickPoint.x = mouseX;			clickPoint.y = mouseY;		}				private function refuseMouse(event:Event = null):void {			centerSprite.mouseChildren = false;		}				private function allowMouse(event:Event = null):void {			centerSprite.mouseChildren = true;		}				private function killMouse(event:Event = null):void {					}				private function reviveMouse(event:Event = null):void {					}				private function forceFocus(event:Event = null):void {			_stage.focus = _stage;		}				private function fetchMenu(menuName:String):MenuBase {			return new (Syphon.getClass("net.rezmason.engram.menus." + menuName))(_controller, this) as MenuBase;		}				private function fetchSound(soundName:String):Sound {			return new (Syphon.getClass(soundName)) as Sound;		}				private function ditto(event:Event):void {			dispatchEvent(event);		}				private function vibrateCrashDump(event:Event = null):void {						crashDump.x = int(Math.random() * 3);						if (!event || Math.random() > 0.95) {				crashDump.updateText();				crashDump.y = Math.random() * (_stage.stageHeight - crashDump.height);			}		}	}}