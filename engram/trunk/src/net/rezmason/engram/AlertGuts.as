﻿package net.rezmason.engram {	import flash.display.BlendMode;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.ColorTransform;	import flash.geom.Rectangle;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;		import net.rezmason.display.ColorSprite;	import net.rezmason.gui.GUIButton;	public class AlertGuts extends ColorSprite {				// CLASS PROPERTIES		internal static const TOP_MARGIN:int = 25;		internal static const MARGIN:int = 15;		internal static const SYMBOL_MARGIN:int = 10;		internal static const TEXT_MARGIN:int = 5;		internal static const BUTTON_MARGIN:int = 5, BUTTON_GAP:int = 20;		internal static const MAX_TEXT_WIDTH:int = 400;		internal static const SYMBOL_WIDTH:Number = 80;		internal static const MAX_BUTTONS:int = 3;		internal static const MAX_WIDTH:int = 600;				private static const DISAPPEAR_EVENT:Event = new Event(Prompt.DISAPPEAR);		private static const WHITE_CT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0xFF, 0xFF, 0xFF, 0xFF);		private static const PLAIN_CT:ColorTransform = new ColorTransform();				// INSTANCE PROPERTIES				private var _whiteText:Boolean = false;		private var _symbolContainer:Sprite = new Sprite;		private var _buttons:Array = [], _functions:Array = [];		private var leftButtonContainer:Sprite = new Sprite, rightButtonContainer:Sprite = new Sprite;		private var currentButton:GUIButton;		private var _defaultNegative:GUIButton, _defaultAffirmative:GUIButton;		// CONSTRUCTOR		public function AlertGuts():void {			addChild(_symbolContainer);			addChild(leftButtonContainer);			addChild(rightButtonContainer);						txtTitle.autoSize = TextFieldAutoSize.LEFT;			txtMessage.autoSize = TextFieldAutoSize.LEFT;			txtMessage.wordWrap = true;						//_symbolContainer.blendMode = BlendMode.DARKEN;		}				// GETTERS & SETTERS				public function get defaultAffirmative():GUIButton {			return _defaultAffirmative;		}				public function get defaultNegative():GUIButton {			return _defaultNegative;		}				internal function get symbol():DisplayObject {			return _symbolContainer.getChildAt(0);		}				internal function set symbol(value:DisplayObject):void {						while (_symbolContainer.numChildren) {				_symbolContainer.removeChildAt(0);			}						_symbolContainer.addChild(value);						sizeSymbolContainer();		}				internal function get whiteText():Boolean {			return _whiteText;		}				internal function set whiteText(value:Boolean):void {						var format:TextFormat;						if (_whiteText != value) {				_whiteText = value;								format = txtTitle.defaultTextFormat;				format.color = (_whiteText ? 0xFFFFFF : 0x000000);				txtTitle.defaultTextFormat = format;								format = txtMessage.defaultTextFormat;				format.color = (_whiteText ? 0xFFFFFF : 0x000000);				txtMessage.defaultTextFormat = format;								//_symbolContainer.blendMode = (_whiteText ? BlendMode.NORMAL : BlendMode.DARKEN);				leftButtonContainer.transform.colorTransform = (_whiteText ? WHITE_CT : PLAIN_CT);				rightButtonContainer.transform.colorTransform = (_whiteText ? WHITE_CT : PLAIN_CT);			}		}				// INTERNAL METHODS		internal function show(title:String = "", message:String = "", leftButtons:Array = null, rightButtons:Array = null,								defaultAffirmative:String = null, defaultNegative:String = null):void {						txtTitle.wordWrap = false;			txtTitle.text = title.substr(0, 60);			if (txtTitle.width > MAX_TEXT_WIDTH) {				txtTitle.wordWrap = true;				txtTitle.width = MAX_TEXT_WIDTH;			}						txtMessage.width = txtTitle.width;			txtMessage.text = message.substr(0, 300);						_symbolContainer.x = MARGIN;			_symbolContainer.y = TOP_MARGIN + MARGIN;						txtTitle.x = txtMessage.x = _symbolContainer.x + SYMBOL_WIDTH + SYMBOL_MARGIN;			txtTitle.y = TOP_MARGIN + MARGIN;			txtMessage.y = txtTitle.y + txtTitle.height + TEXT_MARGIN;						while (rightButtonContainer.numChildren) {				rightButtonContainer.removeChildAt(0);			}						while (leftButtonContainer.numChildren) {				leftButtonContainer.removeChildAt(0);			}						_functions = [];						var buttonLeft:Number = 0, buttonRight:Number = 0;			var ike:int = 0, jen:int = 0;						if (leftButtons) {				for (ike = 0; ike < leftButtons.length; ike++) {					if (!_buttons[ike]) {						addColorChild(_buttons[ike] = new AlertButton());						_buttons[ike].addEventListener(MouseEvent.CLICK, clickResponder);					}					currentButton = _buttons[ike];					_functions[ike] = leftButtons[ike].func;										currentButton.textAlign = TextFormatAlign.LEFT;					currentButton.text = leftButtons[ike].name;					if (defaultAffirmative && currentButton.text == defaultAffirmative) {						_defaultAffirmative = currentButton;					} else if (defaultNegative && currentButton.text == defaultNegative) {						_defaultNegative = currentButton;					}									leftButtonContainer.addChild(currentButton);					currentButton.x = buttonLeft;					buttonLeft += currentButton.width + BUTTON_MARGIN;				}			}						if (rightButtons) {				for (jen = 0; jen < rightButtons.length; jen++) {					if (!_buttons[ike + jen]) {						addColorChild(_buttons[ike + jen] = new AlertButton());						_buttons[ike + jen].addEventListener(MouseEvent.CLICK, clickResponder);					}					currentButton = _buttons[ike + jen];					_functions[ike + jen] = rightButtons[jen].func;									currentButton.textAlign = TextFormatAlign.RIGHT;					currentButton.text = rightButtons[jen].name;					if (defaultAffirmative && currentButton.text == defaultAffirmative) {						_defaultAffirmative = currentButton;					} else if (defaultNegative && currentButton.text == defaultNegative) {						_defaultNegative = currentButton;					}									rightButtonContainer.addChild(currentButton);					currentButton.x = buttonRight - currentButton.width;					buttonRight -= currentButton.width + BUTTON_MARGIN;				}								leftButtonContainer.x = _symbolContainer.x;				rightButtonContainer.x = Math.max(txtMessage.x + txtMessage.width, buttonLeft + BUTTON_GAP - buttonRight);				rightButtonContainer.x = Math.min(rightButtonContainer.x, MAX_WIDTH);								txtTitle.width = width - txtTitle.x;				trace("before", txtMessage.width);				txtMessage.width = width - txtMessage.x;				trace("after", txtMessage.width);				txtTitle.text = title;				txtMessage.text = message;								var buttonY:Number = Math.max(txtMessage.y + txtMessage.height + TEXT_MARGIN, _symbolContainer.y + SYMBOL_WIDTH + SYMBOL_MARGIN);				leftButtonContainer.y = rightButtonContainer.y = buttonY;			}		}				// PRIVATE & PROTECTED METHODS				private function sizeSymbolContainer():void {						if (_symbolContainer.width > _symbolContainer.height) {				_symbolContainer.width = SYMBOL_WIDTH;				_symbolContainer.scaleY = _symbolContainer.scaleX;			} else {				_symbolContainer.height = SYMBOL_WIDTH;				_symbolContainer.scaleX = _symbolContainer.scaleY;			}						var rect:Rectangle = _symbolContainer.getBounds(_symbolContainer);						_symbolContainer.x += (SYMBOL_WIDTH - _symbolContainer.width ) / 2 - rect.x;			_symbolContainer.y += (SYMBOL_WIDTH - _symbolContainer.height) / 2 - rect.y;		}				private function clickResponder(event:MouseEvent):void {			var ike:int = 0;			var target:GUIButton = event.currentTarget as GUIButton;			_functions[_buttons.indexOf(target)]();			dispatchEvent(DISAPPEAR_EVENT);		}	}}