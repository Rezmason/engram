﻿package net.rezmason.engram {	// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.geom.Point;	public final class Guard extends Sprite {				// CLASS PROPERTIES		private static  const MALICIOUS_BASTARDS:String = "Who the hell do you think you are? Never, EVER do that again!";		private static  const SECURITY_ERROR:SecurityError = new SecurityError(MALICIOUS_BASTARDS);		// ISNTANCE PROPERTIES		private var mainObject:Main;				public function Guard()		{			while (super.numChildren) {				stage.addChild(super.getChildAt(0));			}			stage.addChild(this);						mainObject = new Main(super.addChild(new Sprite) as Sprite);		}				// PUBLIC METHODS				override public function get numChildren():int {			throw SECURITY_ERROR;			return null;		}				override public function addChild(child:DisplayObject):DisplayObject {			throw SECURITY_ERROR;			return null;		}		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {			throw SECURITY_ERROR;			return null;		}		override public function areInaccessibleObjectsUnderPoint(point:Point):Boolean {			throw SECURITY_ERROR;			return null;		}		override public function getChildAt(index:int):DisplayObject {			throw SECURITY_ERROR;			return null;		}		override public function getChildByName(name:String):DisplayObject {			throw SECURITY_ERROR;			return null;		}		override public function getObjectsUnderPoint(point:Point):Array {			throw SECURITY_ERROR;			return null;		}		override public function removeChildAt(index:int):DisplayObject {			throw SECURITY_ERROR;			return null;		}		override public function swapChildrenAt(index1:int, index2:int):void {			throw SECURITY_ERROR;		}	}}