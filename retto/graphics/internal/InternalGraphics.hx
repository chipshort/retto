package retto.graphics.internal;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Point;
import retto.graphics.Color;

/**
 * This is the base class for the platform specific Graphics classes.
 * Do not use this yourself.
 * @author Christoph Otter
 */
@:access(retto.graphics.ImageData)
class InternalGraphics
{
	public var colors = new Array<Color> ();
	public var smoothing = new Array<Bool> ();
	public var translations = new Array<Float> ();
	
	var game : Game;
	
	//temporary objects to reduce GC
	var tempMat : Matrix;
	var tempPoint : Point;
	var tempImage : ImageData;
	
	//text renderer used to render text
	var textRenderer : TextRenderer;
	var shapeRenderer : ShapeRenderer;
	
	public function new (pgame : Game)
	{
		game = pgame;
		
		tempMat = new Matrix ();
		tempPoint = new Point ();
		tempImage = new ImageData (null);
		
		textRenderer = new TextRenderer ();
		
		colors.push (0xFFFFFFFF);
		smoothing.push (true);
		translations.push (0);
		translations.push (0);
	}
	
	public function drawImage (img : ImageData, x : Float, y : Float, angle : Float, anchorX : Float, anchorY : Float) : Void
	{
	}
	
	public function drawImage2 (img : ImageData, x : Float, y : Float, width : Float, height : Float, angle : Float, anchorX : Float, anchorY : Float) : Void
	{
	}
	
	public function drawText (text : String, x : Float, y : Float, size : Float, font : String, style : Int) : Void
	{
	}
	
	public function drawTilesheet (sheet : Tilesheet, data : Array<Float>) : Void
	{
	}
	
	public function drawCircle (centerX : Float, centerY : Float, rad : Float, fill : Bool) : Void
	{
	}
	
	public function drawRect (x : Float, y : Float, width : Float, height : Float, fill : Bool) : Void
	{
	}
	
	public function drawLine (x0 : Float, y0 : Float, x1 : Float, y1 : Float) : Void
	{
	}
	
	public function drawPoint (x : Float, y : Float) : Void
	{
	}
	
	public function clear () : Void
	{
	}
	
	public function fill () : Void
	{
	}
	
	public function dispose () : Void
	{
	}
	
	public function flush () : Void
	{
	}
	
	/** This is used to get an Image from a BitmapData. */
	public function registerImage (bmp : BitmapData) : ImageData
	{
		return null;
	}
	
	/** This is called when the stage was resized. */
	public function onStageResize () : Void
	{
	}
	
	/** This is called after loading all images. It is used to pack the spritesheet. */
	public function finishedImageLoading () : Void
	{
	}
	
	/** This is called before a new smoothing value is pushed to the array. */
	public function smoothingBeforePushed (s : Bool) : Void
	{
	}
	
	/** A helper function to get the currently active color. */
	inline function getCurrentColor () : Color
	{
		return colors[colors.length - 1];
	}
	
	/** A helper function to get the current smoothing state. */
	inline function getCurrentSmoothing () : Bool
	{
		return smoothing[smoothing.length - 1];
	}
	
}