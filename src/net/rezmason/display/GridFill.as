package net.rezmason.display {
	
	public class GridFill {
		
		// CLASS PROPERTIES
		public static const RIGHT_TO_LEFT:String = "rightToLeft", LEFT_TO_RIGHT:String = "leftToRight";
		public static const TOP_TO_BOTTOM:String = "topToBottom", BOTTOM_TO_TOP:String = "bottomToTop";
		
		public static function isNotAType(value:String):Boolean {
			if (value == RIGHT_TO_LEFT || value == LEFT_TO_RIGHT || value == TOP_TO_BOTTOM || value == BOTTOM_TO_TOP) {
				return false;
			}
			return true;
		}
	}	
}
