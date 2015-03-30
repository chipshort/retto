package retto.graphics.scaling;
import retto.Game;

/**
 * ...
 * @author Christoph Otter
 */
class StretchMode extends ScaleMode
{
	
	override function stageResized (game : Game) : Void
	{
		scaleX = game.gameWidth / initWidth;
		scaleY = game.gameHeight / initHeight;
	}
	
}