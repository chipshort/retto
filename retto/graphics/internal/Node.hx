package retto.graphics.internal;
import openfl.geom.Rectangle;
import retto.graphics.ImageData;

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
		if (child1 != null) { //not a leaf
			var newNode = child1.insert (img);
			if (newNode != null) return newNode;
			
			//there was not enough space
			return child2.insert (img);
		}
		else {
			if (image != null) return null; //node is filled already
			
			if (rect.width < img.width || rect.height < img.height) //node is too small
				return null;
			else if (rect.width == img.width && rect.height == img.height) //perfect size
				return this;
			else { //node is bigger than img, split node into two parts
				child1 = new Node (this);
				child2 = new Node (this);
				
				var w = rect.width - img.width;
				var h = rect.height - img.height;
				
				if (w > h) {
					child1.rect = new Rectangle (rect.x, rect.y, img.width, img.height);
					child2.rect = new Rectangle (rect.x + img.width, rect.y, w, rect.height);
				}
				else {
					child1.rect = new Rectangle (rect.x, rect.y, rect.width, img.height);
					child2.rect = new Rectangle (rect.x, rect.y + img.height, rect.width, rect.height - img.height);
				}
				
				return child1.insert (img);
			}
			
		}
	}
	
}