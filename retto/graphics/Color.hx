package retto.graphics ;

/**
 * This is an abstract for Color. It is interchangable with Int.
 * Make sure you do not forget alpha (first two digits), otherwise your color is black
 * @example var c : Color = 0xFFFFFFFF;
 * @author Christoph Otter
 */
abstract Color (UInt) from UInt to UInt 
{
	//these range from 0 to 1
	public var r (get, set) : Float;
	public var g (get, set) : Float;
	public var b (get, set) : Float;
	public var a (get, set) : Float;
	
	public var rgb (get, never) : Int;
	
	public function new (v : UInt = 0x00000000)
	{
		this = v;
	}
	
	@:from public static inline function fromValue (v : UInt) : Color
	{
		return new Color (v);
	}
	
	public static inline function fromFloats (r : Float, g : Float, b : Float, a = 1.0) : Color
	{
		var c = new Color (0);
		c.setColor (r, g, b, a);
		
		return c;
	}
	
	@:to public inline function toInt () : Int
	{
		return this;
	}
	
	public inline function setColor (r : Float, g : Float, b : Float, a : Float) : Void
	{
		var r1 : UInt = Std.int (r * 255);
		var g1 : UInt = Std.int (g * 255);
		var b1 : UInt = Std.int (b * 255);
		var a1 : UInt = Std.int (a * 255);
		this = (a1 << 24) | (r1 << 16) | (g1 << 8) | b1;
	}
	
	public inline function mix (color : Color) : Color
	{
		var r = r * a * (1 - color.a) + color.r * color.a;
		var g = g * a * (1 - color.a) + color.g * color.a;
		var b = b * a * (1 - color.a) + color.b * color.a;
		var a = a * (1 - color.a) + color.a;
		
		return Color.fromFloats (r, g, b, a);
	}
	
	inline function get_r () : Float
	{
		return ((this & 0x00FF0000) >>> 16) / 255;
	}
	
	inline function get_g () : Float
	{
		return ((this & 0x0000FF00) >>> 8) / 255;
	}
	
	inline function get_b () : Float
	{
		return ((this & 0x000000FF)) / 255;
	}
	
	inline function get_a () : Float
	{
		return ((this & 0xFF000000) >>> 24) / 255;
	}
	
	inline function set_r (v : Float) : Float
	{
		setColor (v, g, b, a);
		return v;
	}
	
	inline function set_g (v : Float) : Float
	{
		setColor (r, v, b, a);
		return v;
	}
	
	inline function set_b (v : Float) : Float
	{
		setColor (r, g, v, a);
		return v;
	}
	
	inline function set_a (v : Float) : Float
	{
		setColor (r, g, b, v);
		return v;
	}
	
	inline function get_rgb () : Int
	{
		return fromFloats (r, g, b, 0); //<- hacky, but works
	}
	
}