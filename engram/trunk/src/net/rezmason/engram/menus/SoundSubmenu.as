﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.MouseEvent;	import flash.media.SoundMixer;	import flash.media.SoundTransform;		import net.rezmason.media.SoundManager;	public final class SoundSubmenu extends Submenu {				// INSTANCE PROPERTIES		private var soundManager:SoundManager = SoundManager.INSTANCE;		private var knobSoundTransform:SoundTransform = new SoundTransform();		private var running:Boolean = false;				public function SoundSubmenu(__settingsMenu:SettingsMenu):void {			super(__settingsMenu);			knob.minPosition = -0.05;			knob.maxPosition = 0.55;			knob.addEventListener(MouseEvent.MOUSE_DOWN, beginAdjust);			knob.addEventListener(Event.COMPLETE, applySettings);			knob.addEventListener(Event.CHANGE, updateVolume);		}				// GETTERS & SETTERS				override internal function get description():String {			return "Crank the overall volume up or down with this knob here.";		}				// PUBLIC METHODS				override internal function trigger(event:Event = null):void {			running = true;		}				// PRIVATE & PROTECTED METHODS				override protected function prepare(event:Event = null):void {			var _volume:Number = _settingsMenu.options.volume;			knob.relativePosition = _volume;						_volume = knob.relativePosition;			_volume = Math.min(1, Math.max(0, _volume));			soundManager.play("ampBuzzSound", buzzVolume(_volume));			//soundManager.play("ampFuzzSound", fuzzVolume(_volume));		}				override protected function reset(event:Event = null):void {			if (running) {				running = false;				soundManager.stopLoop("ampBuzzSound");				//soundManager.stopLoop("ampFuzzSound");			}		}				private function beginAdjust(event:Event):void {			knobSoundTransform.volume = 1;			SoundMixer.soundTransform = knobSoundTransform;			//soundManager.setLoopVolume("ampFuzzSound", fuzzVolume(_settingsMenu.options.volume));			soundManager.setLoopVolume("ampBuzzSound", buzzVolume(_settingsMenu.options.volume));		}				private function updateVolume(event:Event = null):void {			var _volume:Number = knob.relativePosition;			_volume = Math.min(1, Math.max(0, _volume));			_settingsMenu.options.volume = _volume;			//soundManager.setLoopVolume("ampFuzzSound", fuzzVolume(_volume));			soundManager.setLoopVolume("ampBuzzSound", buzzVolume(_volume));		}				private function applySettings(event:Event):void {			updateVolume();			knobSoundTransform.volume = _settingsMenu.options.volume;			SoundMixer.soundTransform = knobSoundTransform;			//soundManager.setLoopVolume("ampFuzzSound", fuzzVolume(1));			soundManager.setLoopVolume("ampBuzzSound", buzzVolume(1));			_settingsMenu.applySettings();		}				private function fuzzVolume(input:Number):Number {			return input * 0.5;		}				private function buzzVolume(input:Number):Number {			//return Math.max(0, (input - 0.8) * 3);			return input * 0.5;		}	}}