package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	
	
	public class GameType {
		
		// CLASS PROPERTIES
		public static const ARCADE:String = "arcade", DRILL:String = "drill";
		public static const STUDIO:String = "studio", FUMIGATE:String = "fumigateest";
		
		public static function isNotAType(value:String):Boolean {
			if (value == ARCADE || value == DRILL || value == STUDIO || value == FUMIGATE) {
				return false;
			}
			return true;
		}
	}	
}
