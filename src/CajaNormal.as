package
{
	import com.techlabs.puzzle.ControlPanel;
	import com.techlabs.puzzle.PuzzleBoard;
	import com.techlabs.puzzle.events.PuzzleEvent;
	import com.techlabs.puzzle.helpers.ImageSlicer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	
	public class CajaNormal extends Sprite
	{
		
		// Defines how the puzzle will be divided
		public static var subdivisions:int = 4;
		
		// Padding between the pieces
		public static var padding:int = 2;
		
		// The size of the puzzle board
		public static var size:int = 500;
		
		private var _image:Bitmap;
		
		private var _loader:Loader;
		private var _request:URLRequest;
		
		private var _slicer:ImageSlicer;
		private var _puzzleImages:Array;
		
		private var _gameBoard:PuzzleBoard;
		
		private var _controlPanel:ControlPanel;
		
		public function CajaNormal()
		{
		}
		
		
		
		public function SlidingPuzzle() {
			_slicer = new ImageSlicer();
			
			_gameBoard = new PuzzleBoard();
			_puzzleImages = new Array();
			
			_controlPanel = new ControlPanel();
			_controlPanel.addEventListener(PuzzleEvent.CHANGE_IMAGE, imageChangeHandler);
			_controlPanel.addEventListener(PuzzleEvent.SHUFFLE, suffleHandler);
			
			//var AuxUiContenedor:UIComponent= new UIComponent();
			
			//addChild(_controlPanel);
			
			
			
			
			initPuzzle("assets/polo3d.jpg");
		}
		
		
		
		private function initPuzzle(imageURL:String):void {
			loadPuzzleImage(imageURL);
		}
		
		// Loads the image
		private function loadPuzzleImage(imageURL:String):void {
			_loader = new Loader();
			_request = new URLRequest(imageURL);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
			_loader.load(_request);
		}
		
		// This will execute when load completes
		private function imageLoadComplete(e:Event):void {
			_image = _loader.content as Bitmap;
			
			// sliceImage() returns a two dimensional array containing the sliced bitmaps
			_puzzleImages = _slicer.sliceImage(_image);
			
			// creates the puzzle board
			_gameBoard.createPuzzle(_puzzleImages);

			
			// sets the preview image in the control panel
			_controlPanel.setPreview(_image);
		}
		
		public function GetPuzleBoard():PuzzleBoard{
		return _gameBoard;
		
		}
		
		private function imageChangeHandler(e:PuzzleEvent):void {
			initPuzzle(e.imageURL);
		}
		
		private function suffleHandler(e:PuzzleEvent):void {
			_gameBoard.shuffle();
		}
		
		
	}
}