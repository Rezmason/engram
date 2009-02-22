﻿package net.rezmason.display {		// IMPORT STATEMENTS	import flash.display.CapsStyle;	import flash.display.Graphics;	import flash.display.LineScaleMode;	import flash.display.Shape;	import flash.events.Event;	import flash.geom.Point;	public final class Pasta extends Shape {		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;		private static const TWO_PI:Number = Math.PI * 2;		private static const INVERSE_TWO_PI:Number = 1 / (Math.PI * 2);		private var _transform:PastaTransform;		private var _lastTransform:PastaTransform;		private var arcPoints:Array, beginPoints:Array, endPoints:Array;		private var _graphics:Graphics;				private var curveInRads:Number;		private var spacing:Number;		private var radius:Number;		private var altitude:Number;		private var arcLength:Number;		private var numSegments:int;		private var beginning:int, ending:int;		private var xOffset:Number, yOffset:Number;		private var beginAngle:Number, endAngle:Number;		private var ratio:Number;		public function Pasta(arg:* = null):void {			if (arg) {				if (arg is PastaTransform) {					_transform = arg.clone();				} else if (arg is Object) {					_transform = new PastaTransform();					_transform.absorb(arg);				}			} else {				_transform = new PastaTransform();			}			_lastTransform = new PastaTransform();			_lastTransform.crapOut();			_graphics = super.graphics;			listen(null, true);		}		public function squirm(distance:Number):void {						var newOffset:Number = _transform._offset + distance;			var reposition:int = (_transform._offset + distance) / (2 * arcLength);						if (newOffset < 0) {				while (newOffset < 0) {					_transform._offset += 2 * arcLength;					newOffset += 2 * arcLength;					x -= _transform._wavelength;				}			} else if (reposition) {				x += _transform._wavelength * reposition;			}						_transform._offset = (_transform._offset + distance) % (2 * arcLength);						redraw();		}		public function transformPoint(p:Point):Point {			var returnVal:Point = new Point;						with (_transform) {								if (_curvature == 360) {					returnVal.x = -p.x - _offset;					returnVal.y = -p.y;				} else if (_curvature == 0) {					returnVal.x = p.x + _offset;					returnVal.y = p.y;				} else {									var pos:Number = _offset + p.x;					var centerIndex:int = Math.floor(pos / arcLength);					var flip:int = (centerIndex % 2) ? -1 : 1;					var yRad:Number = radius - p.y * flip;									pos = pos % arcLength;					while (pos < 0) {						pos += arcLength;					}									var angle:Number = ((1 - pos / arcLength) * _curvature + 90 - _curvature * 0.5) * DEGREES_TO_RADIANS;									returnVal.x = (centerIndex + 0.5) * spacing * 2 + Math.cos(angle) * yRad;					returnVal.y = yOffset * flip + Math.sin(angle) * yRad * -flip * _polarity;				}			}						return returnVal;		}		public function get pastaTransform():PastaTransform {			return _transform.clone();		}		public function set pastaTransform(value:PastaTransform):void {			if (_transform.absorb(value)) {				listen();			}		}		public function redraw(event:Event = null):void {			listen(event, true);		}		override public function get graphics():Graphics {			return null;		}		private function listen(event:Event = null, forced:Boolean = false):void {			if (forced) {				update();			} else {				addEventListener(Event.ENTER_FRAME, update);			}		}		private function update(event:Event = null):void {						removeEventListener(Event.ENTER_FRAME, update);			with (_transform) {								curveInRads = _curvature * DEGREES_TO_RADIANS;				spacing = Math.max(_thickness / 2 * Math.sin(curveInRads * 0.5), _wavelength * 0.25);				radius = spacing / Math.sin(curveInRads * 0.5);				altitude = spacing / Math.tan(curveInRads * 0.5);				arcLength = radius * curveInRads;								numSegments = int(1 + (_length + _offset) / arcLength);				beginning = int(_offset / arcLength);				ending = int((_offset + _length) / arcLength);				yOffset = altitude * _polarity;								var flip:Number;				var ike:int, jen:int;								with (_graphics) {					clear();					lineStyle(_thickness, _color, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);										if (_curvature == 360) {	// dumb curve						moveTo(-_offset, 0);						lineTo(-_offset - _length, 0);					} else if (!_curvature) {	// straight curve							moveTo(_offset, 0);						lineTo(_offset + _length, 0);					} else if (beginning == ending) {	// short curve (one arc segment)							xOffset = spacing * (2 * beginning + 1);							flip = (beginning % 2) ? -1 : 1;							// draw a beginning-ending arc where appropriate							beginAngle = _length / arcLength * _curvature;							ratio = (0.5 - (_offset % arcLength) / (arcLength - (_length % arcLength))) * _polarity;							endAngle = 90 * _polarity - beginAngle * (ratio + 0.5) + _curvature * ratio;							beginPoints = getArc(xOffset, yOffset, radius, beginAngle, endAngle, true);							moveTo(beginPoints[0][0], beginPoints[0][1] * flip);							for (ike = 1; ike < beginPoints.length; ike) {								if (_shortcut) {									lineTo(beginPoints[++ike][0], beginPoints[ike++][1] * flip);								} else {									curveTo(beginPoints[ike][0], beginPoints[ike++][1] * flip, beginPoints[ike][0], beginPoints[ike++][1] * flip);								}							}						} else {	// long curve (connected arc segments)							// draw an ending arc							xOffset = spacing * (2 * ending + 1);							flip = (ending % 2) ? -1 : 1;							endAngle = ((_length + _offset) % arcLength) / arcLength * _curvature;							endPoints = getArc(xOffset, yOffset, radius, endAngle, endAngle * 0.5 * (-_polarity - 1) + (90 + _curvature * 0.5) * _polarity, true);							if (_polarity < 0) {								endPoints.reverse();							}							moveTo(endPoints[0][0], endPoints[0][1] * flip);							for (ike = 1; ike < endPoints.length; ike) {								if (_shortcut) {									lineTo(endPoints[++ike][0], endPoints[ike++][1] * flip);								} else {									curveTo(endPoints[ike][0], endPoints[ike++][1] * flip, endPoints[ike][0], endPoints[ike++][1] * flip);								}							}							// draw the middle arcs							arcPoints = getArc(0, 0, radius, _curvature, 90 - _curvature * 0.5);							for (jen = ending - 1; jen > beginning; jen--) {								xOffset = spacing * (2 * jen + 2);								flip = _polarity * ((jen % 2) ? -1 : 1);								for (ike = 1; ike < arcPoints.length; ike) {									if (_shortcut) {										lineTo(arcPoints[++ike][0] + xOffset, arcPoints[ike++][1] * flip);									} else {										curveTo(arcPoints[ike][0] + xOffset, arcPoints[ike++][1] * flip, arcPoints[ike][0] + xOffset, arcPoints[ike++][1] * flip);									}								}							}							// draw a beginning arc							xOffset = spacing * (2 * beginning + 1);							flip = (beginning % 2) ? -1 : 1;							beginAngle = (arcLength - (_offset % arcLength)) / arcLength * _curvature;							beginPoints = getArc(xOffset, yOffset, radius, beginAngle, beginAngle * 0.5 * (+_polarity - 1) + (90 - _curvature * 0.5) * _polarity, true);							if (_polarity < 0) {								beginPoints.reverse();							}							for (ike = 1; ike < beginPoints.length; ike) {								if (_shortcut) {									lineTo(beginPoints[++ike][0], beginPoints[ike++][1] * flip);								} else {									curveTo(beginPoints[ike][0], beginPoints[ike++][1] * flip, beginPoints[ike][0], beginPoints[ike++][1] * flip);								}							}						}										if (_roundCap) {												var capSize:Number = Math.max((_thickness - _roundCap) * 0.5, 0);						var beginPoint:Point, endPoint:Point;						var beginBottom:Point, endBottom:Point;												if (capSize == 0) {							beginPoint = transformPoint(new Point(0, 0));							endPoint = transformPoint(new Point(_length, 0));														lineStyle();														beginFill(_color);							drawCircle(beginPoint.x, beginPoint.y, _thickness * 0.5);							endFill();														beginFill(_color);							drawCircle(endPoint.x, endPoint.y, _thickness * 0.5);							endFill();						} else {														beginPoint = transformPoint(new Point(0, capSize));							beginBottom = transformPoint(new Point(0, -capSize));							endPoint = transformPoint(new Point(_length, capSize));							endBottom = transformPoint(new Point(_length, -capSize));														lineStyle(_roundCap, _color);							moveTo(beginPoint.x, beginPoint.y);							lineTo(beginBottom.x, beginBottom.y);							moveTo(endPoint.x, endPoint.y);							lineTo(endBottom.x, endBottom.y);						}					}				}			}		}		private function getArc(centerX:Number, centerY:Number, radius:Number, arc:Number, startAngle:Number, stayOnCircle:Boolean = false):Array {						// Mad props to Ric Ewing: formequalsfunction.com						// var declaration is expensive						var returnValue:Array = [];			var segs:int, segAngle:Number;			var theta:Number, angle:Number, angleMid:Number;			var ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;			var xOffset:Number = centerX, yOffset:Number = centerY;					segs = (arc < 0 ? -arc : arc) * 0.02222 + 1;			segAngle = arc / segs;					theta = -segAngle * DEGREES_TO_RADIANS;			angle = -startAngle * DEGREES_TO_RADIANS;					ax = -Math.cos(angle) * radius;			ay = -Math.sin(angle) * radius;					if (stayOnCircle) {				returnValue.push([centerX - ax, centerY - ay]);				ax = 0;				ay = 0;			} else {				returnValue.push([xOffset, yOffset]);			}					while (segs--) {				angle += theta;				angleMid = angle - (theta * 0.5);				bx = ax + Math.cos(angle) * radius;				by = ay + Math.sin(angle) * radius;				cx = ax + Math.cos(angleMid) * (radius / Math.cos(theta / 2));				cy = ay + Math.sin(angleMid) * (radius / Math.cos(theta / 2));				returnValue.push([cx + xOffset, cy + yOffset], [bx + xOffset, by + yOffset]);			}					return returnValue;		}	}}