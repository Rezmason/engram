﻿package net.rezmason.display {		// IMPORT STATEMENTS	import flash.display.BlendMode;	import flash.display.BitmapData;	import flash.display.BitmapDataChannel;	import flash.display.GradientType;	import flash.display.Shape;	import flash.display.Sprite;	import flash.filters.BlurFilter;	import flash.geom.Matrix;		/**	* 	Applicator that generates a generically grimy texture.	*	<p>(Sort of like a greasy paper bag.)</p>	*	<p>This texture is transparent.</p>	* 	*	@author Jeremy Sachs	*	@langversion	ActionScript 3.0	*	@playerversion	Flash 9	*	@tiptext	*/	public class GrimySurface extends Applicator {				//  CLASS PROPERTIES				private static const BLUR_FILTER:BlurFilter = new BlurFilter(1, 1, 1);				// INSTANCE PROPERTIES		private var grimeMatrix:Matrix = new Matrix;		private var grimeTexture:BitmapData;		private var scrapTexture:BitmapData;		private var scrapTexture2:BitmapData;		private var shape1:Shape = new Shape, shape2:Shape = new Shape, shape3:Shape = new Shape;		private var grimeHolder:Sprite = new Sprite;				private var seed:int;		private var shape1Scale:Number, shape1Rotation:Number, shape1X:Number, shape1Y:Number;		private var shape2Rotation:Number;		private var shape3X:Number, shape3Y:Number;				private var scratch:Number;				/**		* Creates a new GrimySurface instance.		*			*	<p>If either of the first two parameters are unspecified,		*	the GrimySurface automatically applies its texture		*	to its contents, effectively masking them.</p>		*		*	@param	w	 The desired width of the GrimySurface.		*	@param	h	 The desired height of the GrimySurface.		*	@param	index	 The color palette index of the applied texture.		*/		public function GrimySurface(w:int = AUTO, h:int = AUTO, index:int = 0xFF):void {			super(w, h, true, index);			textureBlendMode = BlendMode.MULTIPLY;		}				// PRIVATE & PROTECTED METHODS				override protected function rethinkTexture():void {			seed = Math.random() * 0xFFFFFF;			shape1Scale = Math.random() * 1.8;			shape1Rotation = Math.random() * 180;			shape1X = Math.random(), shape1Y = Math.random();			shape2Rotation = Math.random() * 360;			shape3X = Math.random(), shape3Y = Math.random();		}				override protected function redrawTexture():void {						scrapTexture = new BitmapData(_width, _height, true, 0x00000000);			scrapTexture2 = scrapTexture.clone();			grimeTexture = scrapTexture.clone();						scratch = (_width + _height);						// perlin noise in two sizes			grimeTexture.perlinNoise(scratch * .1, scratch * .1, 5, seed, true, true, 1);			scrapTexture.perlinNoise(scratch * .01, scratch * .01, 5, seed, true, true, 1);			//scrapTexture.fillRect(scrapTexture.rect, 0xFFFF0000);						// create radial shape			grimeMatrix.createGradientBox(scratch / 2, scratch / 2);			with (shape1.graphics) {				clear();				beginGradientFill(GradientType.RADIAL, [0xFF0000, 0x000000], [1, 1], [0, 255], grimeMatrix);				drawCircle(scratch / 4, scratch / 4, scratch / 4);				endFill();			}						shape1.scaleX = shape1Scale;			shape1.scaleY = shape1Scale;			shape1.x = -shape1.width / 2;			shape1.y = -shape1.height / 2;						// apply radial shape to small perlin noise, draw it onto large perlin noise			grimeMatrix.identity();			grimeMatrix.rotate(shape1Rotation);			grimeMatrix.tx = shape1X * _width, grimeMatrix.ty = shape1Y * _height;			scrapTexture2.fillRect(scrapTexture2.rect, 0xFF000000);			scrapTexture2.draw(grimeHolder, grimeMatrix);			scrapTexture.copyChannel(scrapTexture2, scrapTexture2.rect, scrapTexture2.rect.topLeft, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);			grimeTexture.draw(scrapTexture);			scrapTexture.fillRect(scrapTexture.rect, 0xFF000000);			scrapTexture.threshold(grimeTexture, grimeTexture.rect, grimeTexture.rect.topLeft, "<", 0x880000, 0xFF000000, 0xFF0000, true);						// result: texture of radially varying granularity						// create linear shape			scratch *= 1.5;			grimeMatrix.createGradientBox(scratch / 2, scratch / 2);			with (shape2.graphics) {				clear();				beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [1, 0], [0, 255], grimeMatrix);				drawCircle(scratch / 4, scratch / 4, scratch / 4);				endFill();			}			shape2.width = shape2.height = scratch;			shape2.x = -shape2.width / 2;			shape2.y = -shape2.height / 2;						// apply linear shape to texture			grimeMatrix.identity();			grimeMatrix.rotate(shape2Rotation);			grimeMatrix.tx = _width / 2, grimeMatrix.ty = _height / 2;			scrapTexture.draw(grimeHolder, grimeMatrix);						// make a sharp cut in the shape that is more opaque (like a shoeprint)			with (shape3.graphics) {				clear();				beginFill(0x000000, 0.4);				drawRect(0, 0, _width, _height);				drawCircle(shape3X * _width, shape3Y * _height, scratch / 4);				endFill();			}			scrapTexture.draw(shape3);						grimeTexture.fillRect(grimeTexture.rect, 0xFFFFFFFF);			grimeTexture.copyChannel(scrapTexture, grimeTexture.rect, grimeTexture.rect.topLeft, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);			// blur things a bit			BLUR_FILTER.blurX = BLUR_FILTER.blurY = scratch / 1000;			grimeTexture.applyFilter(grimeTexture, grimeTexture.rect, grimeTexture.rect.topLeft, BLUR_FILTER);			// apply to final bitmap data			output.draw(grimeTexture, null);						super.redrawTexture();		}	}}