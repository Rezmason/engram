﻿package net.rezmason.engram.display {		// IMPORT STATEMENTS	import flash.display.DisplayObject;	import flash.events.Event;	import flash.geom.Rectangle;	import flash.geom.Point;		import net.rezmason.display.DisplayObjectSlider;	import net.rezmason.utils.Hat;		import gs.TweenLite;	import com.robertpenner.easing.Quartic;	import com.robertpenner.easing.Quintic;		public final class HexSlider extends DisplayObjectSlider {				// CLASS PROPERTIES		private static const HEXAGON_POINTS:Array = 		[		new Point( 1,  1.732),		new Point(-1, -1.732),		new Point(-1,  1.732),		new Point( 1, -1.732),		new Point(-2,  0),		new Point( 2,  0),		];				private static const MAG:Number = 0.4;				// INSTANCE PROPERTIES		private var nextPoint:int = 0, currentPoint:int = 0;		private var hat:Hat = new Hat(6);		private var _centerSubject:DisplayObject;		private var _parallax:Number = 1;				// CONSTRUCTOR		public function HexSlider(rad:Number = 100, __centerSubject:DisplayObject = null, __parallax:Number = 1):void {			super(rad);			tweenToObjects.push(new Object());			_centerSubject = __centerSubject;			_parallax = __parallax;		}				// GETTERS & SETTERS				public function get centerSubject():DisplayObject {			return _centerSubject;		}				public function set centerSubject(value:DisplayObject):void {			if (_centerSubject) {				_centerSubject.x = 0;				_centerSubject.y = 0;				_centerSubject.rotation = 0;			}						_centerSubject = value;		}				public function get parallax():Number {			return _parallax;		}				public function set parallax(value:Number):void {			_parallax = value;		}				// PUBLIC METHODS				override public function show(dObj:DisplayObject, standIn:Object = null, time:Number = 1, func:Function = null, angle:Number = 0):void {							var scratch:Number;						// don't do anything if you're in the middle of something			if (_busy || _currentSubject == dObj) {				return;			}						if (time < 0) {				time = 0;			}						_busy = true;			mouseChildren = false;						// set the tweening function			func ||= (Math.random() < 0.3) ? Quartic.easeInOut : Quintic.easeInOut;			try {				tweenToObjects[0].ease = func;			} catch (error:Error) {				tweenToObjects[0].ease = Quintic.easeInOut;			}						tweenToObjects[1].ease = tweenToObjects[0].ease;						nextSubject = dObj;			nextSubject.rotation = 0;			nextSubject.x = 0, nextSubject.y = 0;			nextSubject.scaleY = 1, nextSubject.scaleX = 1;						// we'll need to know the bounds of the next subject			nextRect = null;			if (standIn) {				if (standIn is Rectangle) {					nextRect = (standIn as Rectangle).clone();				} else if (standIn.x && standIn.y && standIn.width && standIn.height) {					with (helperShape.graphics) {						clear();						lineStyle(3);						drawRect(standIn.x, standIn.y, standIn.width, standIn.height);					}					nextRect = helperShape.getBounds(nextSubject);				}			}						if (!nextRect) {				nextRect = nextSubject.getBounds(nextSubject);			}						nextRadius = (nextRect.width * nextRect.width + nextRect.height * nextRect.height) * 0.25;			nextRadius = Math.pow(nextRadius, 0.5);						if (nextRadius > _radius) {				scratch = _radius / nextRadius;				nextSubject.width  *= scratch;				nextSubject.height *= scratch;				nextRect.width *= scratch;				nextRect.height *= scratch;				nextRect.x *= scratch;				nextRect.y *= scratch;				nextRadius = _radius;				trace(":(", "Your module was initially too big and had to be scaled down.");			}						nextCenter.x = nextRect.x + nextRect.width  / 2;			nextCenter.y = nextRect.y + nextRect.height / 2;						// place subject at one of six points on a hexagon			// we don't want the opposite point, or the current point						while (nextPoint == currentPoint || Math.abs(nextPoint - currentPoint) == 3) {				nextPoint = hat.pick();			}						// rotate it just a tad			nextSubject.rotation = -container.rotation + (30 + Math.random() * 15) * (Math.random() > 0.5 ? 1 : -1);			transformMatrix.identity();			transformMatrix.rotate(-nextSubject.rotation * DEGREES_TO_RADIANS);			transformMatrix.translate(-nextCenter.x, -nextCenter.y);			transformMatrix.rotate(nextSubject.rotation * DEGREES_TO_RADIANS);			transformMatrix.translate(-HEXAGON_POINTS[nextPoint].x * _radius, -HEXAGON_POINTS[nextPoint].y * _radius);			nextSubject.x = transformMatrix.tx;			nextSubject.y = transformMatrix.ty;			transformMatrix.identity();			transformMatrix.translate(-HEXAGON_POINTS[nextPoint].x * radius, -HEXAGON_POINTS[nextPoint].y * radius);			transformMatrix.rotate(-nextSubject.rotation * DEGREES_TO_RADIANS);						tweenToObjects[0].x = -transformMatrix.tx;			tweenToObjects[0].y = -transformMatrix.ty;			tweenToObjects[0].rotation = -nextSubject.rotation;						while (tweenToObjects[0].rotation - container.rotation > 180) {				tweenToObjects[0].rotation -= 360;			}						while (tweenToObjects[0].rotation - container.rotation < -180) {				tweenToObjects[0].rotation += 360;			}						// again, for the center subject			if (_centerSubject) {				transformMatrix.identity();				transformMatrix.translate(-HEXAGON_POINTS[nextPoint].x * radius * MAG, -HEXAGON_POINTS[nextPoint].y * radius * MAG);				transformMatrix.rotate(-nextSubject.rotation * DEGREES_TO_RADIANS);				tweenToObjects[1].x = -transformMatrix.tx;				tweenToObjects[1].y = -transformMatrix.ty;				tweenToObjects[1].rotation = tweenToObjects[0].rotation;			}						nextSubject.rotation = -tweenToObjects[0].rotation;						container.addChild(nextSubject);						tweens[0] = TweenLite.to(container, time, tweenToObjects[0]);			if (_centerSubject) {				tweens[1] = TweenLite.to(_centerSubject, time, tweenToObjects[1]);				}						if (time == 0) {				fastForward();			}						currentPoint = nextPoint;		}				// PRIVATE & PROTECTED METHODS				override protected function finishTween(event:Event = null):void {			super.finishTween();		}	}}