package retto.input;
import openfl.events.KeyboardEvent;

/**
 * A helper class used to get information about what keys are down, it's recommended to use Input for such stuff.
 * @author Christoph Otter
 */
class Keyboard
{
	static var keys : Array<Int> = []; //array of keycodes
	static var pressed : Array<Int> = [];
	
	/**
	 * Checks if the key is currently down
	 * @param	key the key to check
	 */
	public static function isKeyDown (key : Int) : Bool
	{
		return keys.indexOf (key) != -1;
	}
	
	/**
	 * Checks if the key was pressed this frame
	 * @param	key the key to check
	 */
	public static function wasKeyPressed (key : Int) : Bool
	{
		return pressed.indexOf (key) != -1;
	}
	
	static function keyDown (e : KeyboardEvent) : Void
	{
		if (!isKeyDown (e.keyCode)) { //prevent duplicates
			keys.push(e.keyCode);
		}
	}
	
	static function keyUp (e : KeyboardEvent) : Void
	{
		keys.remove(e.keyCode);
		pressed.push (e.keyCode);
	}
	
	
	static function update () : Void
	{
		if (pressed.length > 0)
			pressed = [];
	}
	
}