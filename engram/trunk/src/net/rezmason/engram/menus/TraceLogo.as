﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;		public final class TraceLogo extends MovieClip {				// INSTANCE PROPERTIES		private var targets:Array;		private var target:Sprite, nextTarget:Sprite;		private var itr:int;						public function TraceLogo():void {						stop();						targets = [target1, target2, targetX, target3, targetX, target4, target5];						var ike:int = 0;						for (ike = 0; ike < numChildren; ike += 1) {				getChildAt(ike).addEventListener(MouseEvent.MOUSE_OVER, follow);			}						totalTarget.addEventListener(MouseEvent.MOUSE_OUT, reset);						reset();		}				// PRIVATE & PROTECTED METHODS				private function follow(event:MouseEvent):void {			if (event.currentTarget == nextTarget) {				itr += 1;				target = nextTarget;				nextTarget = targets[itr];				if (!nextTarget) {					dispatchEvent(new Event(Event.COMPLETE));					gotoAndPlay("glowing");				}			} else if (event.currentTarget != target) {				reset();			}		}				private function reset(event:MouseEvent = null):void {			itr = 1;			target = targets[0];			nextTarget = targets[1];		}			}	}