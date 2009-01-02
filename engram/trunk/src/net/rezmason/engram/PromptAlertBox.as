package net.rezmason.engram {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import net.rezmason.display.ColorSprite;

	public class PromptAlertBox extends ColorSprite {

		private var _buttons:Array = [];
		private var _title:String = "Alert";
		private var _messsage:String = 
			"Lorem ipsum dolor sit amet, consectetur adipisicing elit, " + 
			"sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
		private var _leftButtons:Array = [], _rightButtons:Array = [];
		private var _symbolContainer:Sprite = new Sprite, _symbolWidth:Number = 0;

		// CONSTRUCTOR
		public function PromptAlertBox():void {
			addChild(_symbolContainer);
		}
		
		// GETTERS & SETTERS
		
		internal function get symbol():DisplayObject {
			return _symbolContainer.getChildAt(0);
		}
		
		internal function set symbol(value:DisplayObject):void {
			
			while (_symbolContainer.numChildren) {
				_symbolContainer.removeChildAt(0);
			}
			
			_symbolContainer.addChild(value);
			
			sizeSymbolContainer();
		}

		// INTERNAL METHODS

		internal function show(title:String = "", messsage:String = "", leftButtons:Array = null, rightButtons:Array = null):void {

		}
		
		// PRIVATE & PROTECTED METHODS
		
		private function sizeSymbolContainer():void {
			if (_symbolContainer.width > _symbolContainer.height) {
				_symbolContainer.width = _symbolWidth;
				_symbolContainer.scaleY = _symbolContainer.scaleX;
			} else {
				_symbolContainer.height = _symbolWidth;
				_symbolContainer.scaleX = _symbolContainer.scaleY;
			}
		}
	}

}

