package retto.graphics.scaling;
import retto.graphics.Graphics;

/**
 * A ScaleMode handles differnt window sizes.
 * This is especially important for mobile targets.
 * @author Christoph Otter
 */
class ScaleMode
{
	public var scaleX (default, null) : Float;
	public var scaleY (default, null) : Float;
	public var dX (default, null) : Float;
	public var dY (default, null) : Float;
	public var initWidth (default, null) : Int;
	public var initHeight (default, null) : Int;
	
	public function new (initW : Int, initH : Int)
	{
		scaleX = 1;
		scaleY = 1;
		dX = 0;
		dY = 0;
		initWidth = initW;
		initHeight = initH;
	}
	
	function stageResized (game : Game) : Void
	{
		initWidth = game.gameWidth;
		initHeight = game.gameHeight;
	}
	
	function render (game : Game, g : Graphics) : Void
	{
	}
}