﻿package net.rezmason.engram.games.tetris {
	
	// IMPORT STATEMENTS
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public final class TetrisScore extends Sprite {
		
		
		public function TetrisScore():void {
			TextField;
			reset();
		}
		
		// INTERNAL METHODS
		
		internal function reset():void {
			setScore(0);
		}
		
		internal function setScore(i:int):void {
			var str:String = i.toString();
			while (str.length < 10) {
				str = "\n" + str;
			}
			textbox.text = str;
		}
	}
}
