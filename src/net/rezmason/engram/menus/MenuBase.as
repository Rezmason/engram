﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filters.GlowFilter;	import flash.geom.Rectangle;	import flash.text.StaticText;	import flash.text.TextField;	import flash.text.TextFormatAlign;		import net.rezmason.display.ColorSprite;	import net.rezmason.gui.GUIAbstract;	import net.rezmason.gui.GUIButton;	import net.rezmason.gui.GUITab;	import net.rezmason.utils.camelToCaps;	import net.rezmason.utils.HeavyEvent;		public class MenuBase extends ColorSprite {				// CLASS PROPERTIES		private static const DARK_TEXT_FILTER:GlowFilter = new GlowFilter(0x000000, 1, 5, 5, 10);				// INSTANCE PROPERTIES		private var currentButton:GUIButton;		private var currentChild:DisplayObject;		//private var buttons:Array = new Array;		protected var _defaultYes:GUIButton, _defaultNo:GUIButton;		private var scratch:int;		private var texts:Array = [];		protected var buttonMap:Object;		protected var _command:HeavyEvent = new HeavyEvent(Event.COMPLETE);				public function MenuBase(colorGUI:Boolean = true, 		alignButtons:Boolean = true, nameGUI:Boolean = true):void {						var ike:int;						for (ike = 0; ike < numChildren; ike += 1) {				currentChild = getChildAt(ike);				if (currentChild is GUIAbstract && colorGUI) {					addColorChild(currentChild);				}								if (currentChild is GUIButton && nameGUI) {					(currentChild as GUIButton).text = camelToCaps(currentChild.name.replace("btn", ""));				} else if (currentChild is GUITab && nameGUI) {					(currentChild as GUITab).text = camelToCaps(currentChild.name.replace("tb", ""));				}								if (currentChild is TextField || currentChild is StaticText) {					texts.push(currentChild);				}			}						if (alignButtons) {				addEventListener(Event.ADDED, decideOnButtonTextAlignments);			}						addSounds(this);		}				// GETTERS & SETTERS				public function get defaultYes():GUIButton {			return _defaultYes;		}				public function get listening():Boolean {			return false;		}				public function get defaultNo():GUIButton {			return _defaultNo;		}				// PUBLIC METHODS				override public function setColors(colorTransforms:Array, myIndex:int = 0):void {			super.setColors(colorTransforms, myIndex);						if (isBright(colorTransforms[0], 0x80)) {				var arr:Array = [DARK_TEXT_FILTER];			} else {				arr = [];			}						for (var ike:int = 0; ike < texts.length; ike++) {				texts[ike].filters = arr;			}		}				public function prepare(...args):void {					}				public function decideOnButtonTextAlignments(event:Event = null):void {						if (event) {				removeEventListener(Event.ADDED, decideOnButtonTextAlignments);			}						var buttons:Array = new Array;			var middleLine:Number;			var scratch:Number;			var ike:int;			middleLine = (getBounds(this).left + getBounds(this).right) / 2;						// find buttons			for (ike = 0; ike < numChildren; ike += 1) {				if (getChildAt(ike) is GUIButton) {					currentButton = getChildAt(ike) as GUIButton;										var bounds:Rectangle = currentButton.getBounds(currentButton);					bounds.x += currentButton.x;					bounds.y += currentButton.y;										if (bounds.right < middleLine - 5) {						currentButton.textAlign = TextFormatAlign.LEFT;					} else if (bounds.left > middleLine + 5) {						currentButton.textAlign = TextFormatAlign.RIGHT;					} else {						currentButton.textAlign = TextFormatAlign.CENTER;					}				}			}		}				public function keyResponder(keyVal:String):void {					}				public function rerez(ratio:Number = 1):void {					}				// PRIVATE & PROTECTED METHODS				protected function mapButtons():void {			if (!buttonMap){				return;			}						var ike:int;						for (ike = 0; ike < numChildren; ike += 1) {				currentChild = getChildAt(ike);				if (buttonMap && buttonMap[currentChild.name] != undefined) {					currentChild.addEventListener(MouseEvent.CLICK, signal);				}			}		}				protected function signal(event:Event = null, flavor:String = " "):void {						if (event) {				_command.flavor = buttonMap[event.currentTarget.name];			} else {				_command.flavor = flavor;			}						dispatchEvent(_command);		}	}}