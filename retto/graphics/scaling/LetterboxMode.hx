package retto.graphics.scaling;
import retto.Game;
import retto.graphics.Color;
import retto.graphics.Graphics;

/**
 * ...
 * @author Christoph Otter
 */
class LetterboxMode extends ScaleMode
{
	
	override function stageResized (game : Game) : Void
	{
		var gW = game.gameWidth;
		var gH = game.gameHeight;
		
		var sX = gW / initWidth;
		var sY = gH / initHeight;
		
		scaleX = scaleY = Math.min (sX, sY);
		
		dX = (gW - initWidth * scaleX) / 2;
		dY = (gH - initHeight * scaleY) / 2;
	}
	
}