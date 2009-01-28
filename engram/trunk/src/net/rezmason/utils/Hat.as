package net.rezmason.utils {
	
	// IMPORT STATEMENTS
	import de.polygonal.math.PM_PRNG;
	
	/**
	*	Utility for drawing and discarding random, 
	*	potentially seeded numbers from a set.
	*	
	*	@author Jeremy Sachs
	*	@langversion	ActionScript 3.0
	*	@playerversion	Flash 9
	*	@tiptext
	*/
	public class Hat {
		
		// INSTANCE PROPERTIES
		private var contents:Array;
		private var pmRandomizer:PM_PRNG = new PM_PRNG;
		private var _seed:Number;
		private var _size:int;
		
		/**
		*	Creates a new Hat instance.
		*	
		*	@param	size	The number of unique elements in the Hat.
		*/
		public function Hat(size:int = 10):void {
			reset(size);
		}
		
		// GETTERS & SETTERS
		
		/**
		*	The value used to initialize the random numbers
		*	driving the Hat.
		*
		*/
		public function get seed():Number {
			return _seed;
		}
		
		// PUBLIC METHODS
		
		/**
		*	Reinitializes the Hat, resizing and refilling it.
		*
		*	@param	size	The number of unique elements in the Hat.
		*	@param	seed	The value used to initialize the random numbers
		*	driving the Hat. 
		*/
		public function reset(size:int = 10, seed:Number = 0):void {
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
		
		/**
		*	Selects and discards one element from the Hat.
		*	<p>If the Hat is empty, it is automatically refilled.</p>
		*
		*	@return	 The unique element picked from that Hat.
		*/
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
