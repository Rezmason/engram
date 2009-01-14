package net.rezmason.engram.menus {
	
	// IMPORT STATEMENTS
	
	import net.rezmason.engram.Main;
	
	import com.robertpenner.easing.Quartic;
	import gs.TweenLite;
	
	public final class DebugMenu extends MenuBase {
		
		// INSTANCE PROPERTIES
		private var _main:Main;
		private var _blurb:String = "";
		
		// CONSTRUCTOR
		public function DebugMenu(__main:Main):void {
			
			super(true, false);
			/*
			btnCancel.textAlign = TextFormatAlign.LEFT;
			btnPlay.textAlign = TextFormatAlign.RIGHT;
			updateInterface();
			
			addChild(slider);
			
			addColorChild(btnPrev);
			addColorChild(btnNext);
			addColorChild(btnPlay);
			addColorChild(btnCancel);
			
			btnPrev.addEventListener(MouseEvent.CLICK, prevGrid);
			btnNext.addEventListener(MouseEvent.CLICK, nextGrid);
			
			slider.addEventListener(Event.COMPLETE, enableArrows);
			
			btnCancel.addEventListener(MouseEvent.CLICK, __main.showLast);
			btnPlay.addEventListener(MouseEvent.CLICK, makeMix);
			
			_defaultNo = btnCancel;
			_defaultYes = btnPlay;
			*/
			_main = __main;
		}
		
		// GETTERS & SETTERS
		
		public function set blurb(value:String):void {
			_blurb = value.toUpperCase();
			txtDescription.text = _blurb;
		}
		
		// PUBLIC METHODS
		
		
		// PRIVATE METHODS
		
		
		private function showDescription(event:Event):void {
			
			txtDescription.text = loaders[getTargetIndex(event)].moduleDescription;
			event.currentTarget.filters = [glow];
		}
		
		private function hideDescription(event:Event):void {
			txtDescription.text = _blurb;
			event.currentTarget.filters = [];
		}
		
		private function updateInterface():void {
			/*
			btnCancel.text = "BACK";
			btnPlay.text = "LET'S GO"; // might want to randomize
			
			btnPlay.visible = _allowMultipleSelections;
			
			txtDescription.text = _blurb;
			*/
		}
		
		private function prevGrid(event:MouseEvent):void {
			
			if (gridIndex > 0) {
				gridIndex--;
				slider.show(grids[gridIndex], gridRect, 1, Quartic.easeInOut, 180);
			}
			
			btnPrev.enabled = (gridIndex != 0);
			btnNext.enabled = (gridIndex != grids.length - 1);
			btnPrev.mouseEnabled = btnNext.mouseEnabled = false;
		}
		
		private function nextGrid(event:MouseEvent):void {
			
			if (gridIndex < grids.length - 1) {
				gridIndex += 1;
				slider.show(grids[gridIndex], gridRect, 1, Quartic.easeInOut);
			}

			btnPrev.enabled = (gridIndex != 0);
			btnNext.enabled = (gridIndex != grids.length - 1);
			btnPrev.mouseEnabled = btnNext.mouseEnabled = false;
		}
		
		private function enableArrows(event:Event):void {
			btnPrev.mouseEnabled = btnNext.mouseEnabled = true;
		}
	}
}
