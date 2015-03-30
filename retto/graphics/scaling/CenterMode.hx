package retto.graphics.scaling;

/**
 * ...
 * @author Christoph Otter
 */
class CenterMode extends ScaleMode
{
	
	override function stageResized (game : Game) : Void
	{
		dx = (game.gameWidth - initWidth) / 2;
		dy = (game.gameHeight - initHeight) / 2;
	}
	
}