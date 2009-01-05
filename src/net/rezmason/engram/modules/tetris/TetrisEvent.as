﻿package net.rezmason.engram.modules.tetris {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	
	import net.rezmason.engram.ModuleEvent;
	
	internal class TetrisEvent extends ModuleEvent {
		
		// CLASS PROPERTIES
		internal static const NEW_PIECE:String = "newPiece";
		internal static const CLEARED_LINES:String = "clearedLines";
		internal static const FREEZING:String = "freezing";
		internal static const THAWED:String = "thawed";
		internal static const HOLD:String = "hold";
		internal static const TSPIN:String = "tSpin";
		internal static const BANG:String = "bang";
		internal static const CRISIS:String = "crisis";
		internal static const CRISIS_AVERTED:String = "crisisAverted";
		internal static const CLAP_ON:String = "clapOn";
		internal static const CLAP_OFF:String = "clapOff";
		
		// INSTANCE PROPERTIES
		private var _tSpin:int = 0;
		private var _bravo:Boolean = false;
		private var _row:int = 0, _column:int = 0;
		
		// CONSTRUCTOR
		public function TetrisEvent( type:String, wrth:int = 0, ts:int = 0, bv:Boolean = false, 
		rw:int = 0, cn:int = 0, bubbles:Boolean = true, cancelable:Boolean = false ):void{
			super(type, wrth, bubbles, cancelable);
			_tSpin = ts;
			_bravo = bv;
			_row = rw;
			_column = cn;
		}
		
		// PUBLIC METHODS
		
		override public function clone() : Event {
			return new TetrisEvent(type, worth, tSpin, bravo, row, column, bubbles, cancelable);
		}
		
		// GETTERS & SETTERS
		
		internal function get tSpin() : int {
			return _tSpin;
		}
		
		internal function set tSpin(i:int):void {
			_tSpin = i;
		}
		
		internal function get bravo():Boolean {
			return _bravo;
		}
		
		internal function set bravo(b:Boolean):void {
			_bravo = b;
		}
		
		internal function get row():int {
			return _row;
		}
		
		internal function set row(i:int):void {
			_row = i;
		}
		
		internal function get column():int {
			return _column;
		}
		
		internal function set column(i:int):void {
			_column = i;
		}
	}
}