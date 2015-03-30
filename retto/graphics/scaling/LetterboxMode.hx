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
	var initWidth : Int;
	var initHeight : Int;

	public function new (initW : Int, initH : Int) : Void
	{
		super ();
		
		initWidth = initW;
		initHeight = initH;
	}
	
	override function stageResized (game : Game) : Void
	{
		var gW = game.gameWidth;
		var gH = game.gameHeight;
		
		var sX = gW / initWidth;
		var sY = gH / initHeight;
		
		scaleX = scaleY = Math.min (sX, sY);
		
		dX = Math.abs (gW - initWidth * scaleX) / 2;
		dY = Math.abs (gH - initHeight * scaleY) / 2;
	}
	
}