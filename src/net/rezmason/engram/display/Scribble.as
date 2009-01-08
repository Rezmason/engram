﻿package net.rezmason.engram.display { 		// IMPORT STATEMENTS	import flash.display.CapsStyle;	import flash.display.JointStyle;	import flash.display.LineScaleMode;	import flash.display.Shape;	import flash.geom.Rectangle;	import flash.geom.Point;		public final class Scribble extends Shape {				// INSTANCE PROPERTIES		private var leftPoint:Point = new Point, midPoint:Point = new Point, rightPoint:Point = new Point;		private var _rect:Rectangle;		private var _breadth:Number = 10, _sloppiness:Number = 5, _thickness:Number = 5;		private var _color:int = 0x000000;		private var points:Array = [];				// CONSTRUCTOR		public function Scribble(__rect:Rectangle = null, __breadth:Number = 10, 								__thickness:Number = 5, __color:int = 0x000000, __sloppiness:Number = 5):void {						if (!__rect || !__rect.width || !__rect.height || isNaN(__breadth + __thickness + __color + __sloppiness)) {				return;			}						_rect = __rect.clone();			_breadth = __breadth;			_thickness = __thickness;			_color = __color;			_sloppiness = __sloppiness;						plot();			draw();		}				// GETTERS & SETTERS				public function get rect():Rectangle {			if (_rect) {				return _rect.clone();			} else {				return null;			}		}				public function set rect(value:Rectangle):void {			if (value) {				_rect = value.clone();				plot();				draw();			}		}				public function get breadth():Number {			return _breadth;		}				public function set breadth(value:Number):void {			if (!isNaN(value)) {				_breadth = value;				plot();				draw();			}		}				public function get thickness():Number {			return _thickness;		}				public function set thickness(value:Number):void {			if (!isNaN(value)) {				_thickness = value;				draw();			}		}				public function get color():int {			return _color;		}				public function set color(value:int):void {			if (!isNaN(value)) {				_color = value;				draw();			}		}				public function get sloppiness():Number {			return _sloppiness;		}				public function set sloppiness(value:Number):void {			if (!isNaN(value)) {				_sloppiness = value;				draw();			}		}				// PUBLIC METHODS				public function draw():void {			var ike:int = 0;			graphics.clear();			graphics.lineStyle(_thickness, _color, 1, false, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.BEVEL);			helpScribble(points[0].x, points[0].y, true);			while (++ike < points.length) {				helpScribble(points[ike].x, points[ike].y);			}		}				// PRIVATE METHODS				private function plot():void {						leftPoint.x = _rect.left, leftPoint.y = _rect.top + Math.random() * _rect.height * 0.2;			points = [leftPoint.clone()];			rightPoint.y = _rect.top, midPoint.y = _rect.bottom;						while (true) {				rightPoint.x = leftPoint.x + (0.5 + Math.random()) * _breadth;				if (rightPoint.x > _rect.right) {					rightPoint.x = _rect.right;					rightPoint.y = _rect.bottom - Math.random() * _rect.height * 0.2;					points.push(rightPoint.clone());					break;				}								midPoint.x = leftPoint.x + Math.random() * 0.4 * (rightPoint.x - leftPoint.x);				points.push(midPoint.clone(), rightPoint.clone());				leftPoint.x = rightPoint.x;			}					}				private function helpScribble(__x:Number, __y:Number, moving:Boolean = false):void {			with (graphics) {				(moving ? moveTo : lineTo)(__x + (Math.random() - 0.5) * _sloppiness, __y + (Math.random() - 0.5) * _sloppiness);			}		}			}	}