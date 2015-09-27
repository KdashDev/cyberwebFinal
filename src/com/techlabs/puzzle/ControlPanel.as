package com.techlabs.puzzle {

	import com.bit101.components.PushButton;
	import com.techlabs.puzzle.events.PuzzleEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class ControlPanel extends Sprite {

		private var _shuffleButton:PushButton;
		private var _flashPuzzle:PushButton;
		private var _flexPuzzle:PushButton;
		private var _preview:Bitmap;

		public function ControlPanel() {
			
			// Buttons
			_shuffleButton = new PushButton(this, 20, 20, "Shuffle", shuffleBoardHandler);
			_flashPuzzle = new PushButton(this, 20, 45, "Flash Puzzle", changeImageHandler);
			_flexPuzzle = new PushButton(this, 20, 70, "Flex Puzzle", changeImageHandler);
		}
		
		// Sets the small preview image
		// It is there only give the user a hint about how
		// the result should look like
		public function setPreview(image:Bitmap):void {
			
			// This is the scale we need to get 100x100px image
			// -> 100px = Originalwidth / scaleFactor;
			// -> scaleFactor = 100px / Originalwidth;
			var scale:Number = 100/image.width;
			
			// Transform matrix for scaling
			var m:Matrix = new Matrix();
			m.scale(scale, scale);
		
			var bmd:BitmapData = new BitmapData(image.width*scale, image.width*scale);
			bmd.draw(image, m);
			_preview = new Bitmap(bmd, PixelSnapping.AUTO, true);
			
			addChild(_preview);

			_preview.x = 20;
			_preview.y = 105;
		}
		
		private function shuffleBoardHandler(e:Event):void {
			dispatchEvent(new PuzzleEvent(PuzzleEvent.SHUFFLE));
		}

		private function changeImageHandler(e:Event):void {
			if (e.target.label == "Flash Puzzle")
				dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, "assets/Puzzle_Flash.png"));
			else
				dispatchEvent(new PuzzleEvent(PuzzleEvent.CHANGE_IMAGE, null, "assets/Puzzle_Flex.png"));
		}

	}

}
