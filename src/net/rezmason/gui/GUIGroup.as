package net.rezmason.gui {
	
	// IMPORT STATEMENTS
	import flash.display.InteractiveObject;

	public class GUIGroup extends GUIAbstract {
		
		// CLASS PROPERTIES
		
		// INSTANCE PROPERTIES
		
		// CONSTRUCTOR
		public function GUIGroup():void {
			super(GUIAbstractEnforcer.INSTANCE);
			
			var ike:int;
			
			for (ike = 0; ike < numChildren; ike++) {
				if (getChildAt(ike) is InteractiveObject) {
					addColorChild(getChildAt(ike));
				}
			}
		}
		
		// GETTERS & SETTERS
		
		// PRIVATE & PROTECTED METHODS
	}
}

