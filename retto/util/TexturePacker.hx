package retto.util;
import openfl.geom.Rectangle;
import retto.graphics.ImageData;

/**
 * This is a utility class for finding the best way to put Images into a Tilesheet.
 * It does not modify a real texture.
 * @author Christoph Otter
 */
class TexturePacker
{
	public var sheetTree = new Node ();
	public var imageNodes (default, null) = new ObjMap<ImageData, Node> ();
	
	public function new (maxWidth : Int, maxHeight : Int) 
	{
		sheetTree.rect = new Rectangle (0, 0, maxWidth, maxHeight);
	}
	
	/**
	 * Adds the given (img) to the texture tree.
	 * It returns the Node of (img), which contains a Rectangle (img) fits into.
	 * If (img) does not fit into the texture tree, null is returned.
	 */
	public function add (img : ImageData) : Node
	{
		//workaround to prevent putting in same Image multiple times
		if (imageNodes.exists (img))
			return imageNodes.get (img);
			
		//determine position to place image in
		var node = sheetTree.insert (img);
		
		if (node == null) return null;
		node.image = img;
		
		imageNodes.set (img, node);
		return node;
	}
	
	public function getRealRectangle () : Rectangle
	{
		var rect = new Rectangle ();
		
		for (node in imageNodes) {
			if (node.rect.right > rect.width)
				rect.width = node.rect.right;
			
			if (node.rect.bottom > rect.height)
				rect.height = node.rect.bottom;
		}
		
		return rect;
	}
	
	public static function closestPow2 (v : Int) : Int
	{
		var p = 2;
		while (p < v) {
			p = p << 1;
		}
		
		return p;
	}
	
}