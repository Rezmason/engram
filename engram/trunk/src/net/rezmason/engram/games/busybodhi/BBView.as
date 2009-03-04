﻿package net.rezmason.engram.games.busybodhi {		// IMPORT STATEMENTS	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Rectangle;		import com.robertpenner.easing.Quadratic;	import gs.TweenLite;		import net.rezmason.engram.modules.ModuleView;		internal final class BBView extends ModuleView {				internal static const UNIT:Number = 50;				// INSTANCE PROPERTIES		private var _crazy:Boolean;		private var _game:BBGame;		private var background:Sprite = new Sprite;		private var trackLayer:Sprite = new Sprite;		private var arrow:PointerArrow = new PointerArrow(), arrowPos:Number = 0;		private var tiles:Object = {}, tracks:Array = [];		private var _centerpiece:Rectangle;		private var comboDisplay:ComboDisplay = new ComboDisplay;		private var scoreboard:Scoreboard = new Scoreboard;				public function BBView(game:BBGame):void {						_game = game;						_centerpiece = new Rectangle(0, 0, BBGame.MAX_ALTITUDE * UNIT, BBGame.MAX_TRACKS * UNIT);						addChild(background);			addChild(scoreboard);			addChild(trackLayer);			addChild(arrow);			addChild(comboDisplay);			comboDisplay.x = centerpiece.width / 2;			comboDisplay.y = 200;			comboDisplay.scaleX = comboDisplay.scaleY = 3;						_game.addEventListener(BBEvent.TRACK_ADDED, makeTrackSprite);			_game.addEventListener(BBEvent.TRACK_REMOVED, killTrackSprite);			_game.addEventListener(BBEvent.TILES_TOUCHED, trace);			_game.addEventListener(BBEvent.TRACK_SETTLED, trace);			_game.addEventListener(BBEvent.TILE_ADDED, makeTileSprite);			_game.addEventListener(BBEvent.TILE_GONE, trace);			_game.addEventListener(BBEvent.TILE_CLEARED, clearTileSprite);			_game.addEventListener(BBEvent.TILE_MOVED, updateTileSprite);			_game.addEventListener(BBEvent.TILE_LIT, lightTileSprite);			_game.addEventListener(BBEvent.TURNING_POINT, trace);			_game.addEventListener(BBEvent.UPDATE_COMBO, updateComboGlyphs);			_game.addEventListener(BBEvent.CLEAR_COMBO, clearComboGlyphs);						trackLayer.x = 0;						//resize();		}				// GETTERS & SETTERS				override public function get centerpiece():Object {			return _centerpiece;		}				// PUBLIC METHODS				override public function reset():void {			tiles = {};			tracks = [];			_crazy = false;			trace("V", "resetting");		}		override public function resize(ratio:Number = 1):void {					}				// INTERNAL METHODS				internal function clearComboGlyphs(event:BBEvent):void {			comboDisplay.clear();		}				internal function goCrazy():void {			_crazy = true;			updateArrow();		}				internal function updateComboGlyphs(event:BBEvent = null):void {			comboDisplay.append(event.address);		}				internal function makeTrackSprite(event:BBEvent):void {			trace("V", "make track sprite", event.index);			var track:TrackSprite = new TrackSprite();			tracks[event.index] = track;			trackLayer.addChild(track);			track.y = event.index * 100;			track.land();			// place the track sprite			// push the other track sprites around		}				internal function killTrackSprite(event:BBEvent):void {			trace("V", "kill track sprite", event.index);			var track:TrackSprite = tracks[event.index];			track.addEventListener(Event.COMPLETE, removeDeadTrack, false, 0, true);			track.die();		}				internal function dissolveTracks(event:Event):void {			// blur and alpha out the track layer		}				internal function makeTileSprite(event:BBEvent):void {			trace("V", "make tile sprite", event.index, event.address);			var tile:TileSprite = makeNewTile(event.address);			tracks[event.index].addChild(tile);			tile.x = event.altitude * UNIT;			tile.y = event.shift * UNIT;			tile.appear();			tiles[event.address] = tile;			// place the tile sprite		}				internal function clearTileSprite(event:BBEvent):void {			comboDisplay.jump();			trace("V", "clear tile sprite", event.index, event.address);			var tile:TileSprite = tiles[event.address];			trace("tile sprites:");			trace(tiles[event.address], "#" + event.address + "#");			tiles[event.address] = undefined;			tile.addEventListener(Event.COMPLETE, removeDeadTile, false, 0, true);			tile.clear();		}				internal function updateTileSprite(event:BBEvent):void {			var tile:TileSprite = tiles[event.address];			tile.x = event.altitude * UNIT;			tile.y = event.shift * UNIT;		}				internal function lightTileSprite(event:BBEvent):void {			var tile:TileSprite = tiles[event.address];			tile.light(event.length);		}				internal function updateArrow():void {			var pointer:Number = _game.pointer;			if (!_crazy) {				TweenLite.killTweensOf(arrow);				arrowPos = tracks[pointer].y;				TweenLite.to(arrow, 0.1, {y:arrowPos, ease:Quadratic.easeOut});			}		}				// PRIVATE & PROTECTED METHODS				private function removeDeadTrack(event:Event):void {			trackLayer.removeChild(tracks[event.currentTarget] as TrackSprite);		}				private function removeDeadTile(event:Event):void {			trace("removing dead tile");			var tile:TileSprite = event.currentTarget as TileSprite;			tile.parent.removeChild(tile);		}				private function makeNewTile(combo:String):TileSprite {			// decide on which type of tile sprite to make			return new TileSprite(combo);		}	}}