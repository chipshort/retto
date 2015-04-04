package retto.graphics.internal;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.text.TextField;
import openfl.text.TextFormat;
import retto.graphics.Canvas;
import retto.graphics.ImageData;
import retto.graphics.internal.TexturePacker;

/**
 * ...
 * @author Christoph Otter
 */
@:access(retto.graphics.ImageData)
@:access(retto.Loader)
class TileSheetGraphics extends InternalGraphics
{
	var container : Sprite;
	var g : openfl.display.Graphics;
	
	var batchImages = new Array<ImageData> ();
	var tilesheet : Tilesheet;
	var sheetData : BitmapData;
	
	var tempRect : Rectangle;
	
	var tileData = new Array<Float> (); //used for batching
	static var maxTextureWidth = 0;
	static var maxTextureHeight = 0;
	
	public function new (pgame : Game, ?c : Sprite) 
	{
		super (pgame);
		
		tempRect = new Rectangle ();
		
		if (c == null) { //not used as canvasGraphics
			c = game;
		}
		g = c.graphics;
		
		container = c;
		
		shapeRenderer = new ShapeRenderer (g);
		
		setMaxTextureSize ();
	}
	
	override public inline function drawImage (img : ImageData, x : Float, y : Float, angle : Float, anchorX : Float, anchorY : Float) : Void
	{
		drawImage2 (img, x, y, img.width, img.height, angle, anchorX, anchorY);
	}
	
	override public function drawImage2 (img : ImageData, x : Float, y : Float, width : Float, height : Float, angle : Float, anchorX : Float, anchorY : Float) : Void
	{
		var rad = angle / 180 * Math.PI;
		var scaleX = width / img.width;
		var scaleY = height / img.height;
		
		tempMat.identity ();
		var matrix = tempMat;
		matrix.scale (scaleX, scaleY);
		matrix.translate (-anchorX, -anchorY);
		matrix.rotate (rad);
		matrix.translate (anchorX, anchorY);
		
		if (img.sheetIndex != -1) {
			var color = getCurrentColor ();
			
			tileData.push (x + matrix.tx);
			tileData.push (y + matrix.ty);
			tileData.push (img.sheetIndex);
			tileData.push (matrix.a);
			tileData.push (matrix.b);
			tileData.push (matrix.c);
			tileData.push (matrix.d);
			tileData.push (color.r);
			tileData.push (color.g);
			tileData.push (color.b);
			tileData.push (color.a);
			
		}
		else if (angle % 360 == 0) {
			flush ();
			
			var bmp = getColoredBitmap (img);
			matrix.translate (x, y);
			
			g.beginBitmapFill (bmp, matrix, false, getCurrentSmoothing ());
			g.drawRect (x, y, width, height);
			g.endFill ();
		}
		else {
			flush ();
			
			var bmp = getColoredBitmap (img);
			
			matrix.translate (x, y);
			
			g.beginBitmapFill (bmp, matrix, false, getCurrentSmoothing ());
			
			tempPoint.x = 0;
			tempPoint.y = 0;
			var p0 = matrix.transformPoint (tempPoint);
			tempPoint.x = width;
			tempPoint.y = 0;
			var p1 = matrix.transformPoint (tempPoint);
			tempPoint.x = 0;
			tempPoint.y = height;
			var p2 = matrix.transformPoint (tempPoint);
			tempPoint.x = width;
			tempPoint.y = height;
			var p3 = matrix.transformPoint (tempPoint);
			
			//FIXME: this is not working correctly on next target
			g.drawTriangles ([
				p0.x, p0.y,
				p1.x, p1.y,
				p2.x, p2.y,
				p3.x, p3.y
			], [0, 1, 2, 1, 3, 2], [
				0,0,
				1,0,
				0,1,
				1, 1
			]);
			
			g.endFill ();
		}
		
	}
	
	override public function drawText (text : String, x : Float, y : Float, size : Float, font : String, style : Int) : Void
	{
		var tempTextField = textRenderer.prepareTextField (text, getCurrentColor (), size, font, style);
		
		tempMat.identity ();
		var bitmapData = new BitmapData (Std.int (tempTextField.width), Std.int (tempTextField.height), true, 0x00000000);
		bitmapData.draw (tempTextField, tempMat, null, null, null, getCurrentSmoothing ());
		
		tempImage.bitmapData = bitmapData;
		
		colors.push (0xFFFFFFFF);
		drawImage (tempImage, x, y, 0, 0, 0);
		colors.pop ();
	}
	
	override public function drawTilesheet (sheet : Tilesheet, data : Array<Float>) : Void
	{
		flush ();
		
		g.drawTiles (sheet, data, getCurrentSmoothing (), Tilesheet.TILE_TRANS_2x2);
	}
	
	override public function drawCircle (centerX : Float, centerY : Float, rad : Float, fill : Bool) : Void
	{
		flush ();
		
		var color = getCurrentColor ();
		
		shapeRenderer.drawCircle (centerX, centerY, rad, fill, color);
	}
	
	override public function drawRect (x : Float, y : Float, width : Float, height : Float, fill : Bool) : Void
	{
		flush ();
		
		var color = getCurrentColor ();
		
		shapeRenderer.drawRect (x, y, width, height, fill, color);
	}
	
