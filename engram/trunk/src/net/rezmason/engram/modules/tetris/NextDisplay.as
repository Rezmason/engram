﻿package net.rezmason.engram.modules.tetris {		// IMPORT STATEMENTS	import flash.display.Sprite;		import gs.TweenLite;	import com.robertpenner.easing.Quintic;	import net.rezmason.display.ColorSprite;		internal final class NextDisplay extends ColorSprite {				// INSTANCE PROPERTIES		private static const OFFSET:int = 64;		private const NEXT_PIECE_CLASSES:Array = [NextPiece0, NextPiece1, NextPiece2, NextPiece3, NextPiece4, NextPiece5, NextPiece6 ];				private const NEXT_PIECES:Array = new Array;				private var lastNextPieceArray:Array = [-1, -1, -1];		private var currentClass:Class;		private var container:Sprite = new Sprite;		private var nextSprite:Sprite, nextSprite2:Sprite, nextSprite3:Sprite;		private var tweenToObject:Object = {			ease:Quintic.easeInOut, 			delay:0, 			y:OFFSET.toString()		};				// CONSTRUCTOR		public function NextDisplay():void {			addChild(container);			addColorChild(container, 1);		}				// INTERNAL METHODS				internal function init():void {			var ike:int;						for (ike = 0; ike < NEXT_PIECE_CLASSES.length; ike += 1) {				currentClass = NEXT_PIECE_CLASSES[ike];				NEXT_PIECES[ike] = [new currentClass, new currentClass];			}		}				internal function reset():void {			if (nextSprite){				container.removeChild(nextSprite);				container.removeChild(nextSprite2);							container.removeChild(nextSprite3);				nextSprite = null;				nextSprite2 = null;				nextSprite3 = null;			}			lastNextPieceArray = [-1, -1, -1];		}				internal function update(nextPieceArray:Array):void {						var ike:int;						if (nextPieceArray[0] != lastNextPieceArray[0] || nextPieceArray[1] != lastNextPieceArray[1] || nextPieceArray[2] != lastNextPieceArray[2]) {				if (!nextSprite) {										nextSprite = NEXT_PIECES[nextPieceArray[0]].pop();					if (!nextSprite) {						nextSprite = new NEXT_PIECE_CLASSES[nextPieceArray[0]];					}										nextSprite.scaleX = nextSprite.scaleY = 1.8;					container.addChild(nextSprite);					nextSprite2 = NEXT_PIECES[nextPieceArray[1]].pop();					if (!nextSprite2) {						nextSprite2 = new NEXT_PIECE_CLASSES[nextPieceArray[1]];					}										nextSprite2.scaleX = nextSprite2.scaleY = 1.8;					nextSprite2.y = OFFSET;					container.addChild(nextSprite2);									} else {										container.removeChild(nextSprite);										for (ike = 0; ike < NEXT_PIECE_CLASSES.length; ike += 1) {						if (nextSprite is NEXT_PIECE_CLASSES[ike]) {							NEXT_PIECES[ike].push(nextSprite);						}					}										nextSprite = nextSprite2;					nextSprite.y = 0;					nextSprite2 = nextSprite3;					nextSprite2.y = OFFSET;				}					nextSprite3 = NEXT_PIECES[nextPieceArray[2]].pop();				if (!nextSprite3) {					nextSprite3 = new NEXT_PIECE_CLASSES[nextPieceArray[2]];				}				nextSprite3.scaleX = nextSprite3.scaleY = 1.8;				nextSprite3.y = 2 * OFFSET;				container.addChild(nextSprite3);				TweenLite.killTweensOf(this, true);				TweenLite.from(this, 0.4, tweenToObject);			}			lastNextPieceArray = nextPieceArray;		}	}}