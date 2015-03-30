package retto.graphics;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.events.Event;
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
@:access(retto.graphics.scaling.ScaleMode)
class Graphics
{
	//TODO: add primitive drawing (lines, points, circles, rects ...)
	
	//text styles
	public static inline var TextBold = 1; 		//001
	public static inline var TextItalic = 2; 	//010
	public static inline var TextUnderline = 4; //100
	
	/** Singleton needed for Canvas drawing */
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
		var g = getGraphics ();
		return g.translations[g.translations.length - 2];
	}
	inline function get_translateY () : Float
	{
		var g = getGraphics ();
		return g.translations[g.translations.length - 1];
	}
	
	inline function get_color () : Color
	{
		var g = getGraphics ();
		return g.colors[g.colors.length - 1];
	}
	
	inline function get_smoothing () : Bool
	{
		var g = getGraphics ();
		return g.smoothing[g.smoothing.length - 1];
	}
	
	function new (container : Game)
	{
		graphics = this;
		game = container;
		
		#if server
		internalG = new InternalGraphics (container);
		#elseif native
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
		getGraphics ().colors.push (c);
	}
	
	/**
	 * Revert to the previously active Color.
	 */
	public inline function popColor () : Void
	{
		getGraphics ().colors.pop ();
	}
	
	/**
	 * Set the currently active (translationX, translationY) to (x, y).
	 */
	public inline function pushTranslation (x : Float, y : Float) : Void
	{
		var g = getGraphics ();
		
		g.translations.push (x);
		g.translations.push (y);
	}
	
	/**
	 * Revert to the previously active translation.
	 */
	public inline function popTranslation () : Void
	{
		var g = getGraphics ();
		
		g.translations.pop ();
		g.translations.pop ();
	}
	
	/**
	 * Set if smoothing is currently active.
	 */
	public inline function pushSmoothing (s : Bool) : Void
	{
		var g = getGraphics ();
		g.smoothingBeforePushed (s);
		g.smoothing.push (s);
	}
	
	/**
	 * Revert to the previous state of smoothing.
	 */
	public inline function popSmoothing () : Void
	{
		getGraphics ().smoothing.pop ();
	}
	
	/**
	 * Draws the given (img) at (x, y) and rotated by (angle)°
	 * @param	x, y defined as the top-left coordinate of the drawn image (before rotation)
	 */
	public inline function drawImage (img : ImageData, x : Float, y : Float, angle : Float = 0, anchorX : Float = 0, anchorY : Float = 0) : Void
	{
		if (color.a == 0 || isOffScreen (x, y, img.width, img.height))
			return;
		
		getGraphics ().drawImage (img, x + translateX, y + translateY, angle, anchorX, anchorY);
	}
	
	/**
	 * Draws the given (img) at (x, y) with the given (width) and (height), rotated by (angle)° around (anchorX, anchorY).
	 * @param	x, y see drawImage
	 */
	public inline function drawImage2 (img : ImageData, x : Float, y : Float, width : Float, height : Float, angle : Float = 0, anchorX : Float = 0, anchorY : Float = 0) : Void
	{
		if (color.a == 0 || isOffScreen (x, y, width, height))
			return;
		
		getGraphics ().drawImage2 (img, x + translateX, y + translateY, width, height, angle, anchorX, anchorY);
	}
	
	/**
	 * Draws the given (text) at (x, y) with the currently set (color), (size), (font) and (style)
	 * @param	x, y top-left coordinate of the drawn text
	 * @param	font if null, Loader.defaultFontName is used
	 * @param	style can be Graphics.TextBold, Graphics.TextItalic and/or Graphics.TextUnderline
	 * @example graphics.drawText ("Retto rules!", 0, 0, 0xFFFFFFFF, 12, null, Graphics.TextBold | Graphics.TextItalic);
	 */
	public inline function drawText (text : String, x : Float, y : Float, size = 16.0, ?font : String, style = 0) : Void
	{
		getGraphics ().drawText (text, x + translateX, y + translateY, size, font, style);
	}
	
	/**
	 * Draws the tile at (index) of (sheet) at the position (x, y) with (width) and (height) as dimensions, rotated by (angle)° around (aX, aY).
	 * It is not recommended to use your own Tilesheets, since Retto automatically creates one for you, but it might be usefull for Tilemaps, etc.
	 * @param	data is an Array of Float values looking like this: [x + matrix.tx, y + matrix.ty, index, matrix.a, matrix.b, matrix.c, matrix.d, ...]
	 */
	public function drawTilesheet (sheet : Tilesheet, data : Array<Float>) : Void
	{
		var data = data.copy ();
		
		if (data.length < 7) return;
		
		data[0] += translateX;
		data[1] += translateY;
		getGraphics ().drawTilesheet (sheet, data);
	}
	
	public inline function drawCircle (centerX : Float, centerY : Float, rad : Float, fill = false) : Void
	{
		getGraphics ().drawCircle (centerX, centerY, rad, fill);
	}
	
	public function drawRect (x : Float, y : Float, width : Float, height : Float, fill = false) : Void
	{
		getGraphics ().drawRect (x, y, width, height, fill);
	}
	
	public function drawLine (x0 : Float, y0 : Float, x1 : Float, y1 : Float) : Void
	{
		getGraphics ().drawLine (x0, y0, x1, y1);
	}
	
	/*public function drawPoint (x : Float, y : Float) : Void
	{
		getGraphics ().drawPoint (x, y);
	}*/
	
	/**
	 * Clears the screen.
	 */
	public inline function clear () : Void
	{
		getGraphics ().clear ();
	}
	
	/**
	 * Fills the screen with (color).
	 */
	public inline function fill () : Void
	{
		getGraphics ().fill ();
	}
	
	/**
	 * An event listener registered in Game class.
	 */
	function stageResized (e : Event) : Void
	{
		game.scaleMode.stageResized (game);
		
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
			sW = game.scaleMode.initWidth;
			sH = game.scaleMode.initHeight;
			/*sW = game.gameWidth;
			sH = game.gameHeight;*/
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
		
		game.scaleMode.render (game, this);
		
		var g = getGraphics ();
		
		if (g.translations.length != 2 || g.translations[0] != 0 || g.translations[1] != 0) {
			getGraphics ().translations = [];
			pushTranslation (0, 0);
		}
		
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
	
	inline function getGraphics () : InternalGraphics
	{
		return canvasGraphics == null ? internalG : canvasGraphics;
	}
}