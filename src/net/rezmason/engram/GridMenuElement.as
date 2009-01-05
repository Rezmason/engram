package net.rezmason.engram {

	// IMPORT STATEMENTS
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	
	import net.rezmason.display.ColorSprite;

	internal class GridMenuElement extends ColorSprite {
		
		// INSTANCE PROPERTIES
		private var _content:DisplayObject;
		private var mark:GridMenuMark = new GridMenuMark;
		
		// CONSTRUCTOR
		public function GridMenuElement() {
			mark.filters = [new GlowFilter(0xFFFFFF, 1, 6, 6, 2, 1)];
			addColorChild(mark, 1);
		}
		
		// GETTERS & SETTERS
		
		internal function get content():DisplayObject {
			return _content;
		}
		
		internal function set content(value:DisplayObject):void {
			if (_content) {
				removeChild(_content);
			}
			
			_content = value;
			addChild(_content);
			if (contains(mark)) {
				addChild(mark);
			}
		}
		
		// INTERNAL METHODS
		
		internal function showMark():void {
			addChild(mark);
		}
		
		internal function hideMark():void {
			removeChild(mark);
		}
	}

}
