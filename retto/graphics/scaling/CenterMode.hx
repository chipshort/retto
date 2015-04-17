package retto.graphics.scaling;

/**
 * This ScaleMode centers the Game on the screen without actually scaling it.
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