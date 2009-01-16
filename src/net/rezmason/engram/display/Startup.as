﻿package net.rezmason.engram.display {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Rectangle;		import net.rezmason.display.Grid;	import net.rezmason.display.GridFill;		public final class Startup extends Grid {				// CLASS PROPERTIES		private static const ICON_WIDTH:int = 64, BORDER:int = 12;				// INSTANCE PROPERTIES		private var dialog:StartupDialog = new StartupDialog;						public function Startup():void {						super();			cellWidth = ICON_WIDTH;			spacing = 4;			fill = [GridFill.LEFT_TO_RIGHT, GridFill.BOTTOM_TO_TOP];						mouseEnabled = mouseChildren = false;			addEventListener(Event.ADDED_TO_STAGE, placeDialog);		}				// PRIVATE & PROTECTED METHODS				override protected function addCell(dObj:DisplayObject):void {			super.addCell(dObj);			addChild(dialog);		}				private function placeDialog(event:Event):void {			var sWidth:int, sHeight:int;						addChild(dialog);			sWidth = stage.stageWidth;			sHeight = stage.stageHeight;			maxWidth = sWidth - 2 * BORDER;			maxHeight = sHeight - 2 * BORDER;			x = BORDER;			y = BORDER;			dialog.x = sWidth * 0.5 - x;			dialog.y = sHeight * 0.4 - y;			removeEventListener(Event.ADDED_TO_STAGE, placeDialog);					}	}}