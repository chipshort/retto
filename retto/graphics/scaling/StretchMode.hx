package retto.graphics.scaling;
import retto.Game;

/**
 * This ScaleMode scales the Game as much as possible in x and y direction. This might distort the Game.
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