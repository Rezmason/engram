package net.rezmason.utils {
	
	import flash.system.Capabilities;
	
	public function isMac():Boolean {
		return (Capabilities.os.indexOf("Mac") != -1);
	}
}