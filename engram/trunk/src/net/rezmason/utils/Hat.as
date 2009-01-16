package net.rezmason.utils {
	
	// IMPORT STATEMENTS
	import de.polygonal.math.PM_PRNG;
	
	public class Hat {
		
		// INSTANCE PROPERTIES
		private var contents:Array;
		private var pmRandomizer:PM_PRNG = new PM_PRNG;
		private var _seed:Number;
		private var _size:int;
		
		
		public function Hat(size:int = 10):void {
			reset(size);
		}
		
		// GETTERS & SETTERS
		
		public function get seed():Number {
			return _seed;
		}
		
		// PUBLIC METHODS
		
		public function reset(size:int = 0, seed:Number = 0):void {
			var ike:int;
			
			seed ||= Math.random() * 0xFFFFFFFF;

			pmRandomizer.seed = _seed = seed;
			
			if (size > 0) {
				_size = size;	
			}
			contents = new Array;
			for (ike = 0; ike < _size; ike += 1) {
				contents.push(ike);
			}
		}
		
		public function pick():int {
			var p:int = pmRandomizer.nextIntRange(0,contents.length - 1);
			var value:int = contents[p];
			
			contents.splice(p, 1);
			
			if (!contents.length) {
				contents = new Array;
				for (var ike:int = 0; ike < _size; ike += 1) {
					contents.push(ike);
				}
			}
			
			return value;
		}
	}
}
