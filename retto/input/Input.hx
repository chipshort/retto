package retto.input;

import retto.input.Keyboard;

/**
 * Helper class to get information about active inputs (keys, etc.)
 * @author Christoph Otter
 */
class Input
{
	var inputDefinitions = new Map<String, Array<AcceptEither>> ();
	
	public function new ()
	{
	}
	
	/**
	 * Checks if the specified input is activated
	 * @param	input a String, a Key or a function
	 */
	public function check (input : AcceptEither /*AcceptEither<String, Key, Void -> Bool>*/) : Bool
	{
		switch (input.type) {
			case String:
				var str : String = input;
				if (inputDefinitions.exists (str)) { //defined input
					var def = inputDefinitions.get (str);
					for (i in 0 ... def.length) {
						var inp = def[i];
						if (check (inp)) { //recursive :D
							return true;
						}
					}
				}
				else { //a char
					var keycode = str.toUpperCase ().charCodeAt (0);
					return Keyboard.isKeyDown (keycode);
				}
			case Int:
				var key : Int = cast input;
				return Keyboard.isKeyDown (key);
			case null:
				var func : Void -> Bool = input;
				return func ();
			default:
				throw "No Type";
		}
		return false;
	}
	
	/**
	 * Define a new input.
	 * @param	input The name you want to give it. You need that later when checking
	 * @param	definitions a mixed array of Int (keycode), Strings (for chars or other definitions) and / or functions (Void -> Bool)
	 * @see oe.util.Macro.accept
	 */
	public inline function define (input : String, definitions : Array<AcceptEither>)
	{
		inputDefinitions.set (input, definitions);
	}
}


abstract AcceptEither (Dynamic) {
	public var type (get, never) : Dynamic;
	
	inline function get_type () : Dynamic {
		var ret : Dynamic = null;
		
		if (Reflect.isFunction (this)) {
			ret = null;
		}
		else if (Std.is (this, Int)) {
			ret = Int;
		}
		else if (Reflect.isEnumValue (this)) {
			ret = Type.getEnum (this);
		}
		else {
			ret = Type.getClass (this);
		}
		
		return ret;
	}
	
	public inline function new (e : Dynamic) this = e;
	
	@:from static function fromDynamic (v : Dynamic) : AcceptEither return new AcceptEither (v);
	@:to inline function toDynamic () : Dynamic return this;
}