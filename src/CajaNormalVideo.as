package
{
	import com.techlabs.puzzle.ControlPanel;
	import com.techlabs.puzzle.PuzzleBoard;
	import com.techlabs.puzzle.PuzzlePiece;
	import com.techlabs.puzzle.events.PuzzleEvent;
	import com.techlabs.puzzle.helpers.ImageSlicer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	import away3d.materials.BitmapMaterial;
	import away3d.materials.VideoMaterial;
	import away3d.primitives.Plane;
	
	
	
	
	public class CajaNormalVideo extends Sprite
	{
		
		// Defines how the puzzle will be divided
		public static var subdivisions:int = 4;
		
		// Padding between the pieces
		public static var padding:int = 2;
		
		// The size of the puzzle board
		public static var size:int = 500;
		
		public var _image:Bitmap;
		
		private var _loader:Loader;
		private var _request:URLRequest;
		
		private var _slicer:ImageSlicer;
		private var _puzzleImages:Array;
		
		public var _gameBoard:PuzzleBoard;
		
		private var _controlPanel:ControlPanel;
		
		private var vidMat:VideoMaterial;
		
		private var plane:Plane;
		
		private var Ancho:int;
		private var Largo:int;
		
		public var RenderVideo:BitmapData;
		
		
		
		
		public function SlidingPuzzle(_image:BitmapData):void {
			
			
			
			_puzzleImages = new Array();
			
			_slicer = new ImageSlicer();
			
			this._image= new Bitmap(_image);
			
			
			_gameBoard = new PuzzleBoard();
			
			_puzzleImages = _slicer.sliceImage(this._image);
			
			
			
			
			// creates the puzzle board
			_gameBoard.createPuzzle(_puzzleImages);
			
			
			
			
			
		}
		
		
		
		public function createPuzzleRender(images:Array):void {
			
			
			var pieceCount:int = 0;
			var lastPiece:int = CajaNormal.subdivisions * CajaNormal.subdivisions;
			
			for(var yp:int = 0; yp < CajaNormal.subdivisions; yp++) {
				for(var xp:int = 0; xp < CajaNormal.subdivisions; xp++) {
					if (++pieceCount == lastPiece)
						break;
					var image:Bitmap = images[yp][xp];
					
					for(var zp:int = 0; zp < _gameBoard._pieces.length; zp++) {
						if(_gameBoard._pieces[zp].Identidad == yp+","+xp)
							_gameBoard._pieces[zp].material = new BitmapMaterial(image.bitmapData, {smoothing:true})
					}
				}
			}
			
		}
		
		
		
		public function getControlPanel():ControlPanel{
			_controlPanel.setPreview(_image);
			return _controlPanel;
		}
		
		
		public function GetPuzleBoard():PuzzleBoard{
			return _gameBoard;
			
		}
		
		
		
		private function suffleHandler(e:PuzzleEvent):void {
			_gameBoard.shuffle();
		}
		
		public function initVideo(VIDEO_URL:String):void
		{
			
			//video material
			vidMat = new VideoMaterial();
			vidMat.file = VIDEO_URL;
			vidMat.loop = true;
			vidMat.smooth = true;
			vidMat.interactive = false;
			
			//add plane
			
			
		}
		
		
		public function initPrevioVideo(Ancho:int,Largo:int):void
		{
			//add plane
			plane = new Plane();
			plane.material = vidMat;
			plane.width = Ancho;
			plane.height = Largo;
			plane.x=0;
			plane.y=200;
			plane.yUp = false;
			plane.bothsides = true;
		}
		
		
		public function sliceImageRender(image:BitmapData):Array{
			
			var imgW:Number = image.width;
			var imgH:Number = image.height;
			
			// Width and height of an individual piece
			var pieceW:Number = imgW / CajaNormal.subdivisions;
			var pieceH:Number = imgH / CajaNormal.subdivisions;
			
			var imageArray:Array = new Array();
			
			var rect:Rectangle;
			var temp:Bitmap;
			var tempdata:BitmapData;
			
			for(var y:int = 0; y < CajaNormal.subdivisions; y++) {
				imageArray[y] = new Array();
				for(var x:int = 0; x < CajaNormal.subdivisions; x++) {
					tempdata = new BitmapData(pieceW, pieceH, true, 0x00000000);
					rect = new Rectangle(x * pieceW, y * pieceH, pieceW, pieceH);
					tempdata.copyPixels(image, rect, new Point(0, 0));
					temp = new Bitmap(tempdata);
					
					imageArray[y][x] = temp;
				}
			}
			
			//return tempdata ;
			
			return imageArray ;
		}
		
		
		
		
		
		
		
		
		
		public function getPrevioVideo():Plane{
			return this.plane;
		}
		
		public function getVideo():VideoMaterial{
			return vidMat;
		}
		
		public function getImagen():Bitmap{
			return this._image;
		}
		
		
	}
}