	override public function drawLine (x0 : Float, y0 : Float, x1 : Float, y1 : Float) : Void
	{
		flush ();
		
		var color = getCurrentColor ();
		
		shapeRenderer.drawLine (x0, y0, x1, y1, color);
	}
	
	override public function clear () : Void
	{
		resetTileData ();
		g.clear ();
	}
	
	override public function fill () : Void
	{
		resetTileData ();
		
		var color = getCurrentColor ();
		
		g.beginFill (color, color.a);
		g.drawRect (0, 0, game.gameWidth, game.gameHeight);
		g.endFill ();
	}
	
	override public function dispose () : Void
	{
		sheetData.dispose ();
		resetTileData ();
	}
	
	override public function flush () : Void
	{
		//this is where we actually draw
		if (tileData.length > 0)
			g.drawTiles (tilesheet, tileData, getCurrentSmoothing (), Tilesheet.TILE_TRANS_2x2 | Tilesheet.TILE_RGB | Tilesheet.TILE_ALPHA);
		
		resetTileData ();
	}
	
	override public function registerImage (bmp : BitmapData) : ImageData
	{
		var img = new ImageData (bmp);//ImageData.fromBitmapData (bmp);
		
		if (batchImages != null) //not yet finished loading
			batchImages.push (img);
		
		#if debug
		else
			trace ("WARNING: You are loading Images after calling 'finishLoading'. This can result in bad rendering performance.");
		#end
		
		return img;
	}
	
	/**
	 * This packages all loaded Images into a spritesheet of minumum PO2-size.
	 */
	override public function finishedImageLoading () : Void
	{
		if (batchImages == null) return;
		
		var packer = new TexturePacker (maxTextureWidth, maxTextureHeight);
		
		batchImages.sort (function (i1 : ImageData, i2 : ImageData) { //sort by perimeter
			var p1 = 2 * (i1.width + i1.height);
			var p2 = 2 * (i2.width + i2.height);
			return p2 - p1; //from biggest to smallest
		});
		
		for (img in batchImages) {
			var node = packer.add (img);
			#if debug
			if (node == null)
				trace ("WARNING: No more space in Tilesheet used for auto-batching. This can result in bad rendering performance.");
			#end
		}
		
		//create shrinked Tilesheet
		var rect = packer.getRealRectangle ();
		createTileSheet (TexturePacker.closestPow2 (Std.int (rect.width)), TexturePacker.closestPow2 (Std.int (rect.height)));
		
		//add images to tilesheet
		for (node in packer.imageNodes) {
			addToSpritesheet (node);
		}
		
		batchImages = null;
	}
	
	override public function smoothingBeforePushed (s : Bool) : Void
	{
		if (getCurrentSmoothing () != s) //we only need to flush if it actually changed
			flush ();
	}
	
	override public function onStageResize () : Void
	{
		var sM = game.scaleMode;
		container.x = sM.dX;
		container.y = sM.dY;
		container.scaleX = sM.scaleX;
		container.scaleY = sM.scaleY;
	}
	
	/**
	 * Helper function to get a color multiplied version of the given ImageData.
	 */
	function getColoredBitmap (img : ImageData) : BitmapData
	{
		var color = getCurrentColor ();
		
		if (color != 0xFFFFFFFF) {
			var colorTransform = new ColorTransform (color.r, color.g, color.b, color.a); //FIX this
			var bmp = img.bitmapData.clone ();
			bmp.colorTransform (bmp.rect, colorTransform);
			return bmp;
		}
		
		return img.bitmapData;
	}
	
	/**
	 * Actually adds a (node) to the Spritesheet by drawing it onto the spritesheet image
	 */
	inline function addToSpritesheet (node : Node) : Void
	{
		var x = node.rect.x;
		var y = node.rect.y;
		var img = node.image;
		
		tempRect.x = x;
		tempRect.y = y;
		tempRect.width = img.width;
		tempRect.height = img.height;
		
		drawToSheet (img, x, y);
		
		img.sheetIndex = tilesheet.addTileRect (tempRect);
	}
	
	function drawToSheet (img : ImageData, x : Float, y : Float) : Void
	{
		sheetData.lock ();
		tempPoint.x = x;
		tempPoint.y = y;
		sheetData.copyPixels (img.bitmapData, img.bitmapData.rect, tempPoint);
		sheetData.unlock ();
	}
	
	inline function createTileSheet (w : Int, h : Int) : Void
	{
		sheetData = new BitmapData (w, h, true, 0x000000); //important: no alpha!
		tilesheet = new Tilesheet (sheetData);
	}
	
	/**
	 * Helper function to reset tileData in a fast way
	 */
	inline function resetTileData () : Void
	{
		#if (cpp || php)
           tileData = [];
        #else
           untyped tileData.length = 0;
        #end
	}
	
	/**
	 * A helper function that determines the size to use for the spritesheet.
	 * It sets (maxTextureWidth) and (maxTextureHeight).
	 */
	@:access(openfl.display.Stage)
	inline function setMaxTextureSize () : Void
	{
		if (maxTextureWidth != 0) return;
		
		maxTextureWidth = maxTextureHeight = GL.getParameter (GL.MAX_TEXTURE_SIZE);
		//maxTextureWidth = maxTextureHeight = maxTextureWidth > 4096 ? 4096 : maxTextureWidth;
	}
	
}