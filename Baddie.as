﻿import net.rezmason.engram.*;/*--toggletrace("Bad Man: I'm a bad man!");if (stage) {	beginAttack(null);} else {	addEventListener("addedToStage", beginAttack);	}var stg, main:DisplayObjectContainer, loader, module, guard;var scope = 0, maxScope;function beginAttack(event) {	stg = stage;	addEventListener("enterFrame", update);	//addEventListener("enterFrame", planB);}function update(event) {	try {		if (!main) {			for (var i = 0; i < stg.numChildren; i++) {				if (stg.getChildAt(i) is Main) {					main = stg.getChildAt(i) as DisplayObjectContainer;					trace("Bad Man: I've got the Main class, now!")					break;				}			}		} else if (!loader) {			scope = maxScope = 0;			loader = findLoader(main);		} else if (!module) {			module = loader.content;		} else {			trace("Bad Man: I've got the module!");					removeEventListener("enterFrame", update);		}	} catch (error) {		trace("Bad Man: Drat, I've been stopped!");		removeEventListener("enterFrame", update);	}}function planB(event) {	try {		if (!guard) {			for (var i = 0; i < stg.numChildren; i++) {				if (stg.getChildAt(i) is Guard) {					guard = stg.getChildAt(i) as DisplayObjectContainer;					trace("Bad Man: I've got the Guard class, now!")					stg.removeChild(guard);					break;				}			}		}	} catch (error) {		trace("Bad Man: Drat, I've been stopped!");		removeEventListener("enterFrame", update);	}}function findLoader(target:DisplayObjectContainer):Loader {	scope++;	maxScope = Math.max(maxScope, scope);	var returnVal:Loader = null;	var child:DisplayObject;	for (var i = 0; i < target.numChildren; i++) {		child = target.getChildAt(i);		if (child is Loader) {			returnVal = child as Loader;		} else if (child is DisplayObjectContainer) {			returnVal = findLoader(child as DisplayObjectContainer);		}		if (returnVal is Loader) {			break;		}	}	scope--;	return returnVal;}/**/