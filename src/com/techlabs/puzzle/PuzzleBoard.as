package com.techlabs.puzzle {

	import com.techlabs.puzzle.events.PuzzleEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import CajaNormal;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;

	/**
	 * ...
	 * @author Timo Virtanen
	 */
	public class PuzzleBoard extends ObjectContainer3D {
		
		private var _boardWidth:int;
		private var _boardHeight:int;

		private var _pieceWidth:Number;
		private var _pieceHeight:Number;

		private var _padding:int;
		private var _moving:Boolean;
		
		private static var _instance:PuzzleBoard;

		public  var _pieces:Array = new Array();

		public function PuzzleBoard() {
			_boardWidth = CajaNormal.size + CajaNormal.padding * CajaNormal.subdivisions;
			_boardHeight = CajaNormal.size + CajaNormal.padding * CajaNormal.subdivisions;
			_pieceWidth = CajaNormal.size / CajaNormal.subdivisions;
			_pieceHeight = CajaNormal.size / CajaNormal.subdivisions;

			_padding = CajaNormal.padding;
		}

		public function createPuzzle(images:Array):void {
			clearBoard();

			var pieceCount:int = 0;
			var lastPiece:int = CajaNormal.subdivisions * CajaNormal.subdivisions;

			for(var yp:int = 0; yp < CajaNormal.subdivisions; yp++) {
				for(var xp:int = 0; xp < CajaNormal.subdivisions; xp++) {
					if (++pieceCount == lastPiece)
						break;
					var image:Bitmap = images[yp][xp];
					var piece:PuzzlePiece = new PuzzlePiece(image, {width:_pieceWidth, height:_pieceHeight, segmentsH:3, segmentsW:3});
					piece.Identidad=yp+","+xp;
					piece.addEventListener(PuzzleEvent.CLICK, clickHandler);
					piece.addEventListener("mouseDown", MouseOver);

					piece.addEventListener(PuzzleEvent.MOVE, moveHandler);
					piece.addEventListener(PuzzleEvent.READY, moveHandler);

					piece.x = xp * _pieceWidth + xp * _padding;
					piece.z = -(yp * _pieceHeight + yp * _padding);

					addChild(piece);
					_pieces.push(piece);
				}
			}
			centerBoard();
		}
		
		private function MouseOver(e:MouseEvent3D):void{
		
			trace("hola");
		
		}
		
	

		public function shuffle():void {
			var p:PuzzlePiece;
			var direction:int;
			for(var i:int = 0; i < 200; i++) {
				do {
					p = _pieces[int(Math.random() * _pieces.length - 1)];
					direction = checkNeighbours(p);
				} while(direction == -1);
				p.move(direction, false);
			}
		}

		private function clickHandler(e:PuzzleEvent):void {
			trace("click");
			if (_moving)
				return ;
			var direction:int = checkNeighbours(e.piece);
			if (direction > 0) {
				e.piece.move(direction);
			}
		}

		private function moveHandler(e:PuzzleEvent):void {
			if (e.type == PuzzleEvent.MOVE)
				_moving = true;
			else if (e.type == PuzzleEvent.READY)
				_moving = false;
		}

		private function checkNeighbours(piece:PuzzlePiece):int {
			var empty:Boolean;

			// LEFT
			if (piece.x > 0) {
				empty = isEmptySpace(piece.x - _pieceWidth - _padding, piece.z);
				if (empty)
					return PuzzlePiece.LEFT;
			}

			// RIGHT
			if (piece.x < _boardWidth - _pieceWidth - _padding) {
				empty = isEmptySpace(piece.x + _pieceWidth + _padding, piece.z);
				if (empty)
					return PuzzlePiece.RIGHT;
			}

			// DOWN
			if (piece.z < 0) {
				empty = isEmptySpace(piece.x, piece.z + _pieceHeight + _padding);
				if (empty)
					return PuzzlePiece.UP;
			}

			// UP
			if (piece.z > -_boardHeight + _pieceHeight + _padding) {
				empty = isEmptySpace(piece.x, piece.z - _pieceHeight - _padding);
				if (empty)
					return PuzzlePiece.DOWN;
			}
			
			return -1;
		}

		private function isEmptySpace(xp:int, zp:int):Boolean {
			for each(var p:PuzzlePiece in _pieces) {
				if (p.x == xp) {
					if (p.z == zp) {
						return false;
					}
				}
			}
			return true;
		}

		private function clearBoard():void {
			for each(var p:PuzzlePiece in _pieces) {
				p.removeEventListener(PuzzleEvent.CLICK, clickHandler);
				p.removeEventListener(PuzzleEvent.MOVE, moveHandler);
				p.removeEventListener(PuzzleEvent.READY, moveHandler)
				removeChild(p);
			}
			_pieces = new Array();
		}

		private function centerBoard():void {
			x = -(_boardWidth * .5 - _pieceWidth * .5);
			z = _boardHeight * .5 - _pieceHeight * .5;
		}

		public function getPieces():Array{
		return _pieces;
		}
		
	}

}
