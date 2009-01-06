package net.rezmason.engram {

	internal class AlertData {
		
		// INSTANCE PROPERTIES
		private var _title:String;
		private var _body:String;
		public var leftButtons:Array;
		public var rightButtons:Array;
		public var defaultYes:String;
		public var defaultNo:String;
		
		// CONSTRUCTOR
		public function AlertData(...args):void {
			title = args[0];
			body = args[1];
			leftButtons = args[2];
			rightButtons = args[3];
			defaultYes = args[4];
			defaultNo = args[5];
		}
		
		// GETTERS & SETTERS
		
		internal function get title():String {
			return _title;
		}
		
		internal function set title(value:String):void {
			_title = (value.length > 60 ? value.substr(0, 60) : value);
		}
		
		internal function get body():String {
			return _body;
		}
		
		internal function set body(value:String):void {
			_body = (value.length > 300 ? value.substr(0, 300) : value);
		}
		
		
	}
}

