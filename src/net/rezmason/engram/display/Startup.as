﻿package net.rezmason.engram.display {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.events.Event;		import net.rezmason.display.Grid;	import net.rezmason.display.GridFill;		public final class Startup extends Grid {				// CLASS PROPERTIES		private static const ICON_WIDTH:int = 64, BORDER:int = 12;						public function Startup():void {						super();			cellWidth = ICON_WIDTH;			spacing = 4;			fill = [GridFill.LEFT_TO_RIGHT, GridFill.BOTTOM_TO_TOP];						mouseEnabled = mouseChildren = false;			addEventListener(Event.ADDED_TO_STAGE, placeDialog);		}				// PRIVATE & PROTECTED METHODS				override protected function addCell(dObj:DisplayObject):void {			super.addCell(dObj);		}				private function placeDialog(event:Event):void {			var sWidth:int, sHeight:int;						sWidth = stage.stageWidth;			sHeight = stage.stageHeight;			maxWidth = sWidth - 2 * BORDER;			maxHeight = sHeight - 2 * BORDER;			x = BORDER;			y = BORDER;			removeEventListener(Event.ADDED_TO_STAGE, placeDialog);					}	}}