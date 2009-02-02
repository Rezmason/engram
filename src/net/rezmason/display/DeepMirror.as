﻿package net.rezmason.display {		// IMPORT STATEMENTS	import flash.display.Shape;	import flash.display.Stage;	import flash.display.StageDisplayState;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Matrix;		/**	*	Applicator that draws its stage as a texture.	*	<p>Intended to be thought-provokingly stupid.</p>	*	<p>This texture is opaque.</p>	*		*	@author Jeremy Sachs	*	@langversion	ActionScript 3.0	*	@playerversion	Flash 9	*	@tiptext	*/	public class DeepMirror extends Applicator {				// INSTANCE PROPERTIES		private var _ratio:Number = 1;		private var arrow:Shape = new Shape();		private var _stage:Stage;				/**		*	Creates a new DeepMirror instance.		*			*	<p>If either of the first two parameters are unspecified,		*	the DeepMirror automatically applies its texture		*	to its contents, effectively masking them.</p>		*		*	@param	w	 The desired width of the DeepMirror.		*	@param	h	 The desired height of the DeepMirror.		*	@param	index	 The color palette index of the applied texture.		*/		public function DeepMirror(w:int = AUTO, h:int = AUTO, index:int = 0xFF):void {			super(w, h, true, index);			addEventListener(Event.ADDED_TO_STAGE, startUpdating);			addEventListener(Event.REMOVED_FROM_STAGE, stopUpdating);						with (arrow.graphics) {				lineStyle(0, 0xFFFFFF);				beginFill(0x000000);				moveTo(0, 0);				lineTo(36, 60);				lineTo(60, 36);				lineTo(0, 0);			}		}				// PUBLIC METHODS				override public function rerez(ratio:Number = 1):void {			super.rerez();			_ratio = ratio;		}				// PRIVATE & PROTECTED METHODS				override protected function rethinkTexture():void {					}				override protected function redrawTexture():void {			output.lock();			output.fillRect(output.rect, 0x00000000);						if (stage && stage.displayState == StageDisplayState.NORMAL) {				var matrix:Matrix = new Matrix(_width * _ratio / stage.stageWidth, 0, 0, _height * _ratio / stage.stageHeight);				output.draw(stage, matrix);				matrix.tx = stage.mouseX * matrix.a;				matrix.ty = stage.mouseY * matrix.d;				output.draw(arrow, matrix);			}			output.unlock();			super.redrawTexture();		}				private function startUpdating(event:Event):void {			_stage ||= stage;			_stage.addEventListener(MouseEvent.MOUSE_MOVE, update, false, 0, true);			_stage.addEventListener(MouseEvent.MOUSE_DOWN, update, false, 0, true);			_stage.addEventListener(MouseEvent.MOUSE_UP, update, false, 0, true);			update();		}				private function stopUpdating(event:Event):void {			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, update);			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, update);			_stage.removeEventListener(MouseEvent.MOUSE_UP, update);			_stage = null;		}				private function update(event:Event = null):void {			rethinkTexture();			redrawTexture();		}	}}