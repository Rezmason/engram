﻿package net.rezmason.engram {		// IMPORT STATEMENTS	import flash.display.Stage;	import flash.events.Event;		import net.rezmason.engram.display.AlertType;	import net.rezmason.gui.AlertData;		public interface IView {				function alertUser(event:Event, alert:AlertData, type:AlertType = null, nearClick:Boolean = false):void;		function zap(event:Event = null):void;		function revealDebugButton(event:Event = null):void;		function get stage():Stage;			}}