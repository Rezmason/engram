package net.rezmason.engram.games.tetris {
	
	// IMPORT STATEMENTS
	import flash.geom.Point;
	
	internal final class Pieces {
		
		// CLASS PROPERTIES
		private static const A:Point = new Point(0, 0);
		private static const B:Point = new Point(0, 1);
		private static const C:Point = new Point(0, 2);
		private static const D:Point = new Point(0, 3); // not used
		
		private static const E:Point = new Point(1, 0);
		private static const F:Point = new Point(1, 1);
		private static const G:Point = new Point(1, 2);
		private static const H:Point = new Point(1, 3);
		
		private static const I:Point = new Point(2, 0);
		private static const J:Point = new Point(2, 1);
		private static const K:Point = new Point(2, 2);
		private static const L:Point = new Point(2, 3);
		
		private static const M:Point = new Point(3, 0); // not used
		private static const N:Point = new Point(3, 1);
		private static const O:Point = new Point(3, 2);
		private static const P:Point = new Point(3, 3); // not used

		private static const p0:Array = [ [ B, F, J, N, ], [ I, J, K, L, ], [ C, G, K, O, ], [ E, F, G, H, ], ];
		private static const p1:Array = [ [ I, B, F, J, ], [ E, F, G, K, ], [ B, F, J, C, ], [ A, E, F, G, ], ];
		private static const p2:Array = [ [ A, B, F, J, ], [ E, I, F, G, ], [ B, F, J, K, ], [ E, F, C, G, ], ];
		private static const p3:Array = [ [ E, B, F, J, ], [ E, F, J, G, ], [ B, F, J, G, ], [ E, B, F, G, ], ];
		private static const p4:Array = [ [ E, I, B, F, ], [ E, F, J, K, ], [ F, J, C, G, ], [ A, B, F, G, ], ];
		private static const p5:Array = [ [ A, E, F, J, ], [ I, F, J, G, ], [ B, F, G, K, ], [ E, B, F, C, ], ];
		private static const OO:Array =   [ E, I, F, J, ];
		private static const p6:Array =   [ OO,OO,OO,OO ];// O
		
		internal static const PIECES:Array = [p0, p1, p2, p3, p4, p5, p6];

	}
}
