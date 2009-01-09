﻿package net.rezmason.gui {		// IMPORT STATEMENTS	import flash.utils.getQualifiedClassName;		import net.rezmason.display.ColorSprite;	public class GUIAbstract extends ColorSprite {				// CLASS PROPERTIES		protected static const ENFORCER:GUIAbstractEnforcer = GUIAbstractEnforcer.INSTANCE;				// INSTANCE PROPERTIES		protected var expectedChildren:Object = {};		protected var _enabled:Boolean = true;				// CONSTRUCTOR		public function GUIAbstract(enf:Object):void {			if (enf != ENFORCER) {				throw new ArgumentError("You do not instantiate this class; it is abstract.");			}		}				// GETTERS & SETTERS				public function get enabled():Boolean {			return _enabled;		}				public function set enabled(value:Boolean):void {			_enabled = value;						mouseChildren = mouseEnabled = _enabled;						if (!_enabled) {				GUIManager.disableAbstract(this);			} else {				GUIManager.enableAbstract(this);			}		}				// PRIVATE & PROTECTED METHODS				protected function verifyChildren(obj:*):void {			var dataType:String  = getQualifiedClassName(obj);			if (expectedChildren) {				for (var prop in expectedChildren) {					if (!(getChildByName(prop) is expectedChildren[prop])) {						trace(":(", prop, "missing from", obj.name, ":", dataType);						throw new GUIError(dataType, prop, getQualifiedClassName(expectedChildren[prop]));					}				}			}		}	}}