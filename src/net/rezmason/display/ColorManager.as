﻿package net.rezmason.display {		// IMPORT STATEMENTS	import flash.display.BitmapData;	import flash.display.GradientType;	import flash.display.InterpolationMethod;	import flash.display.Shape;	import flash.display.SpreadMethod;	import flash.events.Event;	import flash.geom.ColorTransform;	import flash.geom.Matrix;		import gs.TweenLite;	import com.robertpenner.easing.Linear;		/**	* 	Controller class that handles animations between color palettes 	*	for a target ColorSprite hierarchy.	* 	*	@author Jeremy Sachs	*	@langversion	ActionScript 3.0	*	@playerversion	Flash 9	*	@tiptext	*/	public class ColorManager {				// CLASS PROPERTIES		private static const PLAIN_CT:ColorTransform = new ColorTransform;		private static const WHITE:int = 0xFFFFFF;		private static const BITMAP_RANGE:int = 128;				// INSTANCE PROPERTIES		private var colors:Array = [], oldColors:Array = [], colorBands:Array = [];		private var _targetIndex:int;		private var palette:Array = [];		private var hex:int = 0;		private var shape:Shape = new Shape, gradientMatrix:Matrix = new Matrix;				private var tweenObject:Object = {value:0};		private var tweenToObject:Object = {			ease:Linear.easeNone, 			delay:0, 			onUpdate:updateColors, 			onComplete:updateColors, 			value:BITMAP_RANGE - 1		};		private var _target:Object;				/**		* Creates a ColorManager object that you can use to set and animate		*	the color palette of a color object hierarchy.		*			*	<p>The ColorManager is not necessary for applying color palettes		*	to ColorSprites. Its job is to allow color palettes to transition over		*	time.</p>		*		*	@param	targ	The main ColorSprite or compatible Object to manipulate.		*	@param	targetIndex	 The color palette index of the target object.		*/				public function ColorManager(target:Object, targetIndex:int = 0):void {			this.target = target;			_targetIndex = targetIndex;		}				// GETTERS & SETTERS				/**		* The main ColorSprite or compatible Object to manipulate.		*	<p>An Object can be used as a target if it contains a setColors() method.</p>		*		*/		public function get target():Object {			return _target;		}				/**		* @private		*		*/		public function set target(value:Object):void {						if (!value.setColors || !value.setColors is Function) {				throw new ArgumentError("ColorManager subject must have a valid setColors() method.");			}						if (_target) {				resetColor();			}						_target = value;		}				// PUBLIC METHODS				/**		* Removes the applied color palette from the target.		*		*/		public function resetColor():void {			_target.setColors([PLAIN_CT]);		}				/**		* Initializes an animated or immediate color application to the target.		*		*/		public function applyColors(newColors:Array, timing:Number = 500, _targetIndex:Boolean = false):void {						var ike:int;						if (timing < 0) {				timing = 500;			}						identical: if (newColors.length == colors.length && timing != 0) {				for (ike = 0; ike < colors.length; ike += 1) {					if (colors[ike] != newColors[ike]) {						break identical;					}				}				return;			}						TweenLite.killTweensOf(tweenObject);						oldColors = colors.slice();			colors = newColors.slice();						palette = [];						for (ike = 0; ike < colors.length; ike += 1) {				palette[ike] = new ColorTransform();				solveColorTransform(colors[ike], palette[ike]);			}						if (timing) {								colorBands = [];				for (ike = 0; ike < colors.length; ike += 1) {										if (!oldColors[ike]) {						oldColors[ike] = WHITE;					}										gradientMatrix.createGradientBox(BITMAP_RANGE, 1);					with (shape.graphics) {						clear();						beginGradientFill(							GradientType.LINEAR, [oldColors[ike], colors[ike]], [1, 1], [0, 255], 							gradientMatrix,							SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB						);						drawRect(0, 0, BITMAP_RANGE, 1);						endFill();					}										colorBands[ike] = new BitmapData(BITMAP_RANGE, 1, false, colors[ike]);					colorBands[ike].draw(shape);				}								tweenObject.value = 0;				TweenLite.to(tweenObject, timing / 1000, tweenToObject);							} else {				_target.setColors(palette, _targetIndex);			}		}				// PRIVATE METHODS				private function solveColorTransform(hexVal:int, targetCT:ColorTransform):void {			targetCT.color = hexVal;			targetCT.redMultiplier = targetCT.redOffset / 255;			targetCT.greenMultiplier = targetCT.greenOffset / 255;			targetCT.blueMultiplier = targetCT.blueOffset / 255;			targetCT.redOffset = targetCT.greenOffset = targetCT.blueOffset = 0;		}				private function updateColors(event:Event = null):void {						var ike:int;						for (ike = 0; ike < colors.length; ike += 1) {				hex = colorBands[ike].getPixel(int(tweenObject.value), 0);				solveColorTransform(hex, palette[ike]);			}						_target.setColors(palette, _targetIndex);		}	}}