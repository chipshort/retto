package retto.graphics.scaling;
import retto.Game;

/**
 * This ScaleMode scales the Game as much as possible while keeping the same aspect ratio.
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