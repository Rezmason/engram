package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	
	import flash.display.DisplayObject;

	internal class AlertType {
		
		// CLASS PROPERTIES
		
		internal static const BUG:AlertType = new AlertType(0, new BugSymbol);
		internal static const CANNOT_UNDO:AlertType = new AlertType(2, new CannotUndoSymbol);
		internal static const DECISION:AlertType = new AlertType(2, new DecisionSymbol);
		internal static const DEVELOPER:AlertType = new AlertType(1, new DeveloperSymbol);
		internal static const PROBLEM:AlertType = new AlertType(0, new ProblemSymbol);
		internal static const WARNING:AlertType = new AlertType(1, new WarningSymbol);
		
		// INSTANCE PROPERTIES
		
		public var symbol:DisplayObject, paletteIndex:uint;
		
		// CONSTRUCTOR
		public function AlertType(__paletteIndex:uint = 0, __symbol:DisplayObject = null):void {
			symbol = __symbol;
			paletteIndex = __paletteIndex;
		}
	}

}

