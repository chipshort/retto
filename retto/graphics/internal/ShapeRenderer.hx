package retto.graphics.internal;
import openfl.display.Graphics;
import retto.graphics.Color;

/**
 * A Helper class used for rendering shapes.
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
		setStyle (color, fill);
		
		g.drawCircle (centerX, centerY, rad);
		
		endStyle (fill);
	}
	
	public function drawRect (x : Float, y : Float, width : Float, height : Float, fill : Bool, color : Color) : Void
	{
		setStyle (color, fill);
		
		g.drawRect (x, y, width, height);
		
		endStyle (fill);
	}
	
	public function drawLine (x0 : Float, y0 : Float, x1 : Float, y1 : Float, color : Color) : Void
	{
		var c = color.rgb;
		
		g.lineStyle (1, c, color.a);
		
		g.moveTo (x0, y0);
		g.lineTo (x1, y1);
	}
	
	function setStyle (color : Color, fill : Bool) : Void
	{
		var c = color.rgb;
		
		if (fill) {
			#if !flash
			g.lineStyle (null); //small fix, because this causes outlines in flash, but prevents them in every other place
			#end
			
			g.beginFill (c, color.a);
		}
		else {
			g.lineStyle (1, c, color.a);
		}
	}
	
	inline function endStyle (fill : Bool) : Void
	{
		if (fill)
			g.endFill ();
	}
}