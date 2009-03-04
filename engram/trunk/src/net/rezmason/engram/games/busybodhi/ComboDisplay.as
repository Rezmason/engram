package net.rezmason.engram.games.busybodhi {

	// IMPORT STATEMENTS
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	import com.robertpenner.easing.Quadratic;
	import gs.TweenLite;

	internal class ComboDisplay extends Sprite {

		// INSTANCE PROPERTIES
		private var blur:BlurFilter = new BlurFilter(0, 0, 3);
		private var childClasses:Object = {a:ComboButtonA, b:ComboButtonB, x:ComboButtonX, y:ComboButtonY};
		private var tween:TweenLite, jumpTween:TweenLite;
		private var empty:Boolean = true;
		private var jumper:Sprite = new Sprite;
		private var container:Sprite = new Sprite;
		
		public function ComboDisplay():void {
			addChild(jumper);
			jumper.addChild(container);
			container.blendMode = BlendMode.ADD;
			filters = [blur];
		}
		
		internal function append(symbol:String):void {
			var newChild:Sprite, newSymbol:String = symbol.charAt(symbol.length - 1);
			
			if (tween) {
				tween.complete();
			}
			
			if (jumpTween) {
				jumpTween.complete();
				jumper.scaleX = jumper.scaleY = 1;
			}
			
			newChild = new childClasses[newSymbol] as Sprite;
			
			if (empty) {
				container.addChild(newChild);
				addEventListener(Event.ENTER_FRAME, centerMe);
				container.alpha = 0;
			} else {
				var spacer:ComboButtonSpacer = new ComboButtonSpacer;
				spacer.x = container.width;
				container.addChild(spacer);
				newChild.x = container.width;
				container.addChild(newChild);
			}
			
			tween = TweenLite.to(container, 0.5, {alpha:1, ease:Quadratic.easeOut, onUpdate:updateTween});
			
			empty = false;
		}
		
		internal function clear():void {
			blur.blurX = blur.blurY = 0;
			if (tween) {
				tween.complete();
			}
			tween = TweenLite.to(container, 0.5, {alpha:0, ease:Quadratic.easeOut, onUpdate:updateTween, onComplete:removeChildren});
			empty = true;
		}
		
		internal function jump():void {
			jumpTween = TweenLite.to(jumper, 1, {scaleX:3, scaleY:3, ease:Quadratic.easeOut});
		}
		
		private function updateTween():void {
			blur.blurX = blur.blurY = (1 - container.alpha) * 10;
			filters = [blur];
		}
		
		private function removeChildren():void {
			while (container.numChildren) {
				container.removeChildAt(0);
			}
			container.x = 0;
			removeEventListener(Event.ENTER_FRAME, centerMe);
		}
		
		private function centerMe(event:Event):void {
			container.x = container.x / 2 - container.width / 4;
		}
	}
}