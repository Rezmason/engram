/**
 * ActiveGraph 1.7: an overthought shot in the dark
 * by Jeremy Sachs May 3, 2008
 *
 * I have no blog, yet. When I have one, visit it. 
 * Maybe by then I'll have a new ActiveGraph.
 *
 * You may distribute this class freely, provided it is not modified in any way (including
 * removing this header or changing the package path).
 *
 * jeremysachs@rezmason.net
 */


/* parameters of ActiveGraph (all are optional):
 * interval- the length of time (in milliseconds) between memory checks.
 * (NOTE: a memory check does not always make a point on the graph, only when there's relevant data.)
 * verbose- when set to true, this traces data to your Output menu.
 * visible- when set to false, this keeps Activegraph from drawing to the screen.
 * degree- sets the number of sawtooth patterns to compensate for. (Default is 2)
 */

package net.rezmason.utils
{
	// IMPORT STATEMENTS
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.system.System;
	
	/* ActiveGraph
	 * This is the class that is publicly accessible, and which is instantiable.
	 */

	public final class ActiveGraph extends Sprite
	{
		// CLASS PROPERTIES
		private static const MEGABYTE:int = 1048576, PAGE:int = 4096;
		private static const PLUS:String = "+", MINUS:String = "-", ZERO:String = " ";
		private static const MAX_LENGTH:int = 21;
		
		public static const RAW:int = 0, PRIMARY:int = 1, SECONDARY:int = 2, ALL:int = 3;

		// INSTANCE PROPERTIES
		private var verboseMode:Boolean, returnVal:Boolean;
		private var lastPlot1:Number = 0, lastPlot2:Number = 0, plot:Number = 0, plotLength:Number = 0;
		private var history:Array = new Array ;	// Array of Numbers
		private var sign:String;
		private var backX:Number, backY:Number;
		private var dragging:Boolean = false;
		private var numerator:Number = 0, denominator:Number = 0, average:int = 0, old:int = 0;
		private var caught2:Boolean = false;
		private var fn:Function;
		private var plotTimer:Timer;
		private var view:View;
		internal var defaultColor:int = 0xFF0000;

		// CONSTRUCTOR
		public function ActiveGraph(interval:Number = 0, verbose:Boolean = false, 
									drawData:Boolean = true, degree:int = 3, 
									chaperone:Chaperone = null):void
		{
			if (degree >= 3)
			{
				var child:ActiveGraph;
				const CHAPERONE:Chaperone = new Chaperone;
				
				plotTimer = new Timer(interval);
				
				child = new ActiveGraph(interval, verbose, drawData, 0, CHAPERONE);
				child.color = 0xFF0000;
				child.setupTimer(plotTimer);
				addChild(child);
				
				child = new ActiveGraph(interval, verbose, drawData, 1, CHAPERONE);
				child.y = height;
				child.color = 0x00FF00;
				child.setupTimer(plotTimer);
				addChild(child);
				
				child = new ActiveGraph(interval, verbose, drawData, 2, CHAPERONE);
				child.y = height;
				child.color = 0x0000FF;
				child.setupTimer(plotTimer);
				addChild(child);
				
				setupDraggingBehavior();
				plotTimer.start();
				
				return;
			}
			
			verboseMode = verbose;

			switch (degree)
			{
				case 0 :
					fn = test0;
					break;
				case 1 :
					fn = test1;
					break;
				case 2 :
					fn = test2;
					break;
			}
			
			if (drawData)
			{
				view = new View(defaultColor);
				addChild(view);
				
				if (!chaperone)
				{
					setupDraggingBehavior();
				}
			} else
			{
				trace("ActiveGraph Running.");
			}
			
			if (!chaperone)
			{
				setupTimer(new Timer(interval));
				plotTimer.start();
			}
			
		}
		
		// INTERNAL INSTANCE METHODS
		
		internal function setupTimer(timer:Timer):void
		{
			plotTimer = timer;
			
			if (view)
			{
				plotTimer.addEventListener(TimerEvent.TIMER, drawMem, false, 0, true);
			} else
			{
				plotTimer.addEventListener(TimerEvent.TIMER, trackMem, false, 0, true);
			}
		}
		
		internal function set color(value:int):void
		{
			view.color = value;
		}
		
		// PRIVATE INSTANCE METHODS
		
		private function setupDraggingBehavior():void
		{
			backX = x, backY = y;
			addEventListener(MouseEvent.MOUSE_DOWN, beginDrag, true, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, endDrag, true, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, addEventListeners, false, 0, true);
		}
		
		// trackMem- determines whether the GC has run, outputs active memory
		private function trackMem(event:TimerEvent = null):Boolean
		{
			returnVal = false;
			plot = System.totalMemory / PAGE;
			old = average;
			numerator += plot;
			denominator++;
			average = numerator / denominator;

			// if the plot is relevant...
			if (fn() && verboseMode)
			{
				trace(plot);
			}
			
			return returnVal;
		}
		
		// test0: doesn't clean up sawteeth
		private function test0():Boolean
		{
			if (lastPlot1 != plot)
			{
				returnVal = true;
				lastPlot1 = plot;
			}
			return returnVal;
		}
		
		// test1: cleans up DRC sawteeth
		private function test1():Boolean
		{
			returnVal = (!lastPlot1 || lastPlot1 > plot);
			lastPlot1 = plot;
			return returnVal;
		}
		
		// test2: cleans up mark'n'sweep sawteeth
		private function test2():Boolean
		{
			if (lastPlot1 > plot || !lastPlot1)
			{
				if (lastPlot2 > plot || !lastPlot2)
				{
					caught2 = true;
				}
				lastPlot2 = plot;
			} else if (lastPlot1 < plot && caught2)
			{
				plot = lastPlot2;
				returnVal = true;
				caught2 = false;
			}
			lastPlot1 = plot;

			return returnVal;
		}
		
		// drawMem- updates graph and textbox
		private function drawMem(event:TimerEvent = null):void
		{
			if (trackMem())
			{
				// history array loops after a certain length
				if (plotLength == MAX_LENGTH)
				{
					history.shift();
					plotLength--;
				}
				
				// determines whether to display +/- for memory increase/decrease
				if (plot > history[int(plotLength - 1)])
				{
					sign = PLUS;
				} else if (plot < history[int(plotLength - 1)])
				{
					sign = MINUS;
				} else
				{
					sign = ZERO;
				}
				
				// add plot to data set
				history.push(plot);
				plotLength = history.length;
				
				
				// If the graph's long enough,
				if (plotLength > 1)
				{
					view.plot(history);
				}
				
				// put output text in textBox
				view.text = plot + sign + " , " + average;
			}
		}
		
		private function beginDrag(event:Event):void
		{
			// start dragging
			backX = x, backY = y;
			startDrag();
			dragging = true;
		}
		
		private function endDrag(event:Event):void
		{
			// stop dragging
			stopDrag();
			if (event.type == Event.MOUSE_LEAVE)
			{
				x = backX, y = backY;
				dragging = false;
			}
			dragging = false;
		}
		
		private function addEventListeners(event:Event):void
		{
			stage.addEventListener(Event.MOUSE_LEAVE, endDrag, false, 0, true);
		}
		
		public function get data():Number
		{
			return plot;
		}
	}
}

