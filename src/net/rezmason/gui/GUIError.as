package net.rezmason.gui {
	
	public class GUIError extends Error {
		
		// CLASS PROPERTIES
		private static const SEG_1:String = "This ";
		private static const SEG_2:String = " class or subclass is missing a child with the instance name '";
		private static const SEG_3:String = "' of type '";
		private static const SEG_4:String = "'.";
		
		
		public function GUIError(className:String, instanceName:String, type:String):void {
			name = "GUIError";
			super(SEG_1 + className + SEG_2 + instanceName + SEG_3 + type + SEG_4);
		}
	}
}
