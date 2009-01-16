package net.rezmason.engram.games.tetris {
	
	// IMPORT STATEMENTS
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	internal final class PixelView extends Sprite {
		
		// INSTANCE PROPERTIES
		private var ike:int, jen:int, hex:int;
		private var board:BitmapData;
		private var piece:BitmapData;
		private var boardShape:Shape = new Shape;
		private var pieceShape:Shape = new Shape;
		private var ghostShape:Shape = new Shape;
		
		
		public function PixelView():void {
			
			board = new BitmapData(12 + 1, 23 + 1, false);
			with (boardShape.graphics) {
				beginBitmapFill(board, null, false);
				drawRect(0, 0, board.width, board.height);
				endFill();
			}
			addChild(boardShape);
			
			piece = new BitmapData(4, 4, true, 0x00000000);
			
			with (pieceShape.graphics) {
				//lineStyle(0.2, 0xFF0000, 0.3);
				beginBitmapFill(piece, null, false);
				drawRect(0, 0, piece.width, piece.height);
				endFill();
				//drawEllipse(0, 0, 1, 1);
			}
			//pieceShape.blendMode = BlendMode.ADD;
			addChild(pieceShape);
			
			with (ghostShape.graphics) {
				//lineStyle(0.2, 0x00FF00, 0.3);
				beginBitmapFill(piece, null, false);
				drawRect(0, 0, piece.width, piece.height);
				endFill();
				//drawEllipse(0, 0, 1, 1);
			}
			//ghostShape.blendMode = BlendMode.ADD;
			ghostShape.alpha = 0.4;
			addChild(ghostShape);
			
			//scaleX = scaleY = 4;
		}
		
		// INTERNAL METHODS
		
		internal function reset():void {
			board.fillRect(board.rect, 0xFFFFFF);
			piece.fillRect(piece.rect, 0x00000000);
		}
		
		internal function updateBoard(grid:Array):void {
			
			board.fillRect(board.rect, 0xFFFFFF);
			
			for (ike = 0; ike < grid.length; ike += 1) {
				hex = 0xFF * (ike % 4) / 4;
				board.setPixel(0, ike + 1, hex << 16 | 0xFF - hex);
			}
			
			for (jen = 0; jen < grid[0].length; jen += 1) {
				hex = 0xFF * (jen % 4) / 4;
 				board.setPixel(jen + 1, 0, hex << 16 | (0xFF - hex) << 8);
			}
			
			for (ike = 0; ike < grid.length; ike += 1) {
				for (jen = 0; jen < grid[ike].length; jen += 1) {
					hex = tenToColor(grid[ike][jen] - 2);
					
					if (!hex && ike + 1 > grid.length - 2) {
						hex = 0x888888;
					}
					board.setPixel(jen + 1, grid.length - ike, hex);
				}
			}
		}
		
		internal function updatePiece(pts:Array = null, currentPiece:int = 0, index:Point = null, ghost:Point = null):void {
			
			if (!pts) {
				pieceShape.visible = false;
				ghostShape.visible = false;
				return;
			}
			pieceShape.visible = true;
			ghostShape.visible = true;
			
			piece.lock();
			
			piece.fillRect(piece.rect, 0x00000000);
			
			for (ike = 0; ike < pts.length; ike += 1) {
				piece.setPixel32(pts[ike].x, pts[ike].y, 0xFF << 24 |tenToColor(currentPiece + 1));
			}
			
			piece.unlock();
			
			pieceShape.x = index.x + 1, pieceShape.y = index.y + 1;
			
			ghostShape.x = ghost.x + 1, ghostShape.y = ghost.y + 1;
		}
		
		// PRIVATE METHODS
		
		private function tenToColor(b:int):uint {
			var hue:uint;
			if (b >= 0) {
				hue = b;
			}
			hue = 	
					((hue >> 2) & 1) * 0xFF << 16 |
				 	((hue >> 1) & 1) * 0xFF <<  8 | 
					((hue >> 0) & 1) * 0xFF <<  0;
			return hue;
		}
	}
}
