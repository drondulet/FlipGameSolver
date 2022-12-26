package;

import model.Rect;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

using GraphicsHelper;


class GraphicsHelper {
	
	#if mobile
	static private final textFormat: TextFormat = new TextFormat("PT Astra Sans", 36, Settings.textColor);
	static private final textFormatNums: TextFormat = new TextFormat("Roboto Bold", 36, Settings.textColor, true);
	#else
	static private final textFormat: TextFormat = new TextFormat("PT Astra Sans", 18, Settings.textColor);
	static private final textFormatNums: TextFormat = new TextFormat("Roboto Bold", 18, Settings.textColor, true);
	#end
	
	static public function fillBitmap(object: DisplayObjectContainer, color: Int, rect: Rect, ?ellips: Float = 0, ?alpha: Float = 1): Void {
		
		disposeBitmap(object);
		
		var container: Sprite = new Sprite();
		container.fillColor(color, {x: rect.x, y: rect.y, width: rect.width, height: rect.height}, ellips, alpha);
		var bmp: BitmapData = new BitmapData(Std.int(rect.width), Std.int(rect.height), true, 0x000000FF);
		bmp.draw(container);
		
		object.addChild(new Bitmap(bmp));
	}
	
	static public function disposeBitmap(object: DisplayObjectContainer): Void {
		
		for (i in 0 ... object.numChildren) {
			cast(object.getChildAt(i), Bitmap).bitmapData.dispose();
		}
		object.removeChildren();
	}
	
	static public function fillColor(object: Sprite, color: Int, rect: Rect, ?ellips: Float = 0, ?alpha: Float = 1): Void {
		
		object.graphics.clear();
		object.graphics.beginFill(color, alpha);
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
		input.width = input.height * 1.5;
		input.border = true;
		
		return input;
	}
	
	static public function createStaticText(x: Int, y: Int, text: String): TextField {
		
		var tf: TextField = new TextField();
		tf.defaultTextFormat = textFormat;
		tf.x = x;
		tf.y = y;
		tf.text = text;
		tf.width = tf.textWidth;
		tf.height = tf.textHeight;
		tf.selectable = false;
		// tf.border = true;
		
		return tf;
	}
}