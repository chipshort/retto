package retto.graphics;
import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.Lib;
import retto.Game;
import retto.graphics.internal.FlashGraphics;
import retto.graphics.internal.InternalGraphics;

/**
 * The Graphics class is the main class needed for drawing.
 * All coordinates are mesured with the top-left edge of the window being (0, 0),
 * x going to the right and y going down.
 * @author Christoph Otter
 */
@:access(openfl.display.Stage)
class Graphics
{
	//TODO: add primitive drawing (lines, points, circles, rects ...)
	
	//text styles
	public static inline var TextBold = 1; 		//001
	public static inline var TextItalic = 2; 	//010
	public static inline var TextUnderline = 4; //100
	
	static var graphics : Graphics;
	
	/**
	 * The current translation on the x-axis. Change this using pushTranslation / popTranslation.
	 * This denotes the amout of pixels every object of the screen is moved in x-direction.
	 * @default 0.0
	 */
	public var translateX (get, never) : Float;
	
	/**
	 * The current translation on the y-axis. Change this using pushTranslation / popTranslation.
	 * This denotes the amout of pixels every object of the screen is moved in y-direction.
	 * @default 0.0
	 */
	public var translateY (get, never) : Float;
	
	/**
	 * The currently active Color used for blending images. Change this using pushColor / popColor.
	 * @default 0xFFFFFFFF
	 */
	public var color (get, never) : Color;
	
	/**
	 * Whether or not the drawn things should be smoothed where possible. This represents the currently active value.
	 * Change this using pushSmoothing / popSmoothing.
	 * @default true
	 */
	public var smoothing (get, never) : Bool;
	
	//TODO: having this here instead of internalGraphics could cause problems with canvasGraphics
	public var translations = new Array<Float> ();
	
	var game : Game;
	var internalG : InternalGraphics;
	
	/** Canvas Graphics; null if Canvas is not active */
	var canvasGraphics : InternalGraphics;
	var canvas : Canvas;
	/*#if native
	var canvasSprite : Sprite;
	#end*/
	
	inline function get_translateX () : Float
	{
		return translations[translations.length - 2];
	}
	inline function get_translateY () : Float
	{
		return translations[translations.length - 1];
	}
	
