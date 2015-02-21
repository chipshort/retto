package retto.graphics;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.geom.Rectangle;

/**
 * This represents a tile map.
 * Tiles are numbered from top left to bottom right:
	 * 0 1 2 3
	 * 4 5 6 7
 * @author Christoph Otter
 */
class TileMap extends Tilesheet
{
	/**
	 * Creates a TileMap
	 * @param	img an Image that was loaded using autobatching = false or a Canvas
	 * @param	spacing the space between two tiles in pixels
	 * @param	margin the space between the (img)'s borders and the outer tiles
	 */
	@:access(retto.graphics.ImageData)
	public function new (img : ImageData, spacing : Int, margin : Int, tilewidth : Int, tileheight : Int) 
	{
		super (img.bitmapData);
		
		var temp = 2 * margin + spacing;
		
		var numX = Std.int ((img.width - temp) / (tilewidth + spacing));
		var numY = Std.int ((img.height - temp) / (tileheight + spacing));
		
		for (y in 0 ... numY) {
			for (x in 0 ... numX) {
				var tx = margin + x * (tilewidth + spacing);
				var ty = margin + y * (tileheight + spacing);
				addTileRect (new Rectangle (tx, ty, tilewidth, tileheight));
			}
		}
	}
	
}