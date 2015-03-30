package retto.graphics.internal;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Tilesheet;
import openfl.geom.ColorTransform;
import retto.graphics.Color;
import retto.graphics.ImageData;

/**
 * ...
 * @author Christoph Otter
 */
@:access(retto.graphics.ImageData)
class FlashGraphics extends InternalGraphics
{
	var canvas : Bitmap;
	var bitmapData : BitmapData;
	
	var tempShape : Shape;
	
	var drawToImage = true;

	public function new (container : Game, ?imgData : BitmapData) 
	{
		super (container);
		
		tempShape = new Shape ();
		shapeRenderer = new ShapeRenderer (tempShape.graphics);
		
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
	
	override public function drawText (text : String, x : Float, y : Float, size : Float, font : String, style : Int) : Void
	{
		var tempTextField = textRenderer.prepareTextField (text, getCurrentColor (), size, font, style);
		
		tempMat.identity ();
		tempMat.translate (x, y);
		
		bitmapData.lock ();
		bitmapData.draw (tempTextField, tempMat, null, null, null, getCurrentSmoothing ());
		bitmapData.unlock ();
	}
	
	@:access(openfl.display.Tilesheet)
	override public function drawTilesheet (sheet : Tilesheet, data : Array<Float>) : Void
	{
		#if openfl_bitfive
		var bmp = sheet.nmeBitmap;
		#else
		var bmp = sheet.__bitmap;
		#end
		
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
			
			if (rect == null) continue;
			
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
	
	override public function drawCircle (centerX : Float, centerY : Float, rad : Float, fill : Bool) : Void
	{
		//drawImage2 (circle, centerX - rad, centerY - rad, 2 * rad, 2 * rad, 0, 0, 0);
		
		var color = getCurrentColor ();
		tempShape.graphics.clear ();
		
		shapeRenderer.drawCircle (centerX, centerY, rad, fill, color);
		
		bitmapData.lock ();
		bitmapData.draw (tempShape, null, null, null, null, getCurrentSmoothing ());
		bitmapData.unlock ();
	}
	
	override public function drawRect (x : Float, y : Float, width : Float, height : Float, fill : Bool) : Void
	{
		var color = getCurrentColor ();
		tempShape.graphics.clear ();
		
		shapeRenderer.drawRect (x, y, width, height, fill, color); //TODO: we might be able to batch these primitive calls together?
		
		bitmapData.lock ();
		bitmapData.draw (tempShape, null, null, null, null, getCurrentSmoothing ());
		bitmapData.unlock ();
	}
	
	override public function drawLine (x0 : Float, y0 : Float, x1 : Float, y1 : Float) : Void
	{
		var color = getCurrentColor ();
		tempShape.graphics.clear ();
		
		shapeRenderer.drawLine (x0, y0, x1, y1, color);
		
		bitmapData.lock ();
		bitmapData.draw (tempShape, null, null, null, null, getCurrentSmoothing ());
		bitmapData.unlock ();
	}
	
	override public function drawPoint (x : Float, y : Float) : Void
	{
		var color = getCurrentColor ();
		var smoothing = getCurrentSmoothing ();
		
		if (smoothing) {
			drawCircle (x, y, 1.5, true);
		}
		else {
			var xi = Std.int (x);
			var yi = Std.int (y);
			
			var mixed = color.mix (bitmapData.getPixel32 (xi, yi));
			
			bitmapData.lock ();
			bitmapData.setPixel32 (xi, yi, mixed);
			bitmapData.unlock ();
		}
		
	}
	
	override public function clear () : Void
	{
		colors.push (0);
		fill ();
		colors.pop ();
	}
	
	override public function fill () : Void
	{
		bitmapData.lock ();
		bitmapData.fillRect (bitmapData.rect, getCurrentColor ());
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
	
	/**
	 * This is called when the stage is resized. It creates a new BitmapData with the right size.
	 */
	override public function onStageResize () : Void
	{
		if (!drawToImage) {
			var sM = game.scaleMode;
			canvas.x = sM.dX;
			canvas.y = sM.dY;
			canvas.scaleX = sM.scaleX;
			canvas.scaleY = sM.scaleY;
		}
	}
	
	//public function finishedImageLoading () : Void
	//public function smoothingBeforePushed (s : Bool) : Void
	//public function flush () : Void
	
}