package {

import flash.events.Event;
import flash.display.Sprite;

import net.rezmason.utils.*;

/**
 *	Application entry point for FlexCheck.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author Jeremy Sachs
 *	@since 24.06.2008
 */
public class FlexCheck extends Sprite {
		
	/**
	 *	@constructor
	 */
	public function FlexCheck(){
		super();
		stage.addEventListener( Event.ENTER_FRAME, initialize );
	}

	/**
	 *	Initialize stub.
	 */
	private function initialize( event:Event ) : void
	{
		stage.removeEventListener( Event.ENTER_FRAME, initialize );
		trace( "FlexCheck::initialize()" );
		trace(isFlexCompiled());
	}
	
}

}
