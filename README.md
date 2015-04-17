# Retto
Retto is a game engine based on [OpenFL](http://www.openfl.org/) and [Haxe](http://haxe.org/). It is the backend for [Lutra](https://github.com/chipshort/lutra), but can also be used on it's own.

Retto is mainly centered about creating a consistant drawing API for all targets while still keeping high performance.
If you have any remarks about how to improve this, feel free to open an issue or contact me.
This is still WIP and in an early stage of development. Use it on your own risk.

## Installation
To install Retto, first install OpenFl: http://www.openfl.org/download/
Open up a terminal and run:
```
haxelib git retto https://github.com/chipshort/retto.git
```


## Getting Started
Retto is centered around the Game class. Here is a quick example, assuming there is an image in assets/img/player.png
```haxe
class Main
{
	public static function main () : Void
	{
		var test = new TestGame ();
		test.show ();
	}
}

class TestGame extends retto.Game
{
	var image : retto.graphics.ImageData;
	
	public function new ()
	{
		super ();
		
		image = loader.getImage ("assets/img/player.png");
	}
	
	override public function onInit () : Void
	{
		trace ("hello");
	}
	
	override public function onDraw (g : retto.graphics.Graphics) : Void
	{
		g.drawImage (image, 0, 0);
	}
}
```
For more, checkout the other examples.
