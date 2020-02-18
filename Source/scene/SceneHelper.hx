package scene;

import model.Point;
import model.Rect;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;

using scene.SceneHelper;

class SceneHelper {
	
	static private final textFormat: TextFormat = new TextFormat("Lucida", 18, Settings.textColor);
	static private final textFormatNums: TextFormat = new TextFormat("Lucida", 20, Settings.textColor, true);
	
	static public function fillColor(object: Sprite, color: Int, rect: Rect, ?ellips: Float = 0): Void {
		
		object.graphics.clear();
		object.graphics.beginFill(color);
		object.graphics.drawRoundRect(rect.x, rect.y, rect.width, rect.height, ellips);
		object.graphics.endFill();
	}
	
	static public function addBmp(object: Sprite, size: IntPoint, ?name: Null<String> = null, ?isVisible: Bool = false): Void {
		
		var bmpData: BitmapData = new BitmapData(size.x, size.y);
		object.graphics.beginBitmapFill(bmpData);
		object.graphics.endFill();
		
		var bmp: Bitmap = new Bitmap(bmpData);
		bmp.visible = isVisible;
		bmp.name = name != null ? name : bmp.name;
		object.addChild(bmp);
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
		// input.border = true;
		
		return input;
	}
	
	static public function createButton(pos: IntPoint, size: IntPoint, text: String, ?textBtnName: Null<String> = null): Sprite {
		
		var button: Sprite = new Sprite();
		button.x = pos.x;
		button.y = pos.y;
		button.useHandCursor = true;
		button.buttonMode = true;
		
		button.fillColor(Settings.buttonColor, {x: 0, y: 0, width: size.x, height: size.y}, 10);
		button.addBmp(size);
		
		var text: TextField = createStaticText(Std.int(size.x * 0.15), Std.int(size.y * 0.1), text);
		text.name = textBtnName != null ? textBtnName : text.name;
		button.addChild(text);
		
		return button;
	}
}