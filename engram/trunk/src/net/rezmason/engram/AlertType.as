package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	
	import flash.display.DisplayObject;

	internal class AlertType {
		
		// CLASS PROPERTIES
		
		internal static const BUG:AlertType = new AlertType(0, new BugSymbol, 1);
		internal static const CANNOT_UNDO:AlertType = new AlertType(2, new CannotUndoSymbol, 0.4);
		internal static const DECISION:AlertType = new AlertType(2, new DecisionSymbol, 0.4);
		internal static const DEVELOPER:AlertType = new AlertType(1, new DeveloperSymbol, 1);
		internal static const PROBLEM:AlertType = new AlertType(0, new ProblemSymbol, 1);
		internal static const WARNING:AlertType = new AlertType(1, new WarningSymbol, 1);
		
		// INSTANCE PROPERTIES
		
		public var symbol:DisplayObject, paletteIndex:uint;
		public var textureAlpha:Number = 0;
		
		// CONSTRUCTOR
		public function AlertType(__paletteIndex:uint = 0, __symbol:DisplayObject = null, __textureAlpha:Number = 1):void {
			symbol = __symbol;
			paletteIndex = __paletteIndex;
			textureAlpha = __textureAlpha;
		}
	}

}

