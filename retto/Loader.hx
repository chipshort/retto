package retto;
import openfl.Assets;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.net.SharedObject;
import openfl.text.Font;
import openfl.utils.ByteArray;
import retto.graphics.Graphics;
import retto.graphics.ImageData;

/**
 * ...
 * @author Christoph Otter
 */
class Loader
{
	public static var defaultFontName (default, null) : String;
	static var defaultFont : Font;
	
	var game : Game;
	var images = new Map<String, ImageData> ();
	
	public function new (container : Game)
	{
		game = container;
		
		if (defaultFont == null) {
			defaultFont = getFont ("assets/retto/kenpixel.ttf");
			defaultFontName = defaultFont.fontName;
		}
		
		#if (debug && !openfl_bitfive)
		Assets.addEventListener (Event.CHANGE, onChange);
		#end
	}
	
	/**
	 * Returns the Image for the given asset (id).
	 * @param autobatching if true, the Image is added to a TextureAtlas
	 * on native platforms to speed up rendering. you should only disable this
	 * if you draw this only once or want to use it as a TileMap / Tilesheet yourself.
	 */
	@:access(retto.Game)
	@:access(retto.graphics.Graphics)
	@:access(retto.graphics.ImageData)
	public function getImage (id : String, autobatching = true) : ImageData
	{
		if (images.exists (id)) return images.get (id);
		
		var bmpData = Assets.getBitmapData (id);
		
		if (bmpData == null) throw "There is no asset with the id: " + id;
		
		var img = autobatching ? game.g.registerImage (bmpData) : new ImageData (bmpData);//ImageData.fromBitmapData (bmpData);
		images.set (id, img);
		
		return img;
	}
	
	public inline function getMusic (id : String) : Sound
	{
		return Assets.getMusic (id);
	}
	
	public inline function getSound (id : String) : Sound
	{
		return Assets.getSound (id);
	}
	
	public inline function getText (id : String) : String
	{
		return Assets.getText (id);
	}
	
	public inline function getBytes (id : String) : ByteArray
	{
		return Assets.getBytes (id);
	}
	
	public inline function getFont (id : String) : Font
	{
		return Assets.getFont (id);
	}
	
	public inline function getDataStore (name : String) : SharedObject
	{
		return SharedObject.getLocal (name);
	}
	
	#if debug
	function onChange (e : Event) : Void
	{
		trace ("changed");
		//TODO: implement this
	}
	#end
}