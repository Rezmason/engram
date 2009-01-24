﻿package net.rezmason.engram {	// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.Loader;	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.Event;	import flash.events.SecurityErrorEvent;	import flash.geom.Point;	public final class Guard extends Sprite {				// CLASS PROPERTIES		private static const BAD_ACCESS:String = "Who the hell do you think you are? Never, EVER do that again!";		private static const BAD_ACCESS_ERROR:SecurityError = new SecurityError(BAD_ACCESS);		private static const TAKE_DOWN:String = "I'm staying right where I am."		private static const TAKE_DOWN_ERROR:SecurityError = new SecurityError(TAKE_DOWN);		private static const TAKE_DOWN_EVENT:SecurityErrorEvent = new SecurityErrorEvent("maliciousHackerError", false, false, TAKE_DOWN);				public function Guard(mainObject:Sprite):void {			super.addChild(mainObject);		}				// PUBLIC METHODS				override public function get numChildren():int {			throw BAD_ACCESS_ERROR;			return null;		}				override public function addChild(child:DisplayObject):DisplayObject {			throw BAD_ACCESS_ERROR;			return null;		}		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {			throw BAD_ACCESS_ERROR;			return null;		}		override public function areInaccessibleObjectsUnderPoint(point:Point):Boolean {			throw BAD_ACCESS_ERROR;			return null;		}		override public function getChildAt(index:int):DisplayObject {			throw BAD_ACCESS_ERROR;			return null;		}		override public function getChildByName(name:String):DisplayObject {			throw BAD_ACCESS_ERROR;			return null;		}		override public function getObjectsUnderPoint(point:Point):Array {			throw BAD_ACCESS_ERROR;			return null;		}		override public function removeChildAt(index:int):DisplayObject {			throw BAD_ACCESS_ERROR;			return null;		}		override public function swapChildrenAt(index1:int, index2:int):void {			throw BAD_ACCESS_ERROR;		}				// INTERNAL METHODS				internal function dissolve(target:DisplayObject = null):void {			if (!target) {				target = super.getChildAt(0);			}						var targetContainer:DisplayObjectContainer = target as DisplayObjectContainer;						if (targetContainer) {				try {					// might change this once I migrate to Flash 10					(targetContainer as Loader).unload();				} catch (error:Error) {									}								while (targetContainer.numChildren) {					dissolve(targetContainer.getChildAt(0));				}			}						if (target.parent) {				target.parent.removeChild(target);			}		}	}}