/**
 * blix Library 1.0: bitmap augmentation
 * by Jeremy Sachs 9/30/2007
 *
 * I have no blog, yet. When I have one, visit it. 
 * Maybe by then I'll have a new blix library.
 *
 * You may distribute this class freely, provided it is not modified in any way (including
 * removing this header or changing the package path).
 *
 * jeremysachs@rezmason.net
 */

package net.rezmason.display.blix {
	
	// IMPORT STATEMENTS
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	* 	Class that crudely draws a DisplayObject in multiple locations at once.
	*	Also, an omen for death. 
	*	<p>Like Sequence, Doppelganger does not allow you to access its graphics property, despite
	* 	being a subclass of Shape.</p>
	* 
	*	@author Jeremy Sachs
	*	@langversion	ActionScript 3.0
	*	@playerversion	Flash 9
	*	@tiptext
	*/
	public class Doppelganger extends Shape {
		
		// CLASS PROPERTIES
		private static var moochers:Dictionary = new Dictionary(true);
		private static const POINT:Point = new Point;
		
		// INSTANCE PROPERTIES
		private var updating:Boolean = false;
		doppelspace var _source:DisplayObject;
		doppelspace var _frame:BitmapData;
		doppelspace var _matrix:Matrix = new Matrix;
		doppelspace var _rect:Rectangle = new Rectangle;
		private var _updateFn:Function;
		private var _mooching:Boolean;
		private var buddy:Doppelganger;
		
		use namespace doppelspace;
		
		/**
		* Constructor for Doppelganger class.
		*
		* @param	src	 The display object to imitate.
		* @param	mooching	 Determines whether to attempt to recycle Doppelgangers that imitate the source.
		*/
		public function Doppelganger(src:DisplayObject=null, mooching:Boolean = true):void {
			_updateFn = updateBland;
			_mooching = mooching;
			if (src) {
				source = src;
			}
		}
		
		// GETTERS & SETTERS
		[Exclude(name="graphics", kind="property")]
		override public function get graphics():Graphics {
			if (updating) {
				return super.graphics;
			} else {
				return null;
			}
		}
		
		/**
		* A copy of the Doppelganger's internal bitmap drawing of the source.
		*
		*/
		public function get bitmapData():BitmapData {
			use namespace doppelspace;
			return _frame.clone();
		}
		
		/**
		* The display object to imitate.
		*
		*/
		public function get source():DisplayObject {
			return _source;
		}
		
		/**
		*	@private
		*/
		public function set source(d:DisplayObject):void {
			
			if (d == _source) {
				return;
			}
			
			_updateFn = updateBland;
			if (_mooching) {
				if (_source && moochers[_source] == this) {
					moochers[_source] = undefined;
				}
				
				_source = d;
				if (moochers[_source]) {
					buddy = moochers[_source];
					_updateFn = updateMooching;
				} else {
					moochers[_source] = this;
				}	
			} else {
				_source = d;
			}
			
			if (_source) {
				update();
			}
		}
		
		// PUBLIC METHODS
		
		/**
		* Refreshes the Doppelganger instance.
		*
		* @param	event	 An optional Event param. This allows the method 
		*	to be passed to addEventListener().
		*/
		public function update(event:Event = null):void {
			_updateFn(event);
		}
		
		// PRIVATE METHODS
		
		private function updateBland(event:Event = null):void {
			if (!_source) {
				throw new Error("You haven't specified a source DisplayObject for the Doppelganger you're trying to update.");
			}

			updating = true;
			graphics.clear();

			_rect = _source.getBounds(_source);

			if (_rect.width && _rect.height) {
				if (_frame) {
					_frame.dispose();
				}
				_frame = new BitmapData(_rect.width, _rect.height, true, 0);
				_matrix.tx = -_rect.x, _matrix.ty = -_rect.y;
				_frame.draw(_source, _matrix);
				_matrix.tx *= -1, _matrix.ty *= -1;
				graphics.beginBitmapFill(_frame, _matrix);
				graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
				graphics.endFill();
			}
			updating = false;

		}
		
		private function updateMooching(event:Event = null):void {
			if (!_source) {
				throw new Error("You haven't specified a source display object for the Doppelganger you're trying to update.");
			}
			if (!buddy || buddy.source != _source) {
				if (moochers[_source]) {
					buddy = moochers[_source];
				} else {
					moochers[_source] = this;
					buddy = null;
					_updateFn = updateBland;
					updateBland();
					return;
				}
			}
			
			updating = true;
			graphics.clear();
			
			_rect = buddy._rect;
			if (_rect.width && _rect.height) {
				graphics.beginBitmapFill(buddy._frame, buddy._matrix);
				graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
				graphics.endFill();
			}
			
			updating = false;
		}
	}
}

namespace doppelspace;