	inline function get_color () : Color
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		return g.colors[g.colors.length - 1];
	}
	
	inline function get_smoothing () : Bool
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		return g.smoothing[g.smoothing.length - 1];
	}
	
	function new (container : Game)
	{
		graphics = this;
		game = container;
		
		pushTranslation (0, 0);
		
		#if native
		internalG = new retto.graphics.internal.TileSheetGraphics (container);
		#else
		internalG = new FlashGraphics (container);
		#end
	}
	
	/**
	 * Enables "Draw to Canvas". Every future drawing operation will change (c) instead of the screen.
	 * Drawing to a Canvas is potentially less performant than drawing to the screen directly.
	 * It is only usefull to "buffer" static things that do not need to be redrawn every frame.
	 * Call this function with null as (c) to disable "Draw to Canvas".
	 */
	@:access(retto.graphics.Canvas)
	public function setCanvas (c : Canvas) : Void
	{
		if (c == null) {
			
			/*#if native
			if (canvas != null) {
				canvas.bitmapData.draw (canvasSprite, new Matrix ());
			}
			#end*/
			
			canvas.graphics = null;
			canvas = null;
			canvasGraphics = null;
		}
		else {
			canvas = c;
			canvas.graphics = this;
			
			//FIXME: TileSheetGraphics as canvasGraphics is buggy
			/*#if native
			canvasSprite = new Sprite ();
			canvasGraphics = new retto.graphics.internal.TileSheetGraphics (game, canvasSprite);
			#else*/
			canvasGraphics = new FlashGraphics (null, c.bitmapData);
			//#end
		}
	}
	
	/**
	 * Set the currently active Color to (c).
	 * This Color is used to blend images with when drawing them
	 */
	public inline function pushColor (c : Color) : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		g.colors.push (c);
	}
	
	/**
	 * Revert to the previously active Color.
	 */
	public inline function popColor () : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		g.colors.pop ();
	}
	
	/**
	 * Set the currently active (translationX, translationY) to (x, y).
	 */
	public inline function pushTranslation (x : Float, y : Float) : Void
	{
		translations.push (x);
		translations.push (y);
	}
	
	/**
	 * Revert to the previously active translation.
	 */
	public inline function popTranslation () : Void
	{
		translations.pop ();
		translations.pop ();
	}
	
	/**
	 * Set if smoothing is currently active.
	 */
	public inline function pushSmoothing (s : Bool) : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		g.smoothingBeforePushed (s);
		g.smoothing.push (s);
	}
	
	/**
	 * Revert to the previous state of smoothing.
	 */
	public inline function popSmoothing () : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		g.smoothing.pop ();
	}
	
	/**
	 * Draws the given (img) at (x, y) and rotated by (angle)°
	 * @param	x, y defined as the top-left coordinate of the drawn image (before rotation)
	 */
	public inline function drawImage (img : ImageData, x : Float, y : Float, angle : Float = 0, anchorX : Float = 0, anchorY : Float = 0) : Void
	{
		if (color.a == 0 || isOffScreen (x, y, img.width, img.height))
			return;
		
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		
		g.drawImage (img, x + translateX, y + translateY, angle, anchorX, anchorY);
	}
	
	/**
	 * Draws the given (img) at (x, y) with the given (width) and (height), rotated by (angle)° around (anchorX, anchorY).
	 * @param	x, y see drawImage
	 */
	public inline function drawImage2 (img : ImageData, x : Float, y : Float, width : Float, height : Float, angle : Float = 0, anchorX : Float = 0, anchorY : Float = 0) : Void
	{
		if (color.a == 0 || isOffScreen (x, y, width, height))
			return;
		
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		
		g.drawImage2 (img, x + translateX, y + translateY, width, height, angle, anchorX, anchorY);
	}
	
	/**
	 * Draws the given (text) at (x, y) with the given (color), (size), (font) and (style)
	 * @param	x, y top-left coordinate of the drawn text
	 * @param	font if null, Loader.defaultFontName is used
	 * @param	style can be Graphics.TextBold, Graphics.TextItalic and/or Graphics.TextUnderline
	 */
	public inline function drawText (text : String, x : Float, y : Float, color : Color, size = 16.0, ?font : String, style = 0) : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		
		g.drawText (text, x + translateX, y + translateY, color, size, font, style);
	}
	
	/**
	 * Draws the tile at (index) of (sheet) at the position (x, y) with (width) and (height) as dimensions, rotated by (angle)° around (aX, aY).
	 * It is not recommended to use your own Tilesheets, since Retto automatically creates one for you, but it might be usefull for Tilemaps, etc.
	 * @param	data is an Array of Float values looking like this: [x + matrix.tx, y + matrix.ty, index, matrix.a, matrix.b, matrix.c, matrix.d, ...]
	 */
	public inline function drawTilesheet (sheet : Tilesheet, data : Array<Float>) : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		var data = data.copy ();
		
		data[0] += translateX;
		data[1] += translateY;
		g.drawTilesheet (sheet, data);
	}
	
	/**
	 * Clears the screen.
	 */
	public inline function clear () : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		
		g.clear ();
	}
	
	/**
	 * Fills the screen with the given (color).
	 */
	public inline function fill (color : Color) : Void
	{
		var g = canvasGraphics == null ? internalG : canvasGraphics;
		
		g.fill (color);
	}
	
	/**
	 * An event listener registered in Game class.
	 */
	function stageResized (e : Event) : Void
	{
		internalG.onStageResize ();
	}
	
	/**
	 * A helper function to check whether the specified rectangle is still visible on screen.
	 * This also works for rotated rectangles, which means this can return false-negatives.
	 * Therefore this function is only used to prevent drawing invisible images.
	 */
	function isOffScreen (x : Float, y : Float, w : Float, h : Float) : Bool
	{
		var sW : Float;
		var sH : Float;
		
		if (canvas == null) {
			sW = game.gameWidth;
			sH = game.gameHeight;
		}
		else {
			sW = canvas.width;
			sH = canvas.height;
		}
		
		//use triangle inequality because of rotated images
		var wh = w + h;
		return x + wh < 0 || y + wh < 0 || x > sW + wh || y > sH + wh;
	}
	
	/**
	 * Called by Game class when it is removed from screen.
	 * This function cleans everything up.
	 */
	inline function dispose () : Void
	{
		internalG.dispose ();
	}
	
	/**
	 * This function is called at the end of every frame.
	 * On native targets, this is used to call drawTiles.
	 */
	inline function flush () : Void
	{
		internalG.flush ();
		
		translations = [];
		pushTranslation (0, 0);
	}
	
	/**
	 * A helper function for Loader
	 * It takes a BitmapData (bmp) and creates an Image from it.
	 * If supplied, (img) is filled with (bmp) instead of creating a new Image.
	 * For best performance it uses Tilesheet API where supported.
	 */
	inline function registerImage (bmp : BitmapData) : ImageData
	{
		return internalG.registerImage (bmp);
	}
	
	/**
	 * This is only needed for native drawing. It does not do anything on Flash.
	 * This function is called after every Image was loaded using Loader class.
	 * It adds all Images to a TextureAtlas for best drawing performance.
	 */
	inline function finishedImageLoading () : Void
	{
		internalG.finishedImageLoading ();
	}
}