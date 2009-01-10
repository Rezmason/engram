package net.rezmason.gui {
	
	// IMPORT STATEMENTS

	public class GUIGroup extends GUIAbstract {
		
		// CLASS PROPERTIES
		
		// INSTANCE PROPERTIES
		protected var _defaultOption:GUIOption;
		protected var _chosenOption:GUIOption;
		protected var _guiChildren:Array = [], _radioChildren:Array = [];
		
		// CONSTRUCTOR
		public function GUIGroup():void {
			super(GUIAbstractEnforcer.INSTANCE);
			
			var ike:int;
			for (ike = 0; ike < _guiChildren.length; ike++) {
				addColorChild(_guiChildren[ike]);
			}
		}
		
		// GETTERS & SETTERS
		
		override public function set enabled(value:Boolean):void {
			_enabled = value;
			
			mouseEnabled = _enabled;
			
			_guiChildren.foreach(copyEnabledState, this);
		}
		
		public function get guiChildren():Array {
			return _guiChildren.slice();
		}
		
		public function get radioChildren():Array {
			return _radioChildren.slice();
		}
		
		public function get defaultOption():GUIOption {
			return _defaultOption;
		}
		
		public function set defaultOption(value:GUIOption):void {
			addGUIAbstract(value);
			_defaultOption = value;
			if (_chosenOption) {
				_chosenOption.chosen = false;
			}
			_chosenOption = _defaultOption;
			_defaultOption.chosen = true;
		}
		
		// PUBLIC METHODS
		
		public function addGUIAbstract(child:GUIAbstract):void {
			if (_guiChildren.indexOf(child) == -1) {
				_guiChildren.push(child);
				
				if (child is GUIOption) {
					_radioChildren.push(child);
					(child as GUIOption).chosen = false;
					child.addEventListener(GUIEvent.RADIO_PUSH, changeChosenRadio);
				}
			}
		}
		
		public function removeGUIAbstract(child:GUIAbstract):void {
			var index:int = _guiChildren.indexOf(child);
			
			if (index != -1) {
				_colorChildren.splice(index, 1);
				
				if (child is GUIOption) {
					if (child is _chosenOption) {
						_defaultOption.chosen = true;
						_chosenOption.chosen = false;
						if (_defaultOption == _chosenOption) {
							_defaultOption = null;
						}
						_chosenOption = _defaultOption;
					}
					child.removeEventListener(GUIEvent.RADIO_PUSH, changeChosenRadio);
					trace("radio child index:", _radioChildren.indexOf(child));
					_radioChildren.splice(_radioChildren.indexOf(child), 1);
				}
			}
		}
		
		// PRIVATE & PROTECTED METHODS
		
		private function copyEnabledState(target:GUIAbstract):void {
			target.enabled = _enabled;
		}
		
		private function changeChosenRadio(event:Event):void {
			var radioChild:GUIOption = event.currentTarget as GUIOption;
			if (_chosenOption) {
				_chosenOption.chosen = false;
			}
			_chosenOption = radioChild;
			_chosenOption.chosen = true;
		}
	}
}

