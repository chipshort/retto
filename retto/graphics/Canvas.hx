package retto.graphics;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author Christoph Otter
 */
@:access(retto.graphics.Graphics)
class Canvas extends ImageData
{
	/**
	 * Use this if you want to render to this Canvas outside of the rendering loop.
	 * This is null until you call the activate() function.
	 */
	public var graphics (default, null) : Graphics;
	
	public function new (width : Int, height : Int) 
	{
		super (new BitmapData (width, height, true, 0x00000000));
	}
	
	/**
	 * This is short for g.setCanvas (c);
	 * It is useful if you have no Graphics object
	 */
	public inline function activate () : Void
	{
		Graphics.graphics.setCanvas (this);
	}
	
	/**
	 * This is short for g.setCanvas (null);
	 */
	public inline function deactivate () : Void
	{
		Graphics.graphics.flush ();
		Graphics.graphics.setCanvas (null);
	}
}