package retto.input;
import openfl.events.MouseEvent;

@fakeenum enum MouseButton
{
	Left;
	Right;
}

/**
 * A small helper class to get the Mouse info whenever you want
 * @author Christoph Otter
 */
class Mouse
{
	public static var x (default, null) : Int = 0;
	public static var y (default, null) : Int = 0;

	static var leftPressed : Bool = false;
	static var rightPressed : Bool = false;

	static var leftDown : Bool = false;
	static var rightDown : Bool = false;
	
	/**
	 * Checks if the specified mouse button was pressed this frame
	 * @param	btn the mouse button to check
	 */
	public static function wasPressed (btn : MouseButton) : Bool
	{
		if (btn == MouseButton.Left) {
			return leftPressed;
		}
		else {
			return rightPressed;
		}
	}

	/**
	 * Checks if the specified mouse button is currently down
	 * @param	btn the mouse button to check
	 */
	public static function isDown (btn : MouseButton) : Bool
	{
		if (btn == MouseButton.Left) {
			return leftDown;
		}
		else {
			return rightDown;
		}
	}

	static function setPosition (px : Int, py : Int) : Void
	{
		x = px;
		y = py;
		//fixToTargetRect();
	}

	static function setPressed (btn : MouseButton, value : Bool = true) : Void
	{
		if (btn == MouseButton.Left) {
			leftPressed = value;
		}
		else {
			rightPressed = value;
		}
	}

	static function setDown (btn : MouseButton, value : Bool = true) : Void
	{
		if (btn == MouseButton.Left) {
			leftDown = value;
		}
		else {
			rightDown = value;
		}
		
		if (value)
			setPressed (btn);
	}
	
	static function LeftMouseEvent (e : MouseEvent) : Void
	{
		if (e.buttonDown) {
			setDown (Left, true);
		}
		else {
			setDown (Left, false);
		}
	}
	
	static function RightMouseEvent (e : MouseEvent) : Void
	{
		if (e.buttonDown) {
			setDown (Right, true);
		}
		else {
			setDown (Right, false);
		}
	}
	
	static function update () : Void
	{
		setPressed (Left, false);
		setPressed (Right, false);
	}

	/**
	 * Makes sure the mouse coords stay within your game's screen, even if it's scaled
	 */
	/*static inline function fixToTargetRect() : Void
	{
		var rect = Game.the.painterTargetRect();

		//bind to target rectangle
		x = cast(Math.max(x, rect.x), Int);
		x = cast(Math.min(x, rect.x + rect.width), Int);
		y = cast(Math.max(y, rect.y), Int);
		y = cast(Math.min(y, rect.y + rect.height), Int);

		//transform to scaled coords
		x = Game.the.painterTransformMouseX(x, y);
		y = Game.the.painterTransformMouseY(x, y);
	}
*/

}