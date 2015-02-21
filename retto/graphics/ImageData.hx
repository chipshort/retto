package retto.graphics;
import openfl.display.BitmapData;

/**
 * The Image class is used for drawing. It is just a container for data.
 * @author Christoph Otter
 */
class ImageData
{
	static var imageMap = new Map<String, ImageData> ();
	
	public var width (get, null) : Int;
	public var height (get, null) : Int;
	
	var sheetIndex : Int;
	var bitmapData : BitmapData;
	
	inline function get_width () : Int { return bitmapData.width; }
	inline function get_height () : Int { return bitmapData.height; }
	
	function new (bmp : BitmapData) 
	{
		bitmapData = bmp;
		
		sheetIndex = -1;
	}
	
	static function fromBitmapData (bmp : BitmapData) : ImageData
	{
		var dataArray = bmp.getPixels (bmp.rect);
		#if !openfl_bitfive
		dataArray.compress ();
		#end
		var bmpData = dataArray.toString ();
		if (imageMap.exists (bmpData)) {
			return imageMap.get (bmpData);
		}
		
		//create new image
		var img = new ImageData (bmp);
		imageMap.set (bmpData, img);
		
		return img;
	}
	
}

/*
}*/