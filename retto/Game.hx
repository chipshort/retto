package retto ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.Lib;
import retto.graphics.Graphics;
import retto.graphics.scaling.ScaleMode;
import retto.input.Input;
import retto.input.Keyboard;
import retto.input.Mouse;

/**
 * The Game class is your main entry point for this engine
 * @author Christoph Otter
 */
@:access(retto.input.Keyboard)
@:access(retto.input.Mouse)
@:access(retto.graphics.Graphics)
@:access(retto.graphics.scaling.ScaleMode)
class Game extends Sprite
{
	public var loader (default, null) : Loader;
	public var input /*(default, null)*/ : Input;
	
	public var scaleMode (default, set) = new ScaleMode ();
	
	public var gameWidth (get, null) : Int;
	public var gameHeight (get, null) : Int;
	
	public var fpsCapping : Bool = true;
	
	var g (default, null) : Graphics;
	var lastTime : Int;
	var inited = false;
	
	inline function get_gameWidth () : Int { return Lib.current.stage.stageWidth; }
	inline function get_gameHeight () : Int { return Lib.current.stage.stageHeight; }
	
	inline function set_scaleMode (mode : ScaleMode) : ScaleMode {
		if (mode == null) mode = new ScaleMode ();
		
		scaleMode = mode;
		scaleMode.stageResized (this);
		
		return scaleMode;
	}
	
	public function new ()
	{
		super ();
		
		input = new Input ();
		loader = new Loader (this);
		g = new Graphics (this);
		
		enableEventHandlers ();
	}
	
	/**
	 * Call this function when you are finished loading Images.
	 * This is needed for auto batching of Images.
	 * If you load more Images after calling this, those are not batched.
	 */
	public inline function finishLoading () : Void
	{
		g.finishedImageLoading ();
	}
	
	/**
	 * Adds event handlers
	 */
	public function enableEventHandlers () : Void
	{
		addEventListener (Event.ADDED_TO_STAGE, init);
		addEventListener (Event.REMOVED_FROM_STAGE, removed);
	}
	
	/**
	 * This is called when the Game was added to the stage
	 * and after all event listeners where added.
	 */
	public function onInit () : Void
	{
	}
	
	/**
	 * Put all your drawing code in here.
	 * Don't do time critical calculations here, use onUpdate for that.
	 */
	public function onDraw (g : Graphics) : Void
	{
	}
	
	/**
	 * Put your updating code here (rotation stuff, AI).
	 * This is for everything where timing is important.
	 */
	public function onUpdate (dt : Float) : Void
	{
	}
	
	function enterFrame (e : Event) : Void
	{
		var cur = Lib.getTimer ();
		var dt = (cur - lastTime) / 1000;
		
		lastTime = cur;
		
		var maxDt = 1.5 / stage.frameRate;
		if (fpsCapping && dt > maxDt) {
			dt = maxDt;
		}
		
		
		Mouse.setPosition (Std.int (Math.max (mouseX, 0)), Std.int (Math.max (mouseY, 0)));
		
		onUpdate (dt);
		Keyboard.update ();
		Mouse.update ();
		
		onDraw (g);
		
		g.flush ();
	}
	
	function init (e : Event) : Void
	{
		stage.addEventListener (KeyboardEvent.KEY_DOWN, Keyboard.keyDown);
		stage.addEventListener (KeyboardEvent.KEY_UP, Keyboard.keyUp);
		stage.addEventListener (MouseEvent.MOUSE_DOWN, Mouse.LeftMouseEvent);
		stage.addEventListener (MouseEvent.MOUSE_UP, Mouse.LeftMouseEvent);
		stage.addEventListener (MouseEvent.RIGHT_MOUSE_DOWN, Mouse.RightMouseEvent);
		stage.addEventListener (MouseEvent.RIGHT_MOUSE_UP, Mouse.RightMouseEvent);
		
		stage.addEventListener (Event.RESIZE, g.stageResized);
		
		addEventListener (Event.ENTER_FRAME, enterFrame);
		
		lastTime = Lib.getTimer ();
		
		if (!inited) {
			g.stageResized (null);
			onInit ();
			inited = true;
		}
	}
	
	function removed (e : Event) : Void
	{
		stage.removeEventListener (KeyboardEvent.KEY_DOWN, Keyboard.keyDown);
		stage.removeEventListener (KeyboardEvent.KEY_UP, Keyboard.keyUp);
		stage.removeEventListener (MouseEvent.MOUSE_DOWN, Mouse.LeftMouseEvent);
		stage.removeEventListener (MouseEvent.MOUSE_UP, Mouse.LeftMouseEvent);
		stage.removeEventListener (MouseEvent.RIGHT_MOUSE_DOWN, Mouse.RightMouseEvent);
		stage.removeEventListener (MouseEvent.RIGHT_MOUSE_UP, Mouse.RightMouseEvent);
		
		stage.removeEventListener (Event.RESIZE, g.stageResized);
		
		removeEventListener (Event.ENTER_FRAME, enterFrame);
	}
	
	public function dispose () : Void
	{
		g.dispose ();
		
		removeEventListener (Event.ADDED_TO_STAGE, init);
		removeEventListener (Event.REMOVED_FROM_STAGE, removed);
	}
	
}