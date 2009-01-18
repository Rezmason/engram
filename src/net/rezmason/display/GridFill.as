package net.rezmason.display {
	
	/**
	* 	The GridFill class provides values for fill rules in the Grid class.
	* 
	*	@see Grid
	*	
	*	@author Jeremy Sachs
	*	@langversion	ActionScript 3.0
	*	@playerversion	Flash 9
	*	@tiptext
	*/
	public final class GridFill {
		
		// CLASS PROPERTIES
		/**
		*	Constant; adds cells to the Grid from right to left.
		*	
		*	@see Grid#fill
		*/
		public static const RIGHT_TO_LEFT:String = "rightToLeft";S
		/**
		*	Constant; adds cells to the Grid from left to right.
		*	
		*	@see Grid#fill
		*/
		public static const LEFT_TO_RIGHT:String = "leftToRight";S
		/**
		*	Constant; adds cells to the Grid from top to bottom.
		*	
		*	@see Grid#fill
		*/
		public static const TOP_TO_BOTTOM:String = "topToBottom";S
		/**
		*	Constant; adds cells to the Grid from bottom to top.
		*	
		*	@see Grid#fill
		*/
		public static const BOTTOM_TO_TOP:String = "bottomToTop";
		
		/**
		* 	Returns <code>true</code> if the value is not a valid GridFill type.
		*	
		*	@param	candidate	The <code>String</code> to evaluate.
		*	@return	If the <code>candidate</code> is not a proper GridFill type,
		*	this value is <code>true</code>, otherwise <code>false</code>.
		*
		*/
		public static function isNotAType(candidate:String):Boolean {
			if (candidate == RIGHT_TO_LEFT || candidate == LEFT_TO_RIGHT || candidate == TOP_TO_BOTTOM || candidate == BOTTOM_TO_TOP) {
				return false;
			}
			return true;
		}
	}	
}
