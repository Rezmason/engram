﻿package net.rezmason.utils {		import flash.display.Shape;	import flash.events.Event;	import flash.events.ErrorEvent;	import flash.events.EventDispatcher;	import flash.utils.Timer;		public class GreenThread extends EventDispatcher {				private static var idCount:uint = 0;		private static const COMPLETE_EVENT:Event = new Event(Event.COMPLETE);		private static const ERROR_EVENT:ErrorEvent = new ErrorEvent("GreenThreadError", false, false);		private static var masterShape:Shape;				private var timer:Timer = new Timer(0), dispatcher:EventDispatcher;		private var _eventType:String;		private var _delay:int;		private var _id:uint;		private var _interrupted:Boolean = false;		private var _state:int;		private var _skip:int = 0;				public var taskFragment:Function;		public var condition:Function;		public var prologue:Function;		public var interruptHandler:Function;		public var epilogue:Function;		public var name:String;						public function GreenThread(frag:Function = null, cond:Function = null):void {						taskFragment = frag;			condition = cond;						_id = idCount++;			_state = _State.NEW;			name = "GreenThread_#" + _id;		}				public function start():void {						if (!alive) {								if (taskFragment == null) {					ERROR_EVENT.text = name + " cannot start, because it has not been assigned a task fragment.";					dispatchEvent(ERROR_EVENT);				}								if (prologue != null) {					prologue();				}				_state = _State.RUNNING;								if (dispatcher == timer) {					timer.reset();					timer.start();				}			} else {				ERROR_EVENT.text = name + " cannot start, because it is already alive.";				dispatchEvent(ERROR_EVENT);			}		}				public function wait(otherProcess:EventDispatcher = null, etype:String = Event.COMPLETE):void {			if (alive) {				if (!otherProcess) {					suspend();				} else {					_skip = 0;					_state = _State.WAITING;					if (dispatcher == timer) {						timer.stop();					}					otherProcess.addEventListener(etype, function(event:Event):void {						_state = _State.RUNNING;						if (dispatcher == timer) {							timer.start();						}					});				}			} else {				ERROR_EVENT.text = name + " cannot wait, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				public function interrupt():void {			if (alive) {				_interrupted = true;				_skip = 0;				_state = _State.TERMINATED;				if (dispatcher == timer) {					timer.stop();				}				if (interruptHandler != null) {					interruptHandler();				} else {					ERROR_EVENT.text = name + " was interrupted.";					dispatchEvent(ERROR_EVENT);				}				} else {				ERROR_EVENT.text = name + " cannot be interrupted, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				public function sleep(ticks:uint = 0):void {						if (alive) {				if (ticks <= 0) {					suspend();				} else {					_state = _State.TIMED_WAITING;					_skip = ticks;					if (dispatcher == timer) {						timer.stop();					}				}			} else {				ERROR_EVENT.text = name + " cannot sleep, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				public function suspend():void {			if (alive) {				_skip = 0;				_state = _State.WAITING;				if (dispatcher == timer) {					timer.stop();				}			} else {				ERROR_EVENT.text = name + " cannot be suspended, because it is not alive.";				dispatchEvent(ERROR_EVENT);			}		}				public function resume():void {			if (waiting) {				_state = _State.RUNNING;				if (dispatcher == timer) {					timer.start();				}			} else {				ERROR_EVENT.text = name + " cannot resume, because it is not waiting.";				dispatchEvent(ERROR_EVENT);			}		}				protected function run(event:Event = null):void {						if (alive) {				if (condition == null || condition() == true) {					if (_state == _State.TIMED_WAITING) {						if (!--_skip) {							_state = _State.RUNNING;							if (dispatcher == timer) {								timer.start();							}						}					} else if (_state == _State.RUNNING) {						taskFragment();						}				} else {					_state = _State.TERMINATED;					if (dispatcher == timer) {						timer.stop();					}					if (epilogue != null) {						epilogue();					}					dispatchEvent(COMPLETE_EVENT);				}			}		}				// GETTERS & SETTERS				public function get state():int {			return _state;		}				public static function get State():Class {			return _State;		}				public function get eventType():String {			return _eventType;		}				public function set eventType(value:String):void {						if (value && value == _eventType) {				return;			}						if (dispatcher && _eventType) {				dispatcher.removeEventListener(_eventType, run);				if (dispatcher == timer) {					timer.stop();				}			}						_eventType = value;						switch (_eventType) {				case "enterFrame":				case "exitFrame":				case "render":				case "frameConstructed":					masterShape ||= new Shape;					dispatcher = masterShape;					break;				case "timer":				default:					_eventType = "timer";										if (!_delay && timer.delay != _delay) {						timer = new Timer(0);					} else {						timer.delay = _delay;					}										if (running) {						timer.start();					}										dispatcher = timer;										break;			}								dispatcher.addEventListener(_eventType, run);		}				public function get delay():int {			return _delay;		}				public function set delay(value:int):void {						if (_delay == value) {				return;			}						_delay = (value >= 0) ? value : 0;						if (_eventType) {				eventType = _eventType;			}		}				public function get id():uint {			return _id;		}				public function get interrupted():Boolean {			return _interrupted;		}				public function get alive():Boolean {			return (_state != _State.TERMINATED && _state != _State.NEW);		}				public function get waiting():Boolean {			return (_state == _State.WAITING || _state == _State.TIMED_WAITING);		}				public function get running():Boolean {			return _state == _State.RUNNING;		}				override public function toString():String {			return "[GreenThread \"" + name + "\"]";		}	}}class _State {		public static const NEW:int = 0, RUNNING:int = 1, WAITING:int = 2, TIMED_WAITING:int = 3, TERMINATED:int = 4;	}