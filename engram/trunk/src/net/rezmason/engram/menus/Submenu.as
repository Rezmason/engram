﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.geom.Rectangle;		import net.rezmason.display.ColorSprite;	public class Submenu extends ColorSprite {				// CLASS PROPERTIES		protected static const STAND_IN:Rectangle = new Rectangle(0, 0, 0, 0);						// INSTANCE PROPERTIES		protected var _settingsMenu:SettingsMenu;								public function Submenu(__settingsMenu:SettingsMenu):void {			_settingsMenu = __settingsMenu;			reset();			addEventListener(Event.ADDED_TO_STAGE, prepare);			addEventListener(Event.REMOVED_FROM_STAGE, reset);		}				// GETTERS & SETTERS				internal final function get standIn():Rectangle {			return STAND_IN.clone();		}				// INTERNAL METHODS				internal function trigger(event:Event = null):void {					}				// PRIVATE & PROTECTED METHODS				protected function prepare(event:Event = null):void {					}				protected function reset(event:Event = null):void {					}	}}