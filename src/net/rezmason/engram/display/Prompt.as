﻿package net.rezmason.engram.display {		import flash.display.DisplayObject;	import flash.display.Shape;	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.Event;	import flash.geom.Point;	import flash.geom.Rectangle;		import com.robertpenner.easing.Linear;	import gs.TweenLite;		import net.rezmason.display.ColorSprite;	import net.rezmason.engram.display.AlertType;	import net.rezmason.gui.AlertData;	import net.rezmason.gui.AlertGuts;	import net.rezmason.gui.GUIButton;	import net.rezmason.display.Peeler;	import net.rezmason.media.SoundManager;	import net.rezmason.net.Syphon;	public final class Prompt extends ColorSprite {				// CLASS PROPERTIES		public static const OFFSCREEN:String = "offScreen";		public static const ONSCREEN:String = "onscreen";		private static const OFFSCREEN_EVENT:Event = new Event(OFFSCREEN);		private static const ONSCREEN_EVENT:Event = new Event(ONSCREEN);		private static const MARGIN:int = 50, CENTER_MARGIN:int = 100;		private static const ANGLE_RANGE:Number = 15;				// INSTANCE PROPERTIES						private var alertBox:AlertGuts;		private var alertSurface:PromptSurface;		private var _alertType:AlertType;		private var _palette:Array;				private var _stage:Stage;		private var peeler:Peeler;		private var sticker:Sprite = new Sprite;		private var stickerBack:Shape = new Shape;		private var sill1:Shape = new Shape, sill2:Shape = new Shape;		private var bounds:Rectangle;				private var timing:Number = 1;		private var tweenVars:Object = {ease:Linear.easeNone};		private var peelOrigin:Point = new Point, peelOriginLocal:Point;		private var peelDestination:Point = new Point, peelDestinationLocal:Point;				private var _disappearing:Boolean = false;		private var _onscreen:Boolean = false;		private var soundManager:SoundManager = SoundManager.INSTANCE;						public function Prompt(stg:Stage):void {						_stage = stg;						alertSurface = new PromptSurface(500, 200, new (Syphon.getClass("Stripes"))(0, 0));						alertBox = new (Syphon.getClass("PromptGuts")) as AlertGuts;			with (alertBox) {				lock();				buttonClass = Syphon.getClass("AlertButton");				maxWidth = _stage.stageWidth / 2;				margin = 15;				topMargin = 25;				symbolMargin = 10;				symbolWidth = 80;				textMargin = 5;				buttonMargin = 5;				buttonGap = 100;				unlock();			}						sticker.addChild(alertSurface);			sticker.addChild(alertBox);			addColorChild(alertSurface);			addColorChild(alertBox);						addChild(sticker);						peeler = new Peeler(sticker, stickerBack, sill1, sill2);			peeler.addEventListener(Peeler.PEELING, startPeelSound);			peeler.addEventListener(Peeler.NOT_PEELING, proceed);			peeler.shiny = false;			addChild(peeler);						alertType = AlertType.DECISION;	//AlertType.DECISION;						alertBox.addEventListener(AlertGuts.DISAPPEAR, disappear);						mouseEnabled = mouseChildren = false;		}				// GETTERS & SETTERS				public function get defaultYes():GUIButton {			return alertBox.defaultYes;		}				public function get defaultNo():GUIButton {			return alertBox.defaultNo;		}				public function get alertType():AlertType {			return _alertType;		}		public function get onscreen():Boolean {			return _onscreen;		}				public function set alertType(value:AlertType):void {			_alertType = value;			if (value.symbol is DisplayObject) {				alertBox.symbol = _alertType.symbol;			} else if (value.symbol is String) {				alertBox.symbol = new (Syphon.getClass(value.symbol)) as DisplayObject;			}			_palette = GamePalette.ALERT_PALETTES[alertType.paletteIndex].slice();			alertBox.whiteText = !isBright(_palette[0]);			setColors(_palette);			alertSurface.textureAlpha = _alertType.textureAlpha;		}				// PUBLIC METHODS				public function show(data:AlertData, prox:Point = null):void {						_disappearing = false;						alertBox.show(data);			alertBox.setColors(_palette);			alertSurface.redraw(alertBox.width + 2 * alertBox.margin, alertBox.height + 2 * alertBox.margin + alertBox.topMargin);						peeler.x = 0;			peeler.y = 0;						peeler.rotation = (Math.random() * 2 - 1) * ANGLE_RANGE;			bounds = sticker.getBounds(this);						if (prox) {				peeler.x = prox.x - bounds.x - bounds.width  / 2;				peeler.x = Math.min(peeler.x, _stage.stageWidth  - MARGIN * 2 - bounds.width  - bounds.x + MARGIN);				peeler.x = Math.max(peeler.x, -bounds.x + MARGIN);								peeler.y = prox.y - bounds.y - bounds.height / 2;				peeler.y = Math.min(peeler.y, _stage.stageHeight - MARGIN * 2 - bounds.height - bounds.y + MARGIN);				peeler.y = Math.max(peeler.y, -bounds.y + MARGIN);			} else {				peeler.x = Math.random() * (_stage.stageWidth  - CENTER_MARGIN * 2 - bounds.width ) - bounds.x + CENTER_MARGIN;				peeler.y = Math.random() * (_stage.stageHeight - CENTER_MARGIN * 2 - bounds.height) - bounds.y + CENTER_MARGIN;				}						alertSurface.makeStickerBack(stickerBack);			alertSurface.makeSillhouette(sill1);			alertSurface.makeSillhouette(sill2);						peeler.update();						setupTween();			TweenLite.from(peeler, timing, tweenVars);			_onscreen = true;			dispatchEvent(ONSCREEN_EVENT);		}				public function resize(w:int, h:int):void {			alertSurface.redraw(w, h);		}				public function rerez(ratio:Number = 1):void {			alertSurface.rerez(ratio);		}				// PRIVATE & PROTECTED METHODS				private function isBright(color:uint):Boolean {			return ((color >> 16) & 0xFF) + ((color >> 8) & 0xFF) + (color & 0xFF) > 0xE0;		}				private function disappear(event:Event = null):void {			_disappearing = true;			mouseEnabled = mouseChildren = false;			soundManager.play("buttonSound");			setupTween();			peeler.axisR += 180;			//tweenVars.axisR += 180;			TweenLite.to(peeler, timing, tweenVars);		}				private function setupTween():void {			TweenLite.killTweensOf(peeler);						if (Math.random() > 0.5) {				peelOrigin.x = (Math.random() > 0.5 ? -bounds.width  - MARGIN : _stage.stageWidth  + MARGIN) - bounds.x;				peelOrigin.y = Math.random() * (_stage.stageHeight - bounds.height) - bounds.y;			} else {					peelOrigin.x = Math.random() * (_stage.stageWidth  - bounds.width ) - bounds.x;				peelOrigin.y = (Math.random() > 0.5 ? -bounds.height - MARGIN : _stage.stageHeight + MARGIN) - bounds.y;			}						peelOriginLocal = peeler.globalToLocal(localToGlobal(peelOrigin));						peeler.axisX = peelOriginLocal.x;			peeler.axisY = peelOriginLocal.y;						peelDestination.x = _stage.stageWidth  - peelOrigin.x;			peelDestination.y = _stage.stageHeight - peelOrigin.y;						peelDestinationLocal = peeler.globalToLocal(localToGlobal(peelDestination));						tweenVars.axisX = peelDestinationLocal.x;			tweenVars.axisY = peelDestinationLocal.y;						peeler.axisR = Math.atan2(peelOrigin.y - peelDestination.y, peelOrigin.x - peelDestination.x) * 180 / Math.PI;			peeler.axisR -= peeler.rotation;						//tweenVars.axisR = peeler.axisR + Math.random() * 60;		}				private function startPeelSound(event:Event = null):void {			soundManager.stopChannel(2);			if (_disappearing) {				soundManager.play("peelSound");			} else {				soundManager.play("stickerSound");			}		}				private function proceed(event:Event = null):void {			soundManager.stopChannel(2);			if (_disappearing) {				alertBox.callFunction();				_onscreen = false;				dispatchEvent(OFFSCREEN_EVENT);			} else {				mouseEnabled = mouseChildren = true;			}		}	}}