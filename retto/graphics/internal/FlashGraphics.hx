package retto.graphics.internal;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import retto.graphics.Color;

/**
 * ...
 * @author Christoph Otter
 */
@:access(retto.graphics.ImageData)
class FlashGraphics extends InternalGraphics
{
	var canvas : Bitmap;
	var bitmapData : BitmapData;
	
	var drawToImage = true;

	public function new (container : Game, ?imgData : BitmapData) 
	{
		super (container);
		
		if (imgData == null) {
			imgData = new BitmapData (game.gameWidth, game.gameHeight, true, 0x000000);
			drawToImage = false;
			
			canvas = new Bitmap (imgData);
			game.addChild (canvas);
		}
		
		bitmapData = imgData;
	}
	
	override public function drawImage (img : ImageData, x : Float, y : Float, angle : Float, anchorX : Float, anchorY : Float) : Void
	{
		if (angle % 360 == 0 && !getCurrentSmoothing () && getCurrentColor () == 0xFFFFFFFF) {
			tempPoint.x = x;
			tempPoint.y = y;
			
			bitmapData.lock ();
			bitmapData.copyPixels (img.bitmapData, img.bitmapData.rect, tempPoint, null, null, true);
			bitmapData.unlock ();
		}
		else {
			drawImage2 (img, x, y, img.width, img.height, angle, anchorX, anchorY);
		}
	}
	
	override public function drawImage2 (img : ImageData, x : Float, y : Float, width : Float, height : Float, angle : Float, anchorX : Float, anchorY : Float) : Void
	{
		//FIXME: ColorTransform not working in html5; this is an openfl problem
		var color = getCurrentColor ();
		var colorTransform = color == 0xFFFFFFFF ? null : new ColorTransform (color.r, color.g, color.b, color.a);
		
		var rad = angle / 180 * Math.PI;
		var scaleX = width / img.width;
		var scaleY = height / img.height;
		
		tempMat.identity ();
		tempMat.scale (scaleX, scaleY);
		tempMat.translate (-anchorX, -anchorY);
		tempMat.rotate (rad);
		tempMat.translate (anchorX, anchorY);
		tempMat.translate (x, y);
		
		bitmapData.lock ();
		bitmapData.draw (img.bitmapData, tempMat, colorTransform, null, null, getCurrentSmoothing ());
		bitmapData.unlock ();
	}
	
	override public function drawText (text : String, x : Float, y : Float, color : Color, size : Float, font : String, style : Int) : Void
	{
		var tempTextField = textRenderer.prepareTextField (text, color, size, font, style);
		
		tempMat.identity ();
		tempMat.translate (x, y);
		
		bitmapData.lock ();
		bitmapData.draw (tempTextField, tempMat, null, null, null, getCurrentSmoothing ());
		bitmapData.unlock ();
		//game.addChild (tempTextField);
	}
	
	@:access(openfl.display.Tilesheet)
	override public function drawTilesheet (sheet : Tilesheet, data : Array<Float>) : Void
	{
		var bmp = sheet.__bitmap;
		
		#if debug
		if (data.length % 7 != 0) throw "ERROR: drawTilesheet call with wrong data length.";
		#end
		
		var i = 0;
		while (i < data.length) {
			var x = data[i++];
			var y = data[i++];
			
			var index = Std.int (data[i++]);
			tempMat.setTo (data[i++], data[i++], data[i++], data[i++], x, y);
			
			var angle = Math.atan (tempMat.b / tempMat.a) / Math.PI * 180;
			var rect = sheet.getTileRect (index);
			
			if (angle % 360 == 0 && !getCurrentSmoothing ()) {
				tempPoint.x = x;
				tempPoint.y = y;
				
				bitmapData.lock ();
				bitmapData.copyPixels (bmp, rect, tempPoint, null, null, true);
				bitmapData.unlock ();
			}
			else {
				bitmapData.lock ();
				//bug fix for flash
				tempPoint.x = 0;
				tempPoint.y = 0;
				var tempBitmap = new BitmapData (Std.int (rect.width), Std.int (rect.height));
				tempBitmap.copyPixels (bmp, rect, tempPoint);
				
				bitmapData.draw (tempBitmap, tempMat, null, null, null, getCurrentSmoothing ());
				bitmapData.unlock ();
			}
		}
	}
	
	override public function clear () : Void
	{
		fill (0);
	}
	
	override public function fill (color : Color) : Void
	{
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, color);
		bitmapData.unlock ();
	}
	
	override public function dispose () : Void
	{
		if (!drawToImage) {
			game.removeChild (canvas);
			bitmapData.dispose ();
		}
	}
	
	override public function registerImage (bmp : BitmapData) : ImageData
	{
		return new ImageData (bmp);
	}
	
	/** This is called when the stage is resized. It creates a new BitmapData with the right size. */
	override public function onStageResize () : Void
	{ 
		if (!drawToImage) {
			bitmapData = new BitmapData (game.gameWidth, game.gameHeight, true, 0x000000);
			canvas.bitmapData = bitmapData;
		}
	}
	
	//public function flush () : Void
	//public function finishedImageLoading () : Void
	//public function smoothingBeforePushed (s : Bool) : Void
	
}