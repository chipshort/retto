package retto.graphics.scaling;
import retto.Game;

/**
 * ...
 * @author Christoph Otter
 */
class StretchMode extends ScaleMode
{
	var initWidth : Int;
	var initHeight : Int;
	
	public function new (initW : Int, initH : Int)
	{
		super ();
		
		initWidth = initW;
		initHeight = initH;
	}
	
	override function stageResized (game : Game) : Void
	{
	}
	
}