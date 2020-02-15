package scene;

import model.Point;
import model.Rect;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class SceneHelper {
	
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
}