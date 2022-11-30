package;

import model.Rect;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

using GraphicsHelper;


class GraphicsHelper {
	
	static private final textFormat: TextFormat = new TextFormat("PT Astra Sans", 18, Settings.textColor);
	static private final textFormatNums: TextFormat = new TextFormat("Lucida", 20, Settings.textColor, true);
	
	static public function fillColor(object: Sprite, color: Int, rect: Rect, ?ellips: Float = 0): Void {
		
		object.graphics.clear();
		object.graphics.beginFill(color);
		object.graphics.drawRoundRect(rect.x, rect.y, rect.width, rect.height, ellips);
		object.graphics.endFill();
	}
	
	static public function createInputText(x: Int, y: Int, name: String): TextField {
		
		var input: TextField = new TextField();
		input.type = TextFieldType.INPUT;
		input.defaultTextFormat = textFormatNums;
		input.x = x;
		input.y = y;
		input.name = name;
		input.height = input.textHeight + 2;
		input.width = 50;
		input.border = true;
		
		return input;
	}
	
	static public function createStaticText(x: Int, y: Int, text: String): TextField {
		
		var input: TextField = new TextField();
		input.defaultTextFormat = textFormat;
		input.x = x;
		input.y = y;
		input.text = text;
		input.height = input.textHeight + 2;
		input.width = text.length * 12;
		input.selectable = false;
		// input.border = true;
		
		return input;
	}
}