/* View class
 * A simple helper class responsible for drawing graphs with numbers next to them
 */
 
// IMPORT STATEMENTS
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
	

internal final class View extends Sprite
{	
	// CLASS PROPERTIES	
	private static const WIDTH:int = 50, HEIGHT:int = 15;
	private static const TEXT_WIDTH:int = 85;
	
	// INSTANCE PROPERTIES
	private var high:Number, low:Number, ike:int;
	private var _color:int = 0x000000;
	private var textBox:TextField = new TextField();
	private var textFormat:TextFormat = new TextFormat();
	private var graphBackground:Shape = new Shape();
	private var plotLine:Shape = new Shape();
		
	// CONSTRUCTOR
	public function View(color:int):void
	{
		_color = color;
		
		// format textBox
		textFormat.size = 9;
		textFormat.font = "Monaco";
		textFormat.color = 0xFFFFFF;
		textBox.defaultTextFormat = textFormat;
		textBox.selectable = false;
		textBox.autoSize = TextFieldAutoSize.LEFT;
		textBox.x = WIDTH + 5;
		textBox.height = HEIGHT;
		
		// draw graphBackground
		graphBackground.graphics.beginFill(0x000000);
		graphBackground.graphics.drawRect(0, 0, WIDTH + TEXT_WIDTH, HEIGHT);
		graphBackground.graphics.endFill();
		graphBackground.graphics.lineStyle(0.5, 0x888888);
		graphBackground.graphics.drawRect(0, 0, WIDTH, HEIGHT - 1);
		
		plotLine.scaleX = WIDTH;
		plotLine.scaleY = HEIGHT;
		
		// add to display list
		addChild(graphBackground);
		addChild(plotLine);
		addChild(textBox);
	}
	
	// INTERNAL INSTANCE METHODS
	
	public function set text(value:String):void
	{
		textBox.text = value;
	}
	
	public function set color(value:int):void
	{
		_color = value;
	}
	
	internal function plot(history:Array):void
	{
		plotLine.graphics.clear();
		plotLine.graphics.lineStyle(2.5, _color, 1, true, LineScaleMode.NONE);
		high = 0, low = Infinity;

		// find the top and bottom extrema,
		for (ike = 0; ike < history.length; ike++)
		{
			if (high < history[ike]) 
			{
				high = history[ike];
			}
			
			if (low > history[ike]) 
			{
				low = history[ike];
			}
		}
		
		high -= low;
		
		// then plot the graph.
		plotLine.graphics.moveTo(0, 1 - (history[0] - low) / high);
		for (ike = 1; ike < history.length; ike++)
		{
			// I hate the math. I hate writing it out.
			plotLine.graphics.lineTo(ike / (history.length - 1), 1 - (history[ike] - low) / high);
		}
	}
}

/* Chaperone class
 * A token class for internal use
 */
 
internal class Chaperone{}
