﻿/** * Peeler 1.0: cliché encapsulated for easy consumption * by Jeremy Sachs 1/5/2009 * * You may distribute this class freely, provided it is not modified in any way (including * removing this header or changing the package path). * * jeremysachs@rezmason.net */package net.rezmason.display {	// IMPORT STATEMENTS	import flash.display.BlendMode;	import flash.display.DisplayObject;	import flash.display.GradientType;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Matrix;	import flash.geom.Point;	import flash.geom.Rectangle;		/**	*	A Sprite with a top surface and a bottom surface, and a peeling line.	*	<p>This class can be used to simulate any surface that partially flips.</p>	*		*	@author Jeremy Sachs	*	@langversion	ActionScript 3.0	*	@playerversion	Flash 9	*	@tiptext	*/	public final class Peeler extends Sprite {				// CLASS PROPERTIES		private static const BUFFER:uint = 10;		/**		*	The PEELING constant defines the value of the type property of a Peeler's event object		*	when it has begun to visually peel.		*			*	@see Peeler#NOT_PEELING		*/		public static const PEELING:String = "peeling";		/**		*	The NOT_PEELING constant defines the value of the type property of a Peeler's event object		*	when it no longer visually peels.		*			*	@see Peeler#PEELING		*/		public static const NOT_PEELING:String = "notPeeling";		private static const PEELING_EVENT:Event = new Event(PEELING);		private static const NOT_PEELING_EVENT:Event = new Event(NOT_PEELING);		private static const SHINY_ERROR:Error = new Error("A Peeler cannot be shiny if it has no shine mask.");		private static const SHADED_ERROR:Error = new Error("A Peeler cannot be shaded if it has no shadow mask.");		private static const DUD_SHADOW_MASK:Shape = new Shape, DUD_SHINE_MASK:Shape = new Shape;				// INSTANCE PROPERTIES		private var _peeling:Boolean = false;		private var _frontside:DisplayObject;		private var _backside:DisplayObject;		private var _shadowMask:DisplayObject;		private var _shineMask:DisplayObject;		private var _axis:Shape = new Shape;		private var shadow:DisplayObject;		private var shine:DisplayObject;				private var _locked:Boolean = false;		private var maskOrigin:Point = new Point;		private var maskRect:Rectangle;		private var matrix:Matrix, matrix2:Matrix;		private var frontMask:DisplayObject;		private var backMask:DisplayObject;		private var backSide:Sprite = new Sprite;		private var frontSide:Sprite = new Sprite;				/**		*	Creates and initializes a Peeler instance.		*			*	@param	frontside	 The image that appears 		*	on the front of the peeling surface.		*	@param	backside	The image that appears 		*	on the back of the peeling surface.		*	@param	shadowMask	 An image that masks 		*	the shadow cast on the front side during the peel.		*	<p>When shadowMask is null, no shadow is drawn.</p>		*	@default    <code>null</code>		*	@param	shineMask	 An image that masks 		*	the shine cast on the back side during the peel.		*	<p>When shineMask is null, no shine is drawn.</p>		*	@default    <code>null</code>		*/		public function Peeler(frontside:DisplayObject, backside:DisplayObject, shadowMask:DisplayObject = null, shineMask:DisplayObject = null):void {						frontMask = makeMask();			backMask = makeMask();			shadow = makeShadow();			shadow.blendMode = BlendMode.MULTIPLY;			shine = makeShine();			shine.blendMode = BlendMode.SCREEN;						_frontside = frontside;			_backside = backside;			_shadowMask = shadowMask || DUD_SHADOW_MASK;			_shineMask = shineMask || DUD_SHINE_MASK;						addChild(frontSide);			addChild(backSide);						frontSide.addChild(_frontside);			frontSide.addChild(frontMask), frontMask.alpha = 0;			frontSide.addChild(shadow);			frontSide.addChild(_shadowMask);						backSide.addChild(_backside);			backSide.addChild(backMask);			backSide.addChild(shine);			backSide.addChild(_shineMask);						update();		}				// GETTERS & SETTERS				/**		*	Indicates whether the Peeler has a shine.		*		*/		public function get shiny():Boolean {			return (_shineMask != DUD_SHINE_MASK);		}				/**		*	Indicates whether the Peeler has a shadow.		*		*/		public function get shaded():Boolean {			return (_shadowMask != DUD_SHADOW_MASK);		}				/**		*	The x-position of the peel axis.		*		*/		public function get axisX():Number {			return _axis.x;		}				/**		*	@private		*			*/		public function set axisX(value:Number):void {			_axis.x = value;			update();		}				/**		*	The y-position of the peel axis.		*		*/		public function get axisY():Number {			return _axis.y;		}				/**		*	@private		*		*/		public function set axisY(value:Number):void {			_axis.y = value;			update();		}				/**		*	The angle of the peel axis, in degrees.		*	<p>It's in degrees because I'm not a jerk.</p>		*		*/		public function get axisR():Number {			return _axis.rotation;		}				/**		*	@private		*		*/		public function set axisR(value:Number):void {			_axis.rotation = value;			update();		}				/**		*	The image that appears on the front of the 		*	peeling surface. <p>This value cannot be 		*	set to <code>null</code>.</p>		*		*/		public function get frontside():DisplayObject {			return _frontside;		}				/**		*	@private		*		*/		public function set frontside(value:DisplayObject):void {			if (value && value.parent != this) {				_frontside = swap(_frontside, value)				}		}				/**		*	The image that appears on the back of the 		*	peeling surface. <p>This value cannot be 		*	set to <code>null</code>.</p>		*/		public function get backside():DisplayObject {			return _backside;		}				/**		*	@private		*		*/		public function set backside(value:DisplayObject):void {			if (value && value.parent != this) {				_backside = swap(_backside, value)				}		}				/**		*	An image that masks the shadow cast on the 		*	front side during the peel. <p>Set 		*	<code>shadowMask</code> to <code>null</code> 		*	to remove the shadow.</p>		*/		public function get shadowMask():DisplayObject {			if (!shaded) {				return null;			}			return _shadowMask;		}				/**		*	@private		*		*/		public function set shadowMask(value:DisplayObject):void {			if (value) {				if (value.parent != this) {					_shadowMask = swap(_shadowMask, value);				}			} else if (_shadowMask != DUD_SHADOW_MASK) {				_shadowMask = swap(_shadowMask, DUD_SHADOW_MASK);			}		}				/**		*	An image that masks the shine cast on the 		*	back side during the peel.		*	<p>Set <code>shineMask</code> 		*	to <code>null</code> to remove the shine.</p>		*/		public function get shineMask():DisplayObject {			if (!shiny) {				return null;			}			return _shineMask;		}				/**		*	@private		*		*/		public function set shineMask(value:DisplayObject):void {			if (value) {				if (value.parent != this) {					_shineMask = swap(_shineMask, value);				}			} else if (_shineMask != DUD_SHINE_MASK) {				_shineMask = swap(_shineMask, DUD_SHINE_MASK);			}		}				// PUBLIC METHODS				/**		*	Updates the peel effect. <p>Typically not necessary,		*	as it is called internally when properties of the		*	Peeler change.</p>		*		*/		public function update():void {						addChild(_axis);						if (_locked) {				return;			}						maskRect = _frontside.getBounds(_axis);			maskRect.x -= BUFFER, maskRect.y -= BUFFER;			maskRect.width += 2 * BUFFER, maskRect.height += 2 * BUFFER;			frontSide.visible = (maskRect.x <= 0);			maskRect.width = Math.max(maskRect.width + maskRect.x, 0);			maskRect.x = 0;			if (maskRect.width > 0) {				backSide.visible = true;				matrix = _frontside.transform.matrix.clone();				matrix2 = _axis.transform.matrix.clone();				matrix2.invert();				matrix.concat(matrix2);				matrix.a *= -1;				matrix.c *= -1;				matrix.tx *= -1;				matrix.concat(_axis.transform.matrix);				_shineMask.transform.matrix = _backside.transform.matrix = matrix;			} else {				backSide.visible = false;			}						if (backSide.visible && frontSide.visible) {				if (!_peeling) {					_peeling = true;					dispatchEvent(PEELING_EVENT);				}			} else if (_peeling) {				_peeling = false;				dispatchEvent(NOT_PEELING_EVENT);			}						if (shiny || backSide.visible && frontSide.visible) {				maskOrigin = globalToLocal(_axis.localToGlobal(maskRect.topLeft));				updateTransform(frontMask);				updateTransform(backMask, true);				updateTransform(shadow, true);				updateTransform(shine, true);				showMasks();			} else {				hideMasks();			}		}				/**		*	Locks the peel so that it does not update its 		*	appearance while its properties are modified. 		*	<p>To improve performance, use this method along 		*	with the unlock() method before and after 		*	modifying multiple properties of a peeler 		*	instance.</p>		*			*	@see	Peeler#unlock		*		*/		public function lock():void {			_locked = true;		}				/**		*	Unlocks the peel so that it updates its 		*	appearance when any of its properties are 		*	modified. <p>To improve performance, use 		*	this method along with the unlock() method 		*	before and after modifying multiple 		*	properties of a peeler instance.</p>		*			*	@see	Peeler#lock		*		*/		public function unlock():void {			_locked = false;			update();		}				// PRIVATE & PROTECTED METHODS				private function updateTransform(target:DisplayObject, flip:Boolean = false):void {			target.rotation = 0;			target.width  = maskRect.width;			target.height = maskRect.height;						if (flip) {				target.scaleX *= -1;			}						target.x = maskOrigin.x;			target.y = maskOrigin.y;			target.rotation = _axis.rotation;		}				private function showMasks():void {						_shadowMask.visible = false;			_shineMask.visible = false;						if (!_backside.mask) {				frontSide.blendMode = BlendMode.LAYER;				frontMask.blendMode = BlendMode.ALPHA;				_backside.mask = backMask;				backMask.visible = frontMask.visible = true;								shadow.visible = shaded;				shadow.mask = (shaded ? _shadowMask : null);				_shadowMask.visible = shaded;								shine.visible = shiny;				shine.mask = (shiny ? _shineMask : null);				_shineMask.visible = shiny;			}		}		private function hideMasks():void {			if (_backside.mask) {				frontSide.blendMode = BlendMode.NORMAL;				frontMask.blendMode = BlendMode.NORMAL;				_backside.mask = null;				backMask.visible = frontMask.visible = false;								shadow.visible = false;				shadow.mask = null;				_shadowMask.visible = false;								shine.visible = false;				shine.mask = null;				_shineMask.visible = false;			}		}				private function makeMask():DisplayObject {			var returnVal:Sprite = new Sprite();			var shape:Shape = new Shape;			with (shape.graphics) {				lineStyle();				beginFill(0xFFFFFF);				drawRect(0, 0, 10, 10);				endFill();			}			returnVal.addChild(shape);			return returnVal;		}				private function makeShadow():DisplayObject {			var returnVal:Sprite = new Sprite();			var shape:Shape = new Shape;			var box:Matrix = new Matrix;			var colors:Array = [0x444444, 0xCCCCCC, 0xEEEEEE, 0xFFFFFF];			var ratios:Array = [0, 64, 128, 192];			box.createGradientBox(100, 100, 0, 0, 0);			with (shape.graphics) {				lineStyle();				beginGradientFill(GradientType.LINEAR, colors, [1, 1, 1, 1], ratios, box);				drawRect(0, 0, 100, 100);				endFill();			}			returnVal.addChild(shape);			return returnVal;		}				private function makeShine():DisplayObject {			var returnVal:Sprite = new Sprite();			var shape:Shape = new Shape;			var box:Matrix = new Matrix;			var colors:Array = [0x000000, 0xFFFFFF, 0xFFFFFF, 0x000000];			var ratios:Array = [0, 84, 102, 255];			box.createGradientBox(100, 100, 0, 0, 0);			with (shape.graphics) {				lineStyle();				beginGradientFill(GradientType.LINEAR, colors, [1, 1, 1, 1], ratios, box);				drawRect(0, 0, 100, 100);				endFill();			}			returnVal.addChild(shape);			return returnVal;		}				private function swap(d1:DisplayObject, d2:DisplayObject):DisplayObject {			if (d2) {				with (d1.parent) {					addChildAt(d2, getChildIndex(d1));					removeChild(d1);				}								update();				}			return d2 || d1;		}	}}