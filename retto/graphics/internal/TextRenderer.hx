package retto.graphics.internal;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Christoph Otter
 */
class TextRenderer
{
	var tempTextField : TextField;
	var tempFormat : TextFormat;
	
	public function new ()
	{
		tempFormat = new TextFormat ();
		tempTextField = new TextField ();
		tempTextField.autoSize = LEFT;
		tempTextField.embedFonts = true;
		tempTextField.selectable = false;
	}
	
	/**
	 * Creates a new TextField with the given attributes.
	 */
	public function prepareTextField (text : String, color : Color, size : Float, font : String, style : Int) : TextField
	{
		if (font == null)
			font = Loader.defaultFontName;
		
		tempTextField.alpha = color.a;
		
		tempFormat.color = 0xFFFFFF & color;
		tempFormat.size = size;
		tempFormat.font = font;
		
		if ((style & Graphics.TextBold) != 0)
			tempFormat.bold = true;
		else
			tempFormat.bold = false;
		
		if ((style & Graphics.TextItalic) != 0)
			tempFormat.italic = true;
		else
			tempFormat.italic = false;
		
		if ((style & Graphics.TextUnderline) != 0)
			tempFormat.underline = true;
		else
			tempFormat.underline = false;
		
		tempTextField.text = text;
		tempTextField.defaultTextFormat = tempFormat;
		
		return tempTextField;
	}
	
}