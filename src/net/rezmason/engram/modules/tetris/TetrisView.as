﻿package net.rezmason.engram.modules.tetris {		// IMPORT STATEMENTS	import flash.display.BitmapData;	import flash.display.BlendMode;	import flash.display.DisplayObject;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.Event;	import flash.filters.GlowFilter;	import flash.geom.Matrix;	import flash.geom.Point;		import gs.TweenLite;	import com.robertpenner.easing.Linear;	import com.robertpenner.easing.Quadratic;		import net.rezmason.engram.ModuleEvent;	import net.rezmason.engram.View;	import net.rezmason.display.Moment;		internal class TetrisView extends View {				// INSTANCE PROPERTIES		private const BLOCK_CLASSES:Array = [Block1, Block2, Block3, Block4, Block5, Block6, Block7, Ghost];		private const BLOCKS:Array = new Array;		private const LINE_CLEAR_SYMBOLS:Array = 		[			new StandaloneTSpin, 			new SingleIndicator, 			new DoubleIndicator, 			new TripleIndicator,		];		private const PURE_BLOCK_WIDTH:Number = 20;		private const PURE_BLOCK_OFFSET:Point = new Point(11, 11.5);		private const DUMB_POINT:Point = new Point;				private var blockWidth:Number;		private var blockOffset:Point;				private var _sweating:Boolean = false;		private var _beaming:Boolean = false;		private var _ghostEnabled:Boolean = true;		private var currentBlockInstance:DisplayObject;		private var currentBlockData:BitmapData;		private var board:BitmapData;		private var piece:BitmapData;		private var ghost:BitmapData;		private var boardCanvas:Shape = new Shape;		private var pieceCanvas:Shape = new Shape;		private var ghostCanvas:Shape = new Shape;		private var playground1:Sprite = new Sprite;		private var playground2:Sprite = new Sprite;		private var gameBoard:GameBoard = new GameBoard;		private var gameOverBoard:GameOverBoard = new GameOverBoard;		private var blapManager:BlapManager = new BlapManager;		private var holdDisplay:HoldDisplay = new HoldDisplay;		private var nextDisplay:NextDisplay = new NextDisplay;		private var boardTextTweenToObject:Object = {			ease:Quadratic.easeOut, 			delay:0, 			y:-20		};		private var freezeTweenToObject:Object = {			ease:Linear.easeNone, 			delay:0,			onUpdate:updateFreezing, 			onComplete:updateFreezing,			alpha:0		};		private var freezeTweenDuration:Number = 0.5;		private var freezeTweenObject:Object = {alpha:1};		private var freezeBlocks:Array = [new FreezeBlock, new FreezeBlock, new FreezeBlock, new FreezeBlock];		private var bangs:Array = [new Bang, new Bang, new Bang, new Bang];		private var lineClears:Array = [new LineClear, new LineClear, new LineClear];		private var tetrisClear:TetrisClear = new TetrisClear;		private var bravo:Bravo = new Bravo;		private var sweat:Sweat = new Sweat;		private var phew:Phew = new Phew;		private var beam:Beam = new Beam;		private var currentTwinkle:Twinkle;		private var twinkleContainer:Sprite = new Sprite;		private var boardText:BoardText = new BoardText;		private var tetrisScore:TetrisScore = new TetrisScore;		internal var _game:TetrisGame;		private var pieceCache:Array = new Array;		private var ghostCache:Array = new Array;		private var lastPieceNumber:int = -1, lastPieceAngle:int = -1;		private var pView:PixelView = new PixelView;		private var glow:GlowFilter = new GlowFilter(0xFFFFFF, 1, 6, 6, 5);				// CONSTRUCTOR		public function TetrisView(game:TetrisGame):void {			var ike:int;						_game = game;						resize();						nextDisplay.y = -20;			nextDisplay.x =  20 + gameBoard.width;			addColorChild(nextDisplay);			nextDisplay.init();						holdDisplay.y = -20;			holdDisplay.x = -20;			addColorChild(holdDisplay);			holdDisplay.init();						tetrisScore.y = gameBoard.height;						for (ike = 0; ike < freezeBlocks.length; ike += 1) {				playground2.addChild(freezeBlocks[ike]);				freezeBlocks[ike].visible = false;			}						for (ike = 0; ike < bangs.length; ike += 1) {				playground1.addChild(bangs[ike]);			}						addChild(holdDisplay);			addChild(nextDisplay);			addChild(boardText);			addChild(tetrisScore);			addChild(gameBoard);			addChild(playground1);			addChild(boardCanvas)			addChild(playground2);			addChild(ghostCanvas);			addChild(pieceCanvas);			addChild(twinkleContainer);			addChild(bravo);			addChild(sweat);			addChild(phew);			addChild(gameOverBoard);			addChild(blapManager);						holdDisplay.filters = [glow];			nextDisplay.filters = [glow];			boardText.filters = [glow];			tetrisScore.filters = [glow];			gameBoard.filters = [glow];			blapManager.filters = [glow];						playground1.addChild(beam);						addColorChild(gameBoard.back);			addColorChild(pieceCanvas, 1);			addColorChild(blapManager);			addColorChild(nextDisplay);			addColorChild(holdDisplay);						boardCanvas.blendMode = BlendMode.DARKEN;			nextDisplay.blendMode = BlendMode.LAYER;			holdDisplay.blendMode = BlendMode.LAYER;						playground2.addChild(tetrisClear);			tetrisClear.x = blockOffset.x;			tetrisClear.blendMode = BlendMode.HARDLIGHT;			blapManager.x = blockOffset.x;						for (ike = 0; ike < lineClears.length; ike += 1) {				playground2.addChild(lineClears[ike]);				lineClears[ike].x = blockOffset.x;			}						for (ike = 0; ike < LINE_CLEAR_SYMBOLS.length; ike += 1) {				playground2.addChild(LINE_CLEAR_SYMBOLS[ike]);				LINE_CLEAR_SYMBOLS[ike].x = 25 + gameBoard.width;			}						twinkleContainer.visible = false;			for (ike = 0; ike < 10; ike += 1) {				currentTwinkle = new Twinkle();				currentTwinkle.addEventListener(Event.COMPLETE, repositionTwinkle);				twinkleContainer.addChild(currentTwinkle);				currentTwinkle.stop();			}						pView.width = gameBoard.width;			pView.scaleY = pView.scaleX;			//addChild(pView);		}				// GETTERS & SETTERS				override public function get centerpiece():Object {			return gameBoard.border.getBounds(gameBoard.border);		}				public function get ghostEnabled():Boolean {			return _ghostEnabled;		}				public function set ghostEnabled(value:Boolean) {			if (value != _ghostEnabled) {				_ghostEnabled = value;				updatePiece();			}		}				// PUBLIC METHODS				override public function reset():void {						board.fillRect(board.rect, 0x000000);			piece.fillRect(piece.rect, 0x00000000);			ghost.fillRect(ghost.rect, 0x00000000);			boardText.y = 15;						nextDisplay.reset();			holdDisplay.reset();									stopSweat();			phew.stop();						gameOverBoard.stop();						resetFreezing();						tetrisScore.reset();		}		override public function resize(ratio:Number = 1):void {						var ike:int;			var mat:Matrix = new Matrix;						blockOffset = PURE_BLOCK_OFFSET.clone();			blockOffset.x *= ratio;			blockOffset.y *= ratio;			blockWidth = PURE_BLOCK_WIDTH * ratio;			mat.scale(ratio, ratio);						for (ike = 0; ike < BLOCK_CLASSES.length; ike += 1){				currentBlockInstance = new BLOCK_CLASSES[ike];				currentBlockData = new BitmapData(blockWidth, blockWidth, true, 0x00000000);				currentBlockData.draw(currentBlockInstance, mat);				BLOCKS[ike] = currentBlockData;			}						ike = 10 * PURE_BLOCK_WIDTH * ratio;						board = new BitmapData((ike - 1), (2 * ike - 1), true, 0x00000000);			boardCanvas.x = PURE_BLOCK_OFFSET.x, boardCanvas.y = PURE_BLOCK_OFFSET.y;			with (boardCanvas.graphics) {				clear();				beginBitmapFill(board, null, false);				drawRect(0, 0, ike - 1, 2 * ike - 1);				endFill();			}			boardCanvas.scaleX = boardCanvas.scaleY = 1 / ratio;						ike = 4 * PURE_BLOCK_WIDTH * ratio;						ghost = new BitmapData(ike, ike, true, 0x00000000);			with (ghostCanvas.graphics) {				clear();				beginBitmapFill(ghost, null, false);				drawRect(0, 0, ike, ike);				endFill();			}			ghostCanvas.scaleX = ghostCanvas.scaleY = 1 / ratio;						piece = new BitmapData(ike, ike, true, 0x00000000);			with (pieceCanvas.graphics) {				clear();				beginBitmapFill(piece, null, false);				drawRect(0, 0, ike, ike);				endFill();			}			pieceCanvas.scaleX = pieceCanvas.scaleY = 1 / ratio;						pieceCache = new Array;			ghostCache = new Array;			lastPieceNumber = -1;			lastPieceAngle = -1;						gameBoard.back.rerez(ratio);		}		// INTERNAL METHODS				internal function updateBoard(event:ModuleEvent = null):void {						pView.updateBoard(_game.grid);						var grid:Array = _game.grid;			var fullRows:Array = _game.fullRows;			var ike:int, jen:int, ken:int;			var destMatrix:Matrix = new Matrix;						board.fillRect(board.rect, 0x000000);			for (ike = 1; ike < grid.length - 2; ike += 1) {				if (fullRows.indexOf(grid.length - 1 - ike) != -1) {					continue;				}				for (jen = 1; jen < grid[ike].length - 1; jen += 1) {					ken = grid[ike][jen] - 3;					if (ken >= 0) {						currentBlockData = BLOCKS[ken];						destMatrix.tx = (jen - 1) * blockWidth;						destMatrix.ty = (grid.length - (ike + 3)) * blockWidth;						board.draw(currentBlockData, destMatrix);					}				}			}		}				internal function updatePiece(event:ModuleEvent = null):void {						pView.updatePiece(_game.currentPoints, _game.currentPiece, _game.index, _game.ghost);						var ike:int;			var pieceNumber:int = _game.currentPiece;			var pieceAngle:int = _game.currentAngle;			var points:Array = _game.currentPoints;			var indexPt:Point = _game.index;			var ghostPt:Point = _game.ghost;			var destPt:Point;						for (ike = 0; ike < freezeBlocks.length; ike += 1) {				freezeBlocks[ike].visible = false;			}						if (!_game.active) {				piece.fillRect(piece.rect, 0x00000000);				ghost.fillRect(ghost.rect, 0x00000000);				lastPieceNumber = -1;				lastPieceAngle = -1;				return;			}						pieceCanvas.x = (indexPt.x - 1) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.x;			pieceCanvas.y = (indexPt.y - 2) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.y;						twinkleContainer.x = (indexPt.x + (_game.currentAngle == 1 ? 1 : 0)) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.x - 1;			twinkleContainer.y = (indexPt.y - 2) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.y - 1;						ghostCanvas.x = (ghostPt.x - 1) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.x;			ghostCanvas.y = (ghostPt.y - 2) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.y;						for (ike = 0; ike < points.length; ike += 1) {				destPt = points[ike];								freezeBlocks[ike].visible = true;								bangs[ike].x = freezeBlocks[ike].x = pieceCanvas.x + destPt.x * PURE_BLOCK_WIDTH;				bangs[ike].y = freezeBlocks[ike].y = pieceCanvas.y + destPt.y * PURE_BLOCK_WIDTH;			}						if (pieceNumber == lastPieceNumber && pieceAngle == lastPieceAngle) {				return;			} else {				lastPieceNumber = pieceNumber;				lastPieceAngle = pieceAngle;			}						if (pieceCache[pieceNumber] == undefined || pieceCache[pieceNumber][pieceAngle] == undefined ) {				cachePiece(_ghostEnabled && !_beaming && indexPt.y != ghostPt.y);			} else {				piece.copyPixels(pieceCache[pieceNumber][pieceAngle], piece.rect, DUMB_POINT);				if (_ghostEnabled && !_beaming && indexPt.y != ghostPt.y) {					ghost.copyPixels(ghostCache[pieceNumber][pieceAngle], ghost.rect, DUMB_POINT);				} else {					ghost.fillRect(ghost.rect, 0x00000000);				}			}		}				internal function respondToScore(event:TetrisEvent, craziness:Boolean = true):void {			var fullRows:Array = _game.fullRows;			var ike:int;			var scratch:Number = 0;			var symbol:Moment;						if (event.worth == 4) {				blapManager.y = tetrisClear.y = (fullRows[0] - 2) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.y;				tetrisClear.play();				if (craziness) {					blapManager.showBlap();				}			} else {				symbol = LINE_CLEAR_SYMBOLS[fullRows.length];				if (fullRows.length) {					for (ike = 0; ike < fullRows.length; ike += 1) {						lineClears[ike].y = (fullRows[ike] - 2) * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.y;						scratch += lineClears[ike].y;						lineClears[ike].play();					}					scratch /= fullRows.length;									symbol.y = scratch - 30;				} else {					symbol.y = _game.index.y * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.y;				}				if (craziness) {					symbol.play();					if (event.tSpin) {						symbol.tSpin.play();					}				}			}			if (event.bravo && craziness) {				bravo.play();			}		}				internal function lose():void {			gameOverBoard.play();			stopSweat();			phew.stop();		}				internal function updateHoldDisplay(event:ModuleEvent = null):void {			holdDisplay.update(_game.holdPiece);		}				internal function matureHoldDisplay(event:ModuleEvent = null):void {			holdDisplay.mature();		}				internal function updateNextDisplay(event:ModuleEvent = null):void {			nextDisplay.update(_game.nextPieces);		}				internal function startFreezing(event:ModuleEvent = null, dur:Number = 0):void {			if (freezeTweenObject.alpha == 0 || freezeTweenObject.alpha == 1) {				TweenLite.killTweensOf(freezeTweenObject);				if (dur) {					freezeTweenDuration = dur;				}				TweenLite.to(freezeTweenObject, freezeTweenDuration, freezeTweenToObject);			}		}				internal function resetFreezing(event:Event = null):void {			var ike:int;			TweenLite.killTweensOf(freezeTweenObject);			freezeTweenObject.alpha = 1;						for (ike = 0; ike < freezeBlocks.length; ike += 1){				freezeBlocks[ike].alpha = freezeTweenObject.alpha;				freezeBlocks[ike].visible = false;			}		}				internal function setScore(value:int):void {			tetrisScore.setScore(value);		}				internal function startSweat(event:Event = null):void {			if (!_sweating) {				sweat.play();				_sweating = true;			}		}				internal function stopSweat(event:Event = null):void {			if (_sweating) {				sweat.stop();				phew.play();				_sweating = false;			}		}				internal function showBeam(event:TetrisEvent):void {			var ike:int;						if (!_beaming) {				_beaming = true;				beam.play();				beam.x = event.column * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.x;				beam.y = event.row * PURE_BLOCK_WIDTH + PURE_BLOCK_OFFSET.x;				twinkleContainer.visible = true;				for (ike = 0; ike < twinkleContainer.numChildren; ike += 1) {					currentTwinkle = twinkleContainer.getChildAt(ike) as Twinkle;					currentTwinkle.playRandom();				}			}		}				internal function hideBeam(event:Event = null):void {			var ike:int;						if (_beaming) {				_beaming = false;				beam.stop();				twinkleContainer.visible = false;				for (ike = 0; ike < twinkleContainer.numChildren; ike += 1) {					(twinkleContainer.getChildAt(ike) as Moment).stop();				}			}		}				internal function startBang():void {			var ike:int;			for (ike = 0; ike < bangs.length; ike += 1) {				bangs[ike].play();			}		}				internal function stopBang():void {			var ike:int;			for (ike = 0; ike < bangs.length; ike += 1) {				bangs[ike].stop();			}		}				internal function showBoardText():void {			TweenLite.to(boardText, 0.4, boardTextTweenToObject);		}				// PRIVATE METHODS				private function cachePiece(drawGhost:Boolean = true):void {			var pieceNumber:int = _game.currentPiece;			var pieceAngle:int = _game.currentAngle;			var points:Array = _game.currentPoints;			var destPt:Point, mat:Matrix = new Matrix;			var ike:int;						piece.fillRect(piece.rect, 0x00000000);			ghost.fillRect(ghost.rect, 0x00000000);			for (ike = 0; ike < points.length; ike += 1) {								destPt = points[ike];				mat.tx = destPt.x * blockWidth;				mat.ty = destPt.y * blockWidth;								currentBlockData = BLOCKS[BLOCKS.length - 1];				ghost.draw(currentBlockData, mat);								currentBlockData = BLOCKS[pieceNumber];				piece.draw(currentBlockData, mat);			}						if (pieceCache[pieceNumber] == undefined) {				pieceCache[pieceNumber] = new Array;				ghostCache[pieceNumber] = new Array;			}						pieceCache[pieceNumber][pieceAngle] = piece.clone();			ghostCache[pieceNumber][pieceAngle] = ghost.clone();						if (!drawGhost) {				ghost.fillRect(ghost.rect, 0x00000000);			}		}				private function updateFreezing(event:Event = null):void {			var ike:int;			for (ike = 0; ike < freezeBlocks.length; ike += 1){				freezeBlocks[ike].alpha = freezeTweenObject.alpha;			}		}				private function repositionTwinkle(event:Event):void {			currentTwinkle = event.currentTarget as Twinkle;			currentTwinkle.scaleX = currentTwinkle.scaleY = Math.random() * 0.8 + 0.2;			currentTwinkle.x = Math.random() * (PURE_BLOCK_WIDTH + 10) - 5;			currentTwinkle.y = Math.random() * (PURE_BLOCK_WIDTH * 4 + 10) - 5;			if (twinkleContainer.visible) {				currentTwinkle.play();			}		}	}}