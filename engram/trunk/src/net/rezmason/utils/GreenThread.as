﻿package net.rezmason.utils {		import flash.display.Shape;	import flash.events.Event;	import flash.events.ErrorEvent;	import flash.events.EventDispatcher;	import flash.utils.Timer;		/**	* 	A green tread is a virtual thread. Real threads	*	are proceses that run concurrently and independently	*	on a processor. Asynchronous languages such as ActionScript	*	do not support true threads.	*	<p>Green threads differ from normal threads by relying on	*	asynchronous events instead of the processor	*	to run "concurrently". A <code>GreenThread</code> is an 	*	object that represents a concurrent process, and the	*	elements of that process that occur before, while and after	*	certain conditions are met. A <code>GreenThread</code> may	*	not be your fastest option for running code concurrently,	*	but it is guaranteed to complete.</p>	* 	*	@author Jeremy Sachs	*	@langversion	ActionScript 3.0	*	@playerversion	Flash 9	*	@tiptext	*/	public class GreenThread extends EventDispatcher {				private static var idCount:uint = 0;		private static const COMPLETE_EVENT:Event = new Event(Event.COMPLETE);		private static const ERROR_EVENT:ErrorEvent = new ErrorEvent("GreenThreadError", false, false);		private static var masterShape:Shape;				private var timer:Timer = new Timer(0), dispatcher:EventDispatcher;		private var _eventType:String;		private var _delay:int;		private var _id:uint;		private var _interrupted:Boolean = false;		private var _state:int;		private var _skip:int = 0;		/**		*	A fragment of the task to be completed.		*/		public var taskFragment:Function;		/**		*	A function that returns <code>true</code> if		*	the task is complete, and <code>false</code> otherwise.		*/		public var condition:Function;		/**		*	A function that is called when the thread begins.		*/		public var prologue:Function;		/**		*	A function that is called when the thread is interrupted.		*/		public var interruptHandler:Function;		/**		*	A function that is called when the thread finishes.		*/		public var epilogue:Function;		/**		*	The name of the thread.		*/		public var name:String;				/**		* Creates a new GreenThread instance.		*			*	@param	frag	 A fragment of the task to be completed.		*	@param	cond	 A function that returns <code>true</code> if		*	the task is complete, and <code>false</code> otherwise.		*/		public function GreenThread(frag:Function = null, cond:Function = null):void {						taskFragment = frag;			condition = cond;						_id = idCount++;			_state = _State.NEW;			name = "GreenThread_#" + _id;		}				// GETTERS & SETTERS				/**		*	The current operating state of the thread.		*/		public function get state():int {			return _state;		}				/**		*	@private		*/		public static function get State():Class {			return _State;		}				/**		*	The type of event with which to drive the thread.		*/		public function get eventType():String {			return _eventType;		}				/**		*	@private		*/		public function set eventType(value:String):void {						if (value && value == _eventType) {				return;			}						if (dispatcher && _eventType) {				dispatcher.removeEventListener(_eventType, run);				if (dispatcher == timer) {					timer.stop();				}			}						_eventType = value;						switch (_eventType) {				case "enterFrame":				case "exitFrame":				case "render":				case "frameConstructed":					masterShape ||= new Shape;					dispatcher = masterShape;					break;				case "timer":				default:					_eventType = "timer";										if (!_delay && timer.delay != _delay) {						timer = new Timer(0);					} else {						timer.delay = _delay;					}										if (running) {						timer.start();					}										dispatcher = timer;										break;			}								dispatcher.addEventListener(_eventType, run);		}				/**		*	The number of milliseconds between the events		*	which cause the thread to run.		*/		public function get delay():int {			return _delay;		}				/**		*	@private		*/		public function set delay(value:int):void {						if (_delay == value) {				return;			}						_delay = (value >= 0) ? value : 0;						if (_eventType) {				eventType = _eventType;			}		}				/**		*	The unique ID of the thread.		*/		public function get id():uint {			return _id;		}				/**		*	Indicates whether the thread		*	has been interrupted.		*/		public function get interrupted():Boolean {			return _interrupted;		}				/**		*	Indicates whether the thread		*	is in the middle of a process.		*/		public function get alive():Boolean {			return (_state != _State.TERMINATED && _state != _State.NEW);		}				/**		*	Indicates whether the thread is		*	paused.		*/		public function get waiting():Boolean {			return (_state == _State.WAITING || _state == _State.TIMED_WAITING);		}				/**		*	Indicates whether the thread is running.		*/		public function get running():Boolean {			return _state == _State.RUNNING;		}				/**		*	Returns a string containing notable 		*	properties of the GreenThread object.		*	<p>The string is in the following format:</p>		*	<p>[GreenThread name=<i>name</i>]</p>		*/		override public function toString():String {			return "[GreenThread name=\"" + name + "\"]";		}				// PUBLIC METHODS				/**		*	Starts the thread.		*			*/		public function start():void {						if (!alive) {								if (taskFragment == null) {					ERROR_EVENT.text = name + " cannot start, because it has not been assigned a task fragment.";					dispatchEvent(ERROR_EVENT);				}								if (prologue != null) {					prologue();				}				_state = _State.RUNNING;								if (dispatcher == timer) {					timer.reset();					timer.start();				}			} else {				ERROR_EVENT.text = name + " cannot start, because it is already alive.";				dispatchEvent(ERROR_EVENT);			}		}				/**		*	Pauses the thread until it receives a signal to continue.		*			*	@param	otherProcess	 An EventDispatcher that will signal		*	the thread to continue. If unspecified, the thread is simply suspended.		*	@param	etype	The type of Event the thread will wait for the		*	<code>otherProcess</code> to dispatch.		*			*/		public function wait(otherProcess:EventDispatcher = null, etype:String = Event.COMPLETE):void {			if (alive) {				if (!otherProcess) {					suspend();				} else {					_skip = 0;					_state = _State.WAITING;					if (dispatcher == timer) {						timer.stop();					}					otherProcess.addEventListener(etype, function(event:Event):void {						_state = _State.RUNNING;						if (dispatcher == timer) {							timer.start();						}					});				}			} else {				ERROR_EVENT.text = name + " cannot wait, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				/**		*	Terimates the thread before it is finished and		*	throws an error.		*/		public function interrupt():void {			if (alive) {				_interrupted = true;				_skip = 0;				_state = _State.TERMINATED;				if (dispatcher == timer) {					timer.stop();				}				if (interruptHandler != null) {					interruptHandler();				} else {					ERROR_EVENT.text = name + " was interrupted.";					dispatchEvent(ERROR_EVENT);				}				} else {				ERROR_EVENT.text = name + " cannot be interrupted, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				/**		*	Pauses the thread for a specified amount of time.		*			*	@param	ticks	 The number of times the thread		*	should ignore its underlying event.		*			*/		public function sleep(ticks:uint = 0):void {						if (alive) {				if (ticks <= 0) {					suspend();				} else {					_state = _State.TIMED_WAITING;					_skip = ticks;					if (dispatcher == timer) {						timer.stop();					}				}			} else {				ERROR_EVENT.text = name + " cannot sleep, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				/**		*	Pauses the thread indefinitely.		*			*/		public function suspend():void {			if (alive) {				_skip = 0;				_state = _State.WAITING;				if (dispatcher == timer) {					timer.stop();				}			} else {				ERROR_EVENT.text = name + " cannot be suspended, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				/**		*	Unpauses the thread if it is asleep or paused.		*			*/		public function resume():void {			if (waiting) {				_state = _State.RUNNING;				if (dispatcher == timer) {					timer.start();				}			} else {				ERROR_EVENT.text = name + " cannot resume, because it is not waiting.";				dispatchEvent(ERROR_EVENT);			}		}				// PRIVATE & PROTECTED METHODS				protected function run(event:Event = null):void {						if (alive) {				if (condition == null || condition() == true) {					if (_state == _State.TIMED_WAITING) {						if (!--_skip) {							_state = _State.RUNNING;							if (dispatcher == timer) {								timer.start();							}						}					} else if (_state == _State.RUNNING) {						taskFragment();						}				} else {					_state = _State.TERMINATED;					if (dispatcher == timer) {						timer.stop();					}					if (epilogue != null) {						epilogue();					}					dispatchEvent(COMPLETE_EVENT);				}			}		}	}}class _State {		public static const NEW:int = 0, RUNNING:int = 1, WAITING:int = 2, TIMED_WAITING:int = 3, TERMINATED:int = 4;	}