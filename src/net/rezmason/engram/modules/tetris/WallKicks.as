package net.rezmason.engram.modules.tetris {
	
	// IMPORT STATEMENTS
	import flash.geom.Point;
	
	internal final class WallKicks {
		
		// CLASS PROPERTIES
		
		private static const pf:Point = new Point(-2, -2);
		private static const ef:Point = new Point(-1, -2);
		private static const xf:Point = new Point( 0, -2);
		private static const af:Point = new Point( 1, -2);
		private static const qf:Point = new Point( 2, -2);
                                                          
		private static const pn:Point = new Point(-2, -1);
		private static const en:Point = new Point(-1, -1);
		private static const xn:Point = new Point( 0, -1);
		private static const an:Point = new Point( 1, -1);
		private static const qn:Point = new Point( 2, -1);
                                                          
		private static const px:Point = new Point(-2,  0);
		private static const ex:Point = new Point(-1,  0);
		private static const xx:Point = new Point( 0,  0);
		private static const ax:Point = new Point( 1,  0);
		private static const qx:Point = new Point( 2,  0);
                                                          
		private static const pu:Point = new Point(-2,  1);
		private static const eu:Point = new Point(-1,  1);
		private static const xu:Point = new Point( 0,  1);
		private static const au:Point = new Point( 1,  1);
		private static const qu:Point = new Point( 2,  1);
                                                          
		private static const pt:Point = new Point(-2,  2);
		private static const et:Point = new Point(-1,  2);
		private static const xt:Point = new Point( 0,  2);
		private static const at:Point = new Point( 1,  2);
		private static const qt:Point = new Point( 2,  2);

		private static const aa:Array = [ xx, ax, au, xf, af, ];
		private static const ab:Array = [ xx, ex, en, xt, et, ];
		private static const ac:Array = [ xx, ex, eu, xf, ef, ];
		private static const ad:Array = [ xx, ax, an, xt, at, ];
		
		internal static const SHORT_COUNTERCLOCKWISE:Array = 
															[
															aa, ab, 
															ac, ad, 
															];
															
		internal static const SHORT_CLOCKWISE:Array = 
															[ 
															ac, ab, 
															aa, ad 
															];
															
		internal static const LONG_COUNTERCLOCKWISE:Array = 
															[ 
															[ xx, qx, ex, qn, et, ], [ xx, px, ax, pn, au, ], 
															[ xx, ax, px, af, pu, ], [ xx, qx, ex, ef, qu, ], 
															];
															
		internal static const LONG_CLOCKWISE:Array =
		        											[ 
															[ xx, px, ax, pn, at, ], [ xx, px, ax, af, pu, ], 
															[ xx, ex, qx, ef, qu, ], [ xx, qx, ex, qn, eu, ], 
															];
		
	}
}