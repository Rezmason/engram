package net.rezmason.engram {
	
	// IMPORT STATEMENTS
	import flash.events.Event;
	
	public interface IController {
		
		function showMainMenu(event:Event = null):void;
		function showGameMenu(event:Event = null):void;
		function pickGame(type:String = null):void;
		function showGridMenu(allowMultipleSelections:Boolean = true, blurb:String = null):void;
		function showDebugMenu(event:Event = null):void;
		function showSettings(event:Event = null):void;
		function showAboutBox(event:Event = null):void;
		function showScoreboard(event:Event = null):void;
		function showLast(event:Event = null):void;
		function startGame(mix:Array):void;
		function endGame(event:Event = null):void;
		function resumeGame(event:Event = null):void;
		function addScore(event:Event = null, playerName:String = null):void;
		function interpretSettings(event:Event = null):void;
		function resetSystem(event:Event):void;
	}
}

