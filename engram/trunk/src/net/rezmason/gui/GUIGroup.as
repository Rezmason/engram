package net.rezmason.gui {
	
	// IMPORT STATEMENTS

	public class GUIGroup extends GUIAbstract {
		
		// CLASS PROPERTIES
		
		// INSTANCE PROPERTIES
		protected var _defaultRadioButton:GUIRadioButton;
		protected var _litRadioButton:GUIRadioButton;
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
		
		public function get defaultRadioButton():GUIRadioButton {
			return _defaultRadioButton;
		}
		
		public function set defaultRadioButton(value:GUIRadioButton):void {
			addGUIAbstract(value);
			_defaultRadioButton = value;
			if (_litRadioButton) {
				_litRadioButton.lit = false;
			}
			_litRadioButton = _defaultRadioButton;
			_defaultRadioButton.lit = true;
		}
		
		// PUBLIC METHODS
		
		public function addGUIAbstract(child:GUIAbstract):void {
			if (_guiChildren.indexOf(child) == -1) {
				_guiChildren.push(child);
				
				if (child is GUIRadioButton) {
					_radioChildren.push(child);
					(child as GUIRadioButton).lit = false;
					child.addEventListener(GUIEvent.RADIO_PUSH, changeChosenRadio);
				}
			}
		}
		
		public function removeGUIAbstract(child:GUIAbstract):void {
			var index:int = _guiChildren.indexOf(child);
			
			if (index != -1) {
				_colorChildren.splice(index, 1);
				
				if (child is GUIRadioButton) {
					if (child is _litRadioButton) {
						_defaultRadioButton.lit = true;
						_litRadioButton.lit = false;
						if (_defaultRadioButton == _litRadioButton) {
							_defaultRadioButton = null;
						}
						_litRadioButton = _defaultRadioButton;
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
			var radioChild:GUIRadioButton = event.currentTarget as GUIRadioButton;
			if (_litRadioButton) {
				_litRadioButton.lit = false;
			}
			_litRadioButton = radioChild;
			_litRadioButton.lit = true;
		}
	}
}

