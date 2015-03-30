package retto.graphics.internal;
import openfl.geom.Rectangle;
import retto.graphics.ImageData;
import retto.util.ObjMap;

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

/**
 * A helper class that is used to sort Images into a texture atlas
 * @author Christoph Otter
 */
class Node
{
	public var child1 : Node;
	public var child2 : Node;
    public var rect : Rectangle;
    public var image : ImageData;
	
	var parent : Node;
	
	public function new (?parent : Node) 
	{
	}
	
	/**
	 * Inserts an image into the texture atlas tree
	 * Algorithm from: http://www.blackpawn.com/texts/lightmaps/default.html
	 */
	public function insert (img : ImageData) : Node
	{
		//leave some space between the images (workaround for a small bug)
		var imgWidth = img.width + 1;
		var imgHeight = img.height + 1;
		
		if (child1 != null) { //not a leaf
			var newNode = child1.insert (img);
			if (newNode != null) return newNode;
			
			//there was not enough space
			return child2.insert (img);
		}
		else {
			if (image != null) return null; //node is filled already
			
			if (rect.width < imgWidth || rect.height < imgHeight) //node is too small
				return null;
			else if (rect.width == imgWidth && rect.height == imgHeight) //perfect size
				return this;
			else { //node is bigger than img, split node into two parts
				child1 = new Node (this);
				child2 = new Node (this);
				
				var w = rect.width - imgWidth;
				var h = rect.height - imgHeight;
				
				if (w > h) {
					child1.rect = new Rectangle (rect.x, rect.y, imgWidth, imgHeight);
					child2.rect = new Rectangle (rect.x + imgWidth, rect.y, w, rect.height);
				}
				else {
					child1.rect = new Rectangle (rect.x, rect.y, rect.width, imgHeight);
					child2.rect = new Rectangle (rect.x, rect.y + imgHeight, rect.width, rect.height - imgHeight);
				}
				
				return child1.insert (img);
			}
			
		}
	}
	
}