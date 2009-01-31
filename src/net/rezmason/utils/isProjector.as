package net.rezmason.utils {
	
	// IMPORT STATEMENTS
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	/**
	*	Returns <code>true</code> if the currently running Flash instance
	*	is running in a Projector.
	*	
	*	@return	If the running Flash instance is in a Projector,
	*	this value is <code>true</code>, otherwise <code>false</code>.
	*
	*/
	public function isProjector():Boolean {
		return (Security.sandboxType != "application" && !ExternalInterface.available);
	}
}