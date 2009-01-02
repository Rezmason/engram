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


/* NAME: Doppelganger   PURPOSE: enables crude bilocation of any DisplayObject. Also, an omen of death.
 * parameters of Doppelganger:
 * source- the original DisplayObject being imitated
 * 
 * properties of Doppelganger:
 * bitmapData- a clone of the internal BitmapData object
 *
 * (NOTE: Like Sequence, Doppelganger does not allow you to access its graphics property, despite
 * 	being a subclass of Shape.)
 */

package net.rezmason.display.blix
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class Doppelganger extends Shape
	{
		private static var moochers:Dictionary = new Dictionary(true);
		private static const POINT:Point = new Point;
		
		private var updating:Boolean = false;
		doppelspace var _source:DisplayObject;
		doppelspace var _frame:BitmapData;
		doppelspace var _matrix:Matrix = new Matrix;
		doppelspace var _rect:Rectangle = new Rectangle;
		public var update:Function;
		private var _mooching:Boolean;
		private var buddy:Doppelganger;
		
		use namespace doppelspace;

		public function Doppelganger(src:DisplayObject=null, mooching:Boolean = true):void
		{	
			update = updateBland;
			_mooching = mooching;
			if (src){
				source = src;
			}
		}
		private function updateBland(e:Event = null):void
		{
			if (!_source){
				throw new Error("You haven't specified a source DisplayObject for the Doppelganger you're trying to update.")
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
		private function updateMooching(e:Event = null):void 
		{
			if (!_source){
				throw new Error("You haven't specified a source DisplayObject for the Doppelganger you're trying to update.")
			}
			if (!buddy || buddy.source != _source) {
				if (moochers[_source]) {
					buddy = moochers[_source];
				} else {
					moochers[_source] = this;
					buddy = null;
					update = updateBland;
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
		public override function get graphics():Graphics
		{
			if (updating) {
				return super.graphics;
			} else {
				return null;
			}
		}
		public function get bitmapData():BitmapData
		{
			use namespace doppelspace;
			return _frame.clone();
		}
		public function get source():DisplayObject {
			return _source;
		}
		public function set source(d:DisplayObject):void {
			if (d == _source) {
				return;
			}
			update = updateBland;
			if (_mooching) {
				if (_source && moochers[_source] == this) {
					moochers[_source] = undefined;
				}
				_source = d;
				if (moochers[_source]) {
					buddy = moochers[_source];
					update = updateMooching;
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
	}
}

namespace doppelspace;