﻿package net.rezmason.engram.games.busybodhi {	// IMPORT STATEMENTS	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.TimerEvent;	import flash.utils.Timer;	internal class Track extends EventDispatcher {				// CLASS PROPERTIES		internal static const MAX_ALTITUDE:int = 12, MAX_SPEED:int = 100;		private static const MIN_COMBO_SIZE:int = 2, MAX_COMBO_SIZE:int = 8;				// INSTANCE PROPERTIES		private var tree:ComboNode = ComboNode.plantTree(), footing:ComboNode;		private var nodes:Object = {};		private var _tiles:Array = [], _tilesByAddress:Object = {}, _numTiles:int = 0;		private var primaryTile:Tile, currentTile:Tile;		private var _speed:Number = 4;		private var _difficultyLevel:int = 2;		private var _stackable:Boolean;		private var _full:Boolean;		private var addressSizeCap:int = MIN_COMBO_SIZE;		private var contents:int = 0;		private var height:int = 0;		private var _tilesTouched:Boolean = false;		private var newTileTimer:Timer = new Timer(1000, 1);				public function Track(stackable:Boolean = true) {			_stackable = stackable;			fall();			newTileTimer.addEventListener(TimerEvent.TIMER_COMPLETE, relay);			addTileSoon();		}				internal function addTileSoon():void {			if (!newTileTimer.running) {				newTileTimer.delay = 6000 / speed;				newTileTimer.start();			}		}				private function relay(event:Event):void {			dispatchEvent(event);		}				internal function addTile(event:Event = null, length:int = 0):Tile {			var address:String = addCombo(length || goodLength());			var returnVal:Tile = null;			if (address) {				returnVal = primaryTile = new Tile();				primaryTile.altitude = MAX_ALTITUDE;				primaryTile.size = address.length;				primaryTile.address = address;				_tiles.push(primaryTile);				_tilesByAddress[address] = primaryTile;				contents += address.length;				_numTiles++;			}			return returnVal;		}				internal function removeTile(pattern:String, duration:int = -1):Boolean {			var success:Boolean;						if (pattern == footing.address) {				fall();			}						success = removeCombo(pattern);						if (success) {				var tile:Tile = _tilesByAddress[pattern];				_tiles.splice(_tiles.indexOf(tile), 1);				_tilesByAddress[pattern] = undefined;				contents -= pattern.length;				_numTiles--;				if (primaryTile && primaryTile == tile) {					primaryTile = null;					addTileSoon();				}				if (duration != -1) {					_difficultyLevel; // adjust difficulty					_speed = speed * 0.8 + 1000 * 0.3 / duration; // adjust falling speed				}			}			return success;		}				internal function get numTiles():int {			return _numTiles;		}				private function addCombo(length:int):String {			var node:ComboNode = tree.add(length);			if (node) {				nodes[node.address] = node;				return node.address;			}			return null;		}				private function removeCombo(address:String):Boolean {			if (nodes[address]) {				if (nodes[address].removeLeaf()) {					nodes[address] = undefined;					return true;				}			}			return false;		}				internal function get difficultyLevel():int {			return _difficultyLevel;		}				internal function get tiles():Array {			return _tiles.slice();		}				internal function fall():void {			footing = tree;			height++;		}				internal function climb(key:String):Boolean {			for (var ike:int = 0; ike < key.length; ike++) {				footing = footing[key.charAt(ike)];				if (!footing || (!footing.numKids && !footing.isLeaf)) {					fall();					return false;				} else {					height++;				}			}			return true;		}				internal function foundMatch():Boolean {			return footing.isLeaf;		}				internal function get partialMatches():Array {			var leaves:Array = footing.allLeaves();			for (var ike:int = 0; ike < leaves.length; ike++) {				leaves[ike] = leaves[ike].address;			}			return leaves;		}				internal function clear():void {			tree.clear();			newTileTimer.stop();		}				internal function get settled():Boolean {			return (primaryTile == null);		}				internal function get tilesTouched():Boolean {			return _tilesTouched;		}				internal function get full():Boolean {			return _full;		}				internal function get speed():int {			return _speed;		}				internal function get currentAddress():String {			return footing.address;		}				internal function updateTiles():Array {			var stackHeight:Number = 0;			var slippedTiles:Array = [];			_tilesTouched = false;			for (var ike:int = 0; ike < _tiles.length; ike++) {				var tile:Tile = _tiles[ike];				if (_stackable && tile.altitude - _speed / MAX_SPEED <= stackHeight) {					if (tile.altitude != stackHeight) {						tile.altitude = stackHeight;						_tilesTouched = true;						}					stackHeight += tile.size;					if (tile == primaryTile) {						primaryTile = null;						addTileSoon();					}				} else {					tile.altitude -= _speed / MAX_SPEED;					if (-tile.altitude > tile.size) {						slippedTiles.push(tile.address);						tile.outSpeed = _speed;						removeTile(tile.address);					}				}			}			if (stackHeight >= MAX_ALTITUDE) {				_full = true;			}			return slippedTiles;		}				internal function spew():void {			var spew:Array = tree.allLeaves();			trace("leaves:");			for (var ike:int = 0; ike < spew.length; ike++) {				trace(ike + ":(" + spew[ike].address + ")");			}			trace("_tiles:");			for (ike = 0; ike < _tiles.length; ike++) {				trace(_tiles[ike]);			}		}				private function goodLength():int {			var max:int = Math.min(addressSizeCap, MAX_ALTITUDE - contents) - MIN_COMBO_SIZE;			return MIN_COMBO_SIZE + int(Math.random() * max);		}	}}internal class ComboNode {		// CLASS PROPERTIES	private static var unusedNodes:Array = [];		// INSTANCE PROPERTIES		internal var isLeaf:Boolean = false;	internal var index:String = "";	internal var address:String = "";	internal var parentNode:ComboNode;	internal var rootNode:ComboNode;	internal var a:ComboNode, b:ComboNode, x:ComboNode, y:ComboNode;	internal var availableSlots:Array = [1];	internal var numKids:int = 0;	private var kid:ComboNode, kidNames:Array = ["a", "b", "x", "y"], hat:Array = [];	private var ike:int;		internal function clear():void {		for (ike = 0; ike < 4; ike++) {			kid = this[kidNames[ike]] as ComboNode;			if (kid != null) {				kid.clear();				this[kidNames[ike]] = null;			}		}		isLeaf = false;		index = "";		address = "";		availableSlots = [1];		numKids = 0;		hat = [];		if (rootNode != this) {			parentNode = null;			rootNode = null;			unusedNodes.push(this);		}	}		internal function find(address:String, complete:Boolean = false):Array {		if (address.length) {			kid = this[address.charAt(0)];			if (kid != null) {				return kid.find(address.substr(1), complete);			}			return [];		}				if (complete) {			return isLeaf ? [] : [address];		}		return allLeaves();	}		internal function allLeaves():Array {		var returnVal:Array = [];		if (!isLeaf) {			for (ike = 0; ike < 4; ike++) {				kid = this[kidNames[ike]] as ComboNode;				if (kid != null) {					returnVal.push.apply(null, kid.allLeaves());				}			}		} else if (this != rootNode) {			returnVal = [this];		}		return returnVal;	}		internal function add(level:int):ComboNode {		// if the level is zero,		if (level == 0) {			// this is the new leaf			isLeaf = true;			return this;		}		// otherwise,		// reset the current names, if it's empty		var sum:int = 0;		for (ike = 0; ike < hat.length; ike++) {			if (this[hat[ike]]) {				sum += this[hat[ike]].availableSlots[level - 1];			} else {				sum += Math.pow(4, level - 1);			}		}				if (!hat.length || !sum) {			hat = kidNames.slice();		}		var probs:Array = new Array(hat.length);		var total:int = 0;		// weight the four child nodes		for (ike = 0; ike < probs.length; ike++) {			kid = this[hat[ike]] as ComboNode;			if (kid != null) {				// weight = number of empty slots under node of depth level - 1				if (kid.availableSlots[level - 1] == undefined) {					kid.availableSlots[level - 1] = Math.pow(4, level - 1);				}				probs[ike] = kid.availableSlots[level - 1];			} else {					probs[ike] = Math.pow(4, level - 1);			}			total += probs[ike];		}		// pick a node randomly		var rand:Number = Math.random() * total;		for (ike = 0; ike < hat.length; ike++) {			if (rand < probs[ike]) {				kid = this[hat[ike]];				break;			}			rand -= probs[ike];		}		//Assert: if you didn't pick any of the four,		if (ike == 4) {			// you are full and you are the root node OR there is an error			return null;		}		// if the chosen node doesn't exist,		var node:ComboNode = this, nodeIndex:int = 1;		if (kid == null) {			// make a new child node			kid = this[hat[ike]] = makeNode(this);			kid.index = hat[ike];			kid.address = address + kid.index;			node = kid, nodeIndex = 0;		}		kid.parentNode = this;		kid.rootNode = rootNode;				while (node != rootNode) {			if (node.availableSlots[nodeIndex] == undefined) {				node.availableSlots[nodeIndex] = Math.pow(4, nodeIndex);			}			node.availableSlots[nodeIndex]--;			nodeIndex++;			node = node.parentNode;		}				hat.splice(ike, 1);		// chosen node . add(level - 1)		kid = kid.add(level - 1);		if (kid) {			numKids++;		}				return kid;	}		internal function removeLeaf():Boolean {		if (!isLeaf) {			return false;		}		isLeaf = false;				var parent:ComboNode = parentNode;		while (!--parent.numKids) {			parent = parent.parentNode;		}				var node:ComboNode = this, nodeIndex:int = 0;		while (node != rootNode) {			node.availableSlots[nodeIndex]++;			nodeIndex++;			node = node.parentNode;		}				hat = [];		parentNode = null;		rootNode = null;				return true;	}		internal static function plantTree():ComboNode {		var seed:ComboNode = makeNode(null);		seed.index = "R";		return seed;	}		internal static function makeNode(parentNode:ComboNode = null):ComboNode {		var node:ComboNode = (unusedNodes.length ? unusedNodes.shift() : (new ComboNode()));		node.parentNode = parentNode || node;		node.rootNode = node.parentNode.rootNode || node;				node.isLeaf = false;		node.index = "";		node.address = "";		node.availableSlots = [1];		node.numKids = 0;		node.hat = [];				return node;	}		public function toString():String {		return ("•" + address) as String;	}}