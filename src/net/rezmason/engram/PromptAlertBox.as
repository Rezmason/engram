package net.rezmason.engram {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import net.rezmason.display.ColorSprite;
	import net.rezmason.gui.GUIButton;

	public class PromptAlertBox extends ColorSprite {
		
		// CLASS PROPERTIES
		
		internal static const MARGIN:int = 15;
		internal static const SYMBOL_MARGIN:int = 10;
		internal static const TEXT_MARGIN:int = 5;
		
		// INSTANCE PROPERTIES
		
		private var _whiteText:Boolean = false;
		private var _buttons:Array = [];
		private var _title:String = "One of the flayrods gone out o'skew on treadle";
		private var _messsage:String = 
			"Lorem ipsum dolor sit amet, consectetur adipisicing elit, " + 
			"sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
		private var _leftButtons:Array = [], _rightButtons:Array = [];
		private var _symbolContainer:Sprite = new Sprite, _symbolWidth:Number = 80;

		// CONSTRUCTOR
		public function PromptAlertBox():void {
			addChild(_symbolContainer);
			show(_title, _messsage);
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
		
		internal function get whiteText():Boolean {
			return _whiteText;
		}
		
		internal function set whiteText(value:Boolean):void {
			
			var format:TextFormat;
			
			if (_whiteText != value) {
				_whiteText = value;
				
				format = txtTitle.defaultTextFormat;
				format.color = (_whiteText ? 0xFFFFFF : 0x000000);
				txtTitle.defaultTextFormat = format;
				
				format = txtMessage.defaultTextFormat;
				format.color = (_whiteText ? 0xFFFFFF : 0x000000);
				txtMessage.defaultTextFormat = format;
			}
		}
		
		// INTERNAL METHODS

		internal function show(title:String = "", messsage:String = "", leftButtons:Array = null, rightButtons:Array = null):void {
			
			txtTitle.text = title;
			txtMessage.text = messsage;
			
			// left buttons
			// right buttons
			
			_symbolContainer.x = _symbolContainer.y = MARGIN;
			
			var textX:Number = _symbolContainer.x + _symbolWidth + SYMBOL_MARGIN;
			
			txtTitle.x = txtMessage.x = textX;
			txtTitle.y = MARGIN;
			txtMessage.y = txtTitle.y + txtTitle.height + TEXT_MARGIN;
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
			
			var rect:Rectangle = _symbolContainer.getBounds(_symbolContainer);
			
			_symbolContainer.x += (_symbolWidth - _symbolContainer.width ) / 2 - rect.x;
			_symbolContainer.y += (_symbolWidth - _symbolContainer.height) / 2 - rect.y;
		}
	}

}

