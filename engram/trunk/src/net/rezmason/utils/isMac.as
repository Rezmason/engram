package net.rezmason.utils {
	
	import flash.system.Capabilities;
	
	/**
	*	Returns <code>true</code> if the currently running Flash instance
	*	is running on a Macintosh.
	*	
	*	@return	If the running Flash instance is running on a Macintosh,
	*	this value is <code>true</code>, otherwise <code>false</code>.
	*
	*/
	public function isMac():Boolean {
		return (Capabilities.os.indexOf("Mac") != -1);
	}
}