package retto.graphics.internal;
import openfl.display.Graphics;
import openfl.display.Shape;
import retto.graphics.Color;

/**
 * ...
 * @author Christoph Otter
 */
class ShapeRenderer
{
	var g : Graphics;
	
	public function new (graphics : Graphics) 
	{
		g = graphics;
	}
	
	public function drawCircle (centerX : Float, centerY : Float, rad : Float, fill : Bool, color : Color) : Void
	{
		var c = color.rgb;
		
		if (fill)
			g.beginFill (c, color.a);
		else
			g.lineStyle (1, c, color.a);
		
		g.drawCircle (centerX, centerY, rad);
		
		if (fill)
			g.endFill ();
	}
	
	public function drawRect (x : Float, y : Float, width : Float, height : Float, fill : Bool, color : Color) : Void
	{
		var c = color.rgb;
		
		if (fill)
			g.beginFill (c, color.a);
		else
			g.lineStyle (1, c, color.a);
		
		g.drawRect (x, y, width, height);
		
		if (fill)
			g.endFill ();
	}
	
	public function drawLine (x0 : Float, y0 : Float, x1 : Float, y1 : Float, color : Color) : Void
	{
		var c = color.rgb;
		
		g.lineStyle (1, c, color.a);
		
		g.moveTo (x0, y0);
		g.lineTo (x1, y1);
	}
}