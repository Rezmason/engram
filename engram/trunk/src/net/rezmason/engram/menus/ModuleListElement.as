package net.rezmason.engram.menus {

	// IMPORT STATEMENTS
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.Font;
	
	import net.rezmason.display.ColorSprite;

	internal final class ModuleListElement extends ColorSprite {
		
		// INSTANCE PROPERTIES
		private var _content:DisplayObject;
		private var _txtLabel:TextField = new TextField();
		
		public function ModuleListElement(text:String = "untitled module") {
			_txtLabel.text = text;
			
			with (_txtLabel) {			
				var _format:TextFormat = defaultTextFormat;
				_format.size = 9;
				_format.font = "ProFont_9pt_st";
				
				blendMode = BlendMode.LAYER;
			
				autoSize = TextFieldAutoSize.CENTER;
				background = true;
				backgroundColor = 0x000000;
				border = false;
				defaultTextFormat = _format;
				embedFonts = true;
				mouseEnabled = false;
				multiline = false;
				textColor = 0xFFFFFF;
				
				type = TextFieldType.DYNAMIC;
			}
		}
		
		// GETTERS & SETTERS
		
		internal function get content():DisplayObject {
			return _content;
		}
		
		internal function set content(value:DisplayObject):void {
			if (_content && _content.parent == this) {
				removeChild(_content);
			}
			
			_content = value;
			addChild(_content);
			addChild(_txtLabel);
			_txtLabel.x = 0;
			_txtLabel.y = _content.getBounds(this).bottom;
		}
		
		internal function get text():String {
			return _txtLabel.text;
		}
		
		internal function set text(value:String):void {
			_txtLabel.text = value.substr(0, 31);
		}
	}

}

