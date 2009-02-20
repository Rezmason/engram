package {
	
	import __AS3__.vec.Vector;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import net.rezmason.display.worm.*;

	[SWF(width="800", height="600", frameRate="0", backgroundColor="#808080")]
	public class RoundWormProfiling extends Sprite
	{
		private var milliseconds:int;
		private var fps:int = 0;
		private var fpsText:TextField = new TextField();
		private var num:int = 50;
		private var worms:Vector.<RoundWorm> = new Vector.<RoundWorm>();
		private var worm:RoundWorm;
		private var wormTransform:RoundWormTransform = new RoundWormTransform();
		private var ike:int;
		private var timer:Timer = new Timer(0);
		
		public function RoundWormProfiling():void
		{
			milliseconds = getTimer();
			
			//wormTransform.shortcut = true;
			
			for (ike = 0; ike < num; ike++) {
				worms.push(worm = new RoundWorm(wormTransform)); 
				
				addChild(worm);
				worm.y = (0.5 + Number(ike)) / num * stage.stageHeight;
			}
				
			stage.addChild(fpsText);
			fpsText.autoSize = TextFieldAutoSize.LEFT;
			fpsText.defaultTextFormat = new TextFormat("_sans", 20, 0xFFFFFF);
			
			timer.addEventListener("timer", update);
			timer.start();
		}
		
		private function update(event:Event):void {
			
			for (ike = 0; ike < num; ike++) {
				worms[ike].squirm(5);
			}			
			
			if ( getTimer() - 1000 > milliseconds ) {
				milliseconds = getTimer();
				fpsText.text = fps.toString();
				fps = 0;
			} else {
				fps++;
			}
		}
	}
}
