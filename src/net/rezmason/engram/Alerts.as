﻿package net.rezmason.engram {	// IMPORT STATEMENTS	import net.rezmason.gui.AlertData;	public final class Alerts {				// CLASS CONSTANTS		public static const TEST:AlertData = new AlertData(			"This is an error. You did something that was wrong.", 			"This is a test of the emergency broadcast system.", 			[{name:"WOOT", func:function():void {trace("!!");}}], 			[{name:"DANG", func:function():void {trace("!");}}], 			"WOOT", "DANG"		);				public static const SPAM:AlertData = new AlertData(			"L:SDKFJSD:LFKJL:SDKFJSD:LFKJL:SDKFJSD:LFKJL:SDKFJSD:LFKJL:SDKFJSD:LFKJL:SDKFJSD:LFKJL:SDKFJSD:LFKJL:SDKFJSD:LFKJL:SDKFJSD:LFKJ", 			"This is a test of the emergency broadcast system. This is a test of the emergency broadcast system. This is a test of the emergency broadcast system. This is a test of the emergency broadcast system. This is a test of the emergency broadcast system.", 			[{name:"1"}, {name:"2"}, {name:"3"}, {name:"4"},], 			//[{name:"1"}, {name:"2"}, {name:"3"}, {name:"4"},]			[{name:"11111111"}, {name:"2222"}, {name:"3"}, {name:"444444444"},]		);				public static const NO_MODULES:AlertData = new AlertData(			"JUST A SECOND, BUDDY.", 			"I don't know how you did it, but you started Engram with no modules. Obviously, you can't play Engram without modules. " + 			"So go undo whatever the fuck you did to make this happen, and then maybe I'll let you play.", 			null, [{name:"SORRY"}],			"SORRY", "SORRY"		);				public static const DELETE_MODULE:AlertData = new AlertData(			"YOU WERE TOO GOOD FOR THAT MODULE ANYWAY.",			"Maybe you clicked \"Delete\" by mistake, I'm just making sure. Also, if you'd like I can spit this module out onto your " +			"desktop instead of deleting it outright. \n\nWhat'll it be, Boss?",			[{name:"FORGET IT"}],			[{name:"DELETE IT NOW"}, {name:"SPIT IT OUT"}],			null, "FORGET IT"		);				public static const CLEAR_SCORES:AlertData = new AlertData(			"WRITTEN BY THE WINNERS. ERASED BY THE LOSERS.",			"Snide move there, wiping the high score board. But don't do something you'll later regret.",			[{name:"NEVER MIND"}],			[{name:"WIPE IT", func:undefined}],			null, "NEVER MIND"		);	}}