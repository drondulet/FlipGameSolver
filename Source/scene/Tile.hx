package scene;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import model.Point;

class Tile extends Sprite {
	
	static private final turnedColor: Int = 0x24AFC4;
	static private final notTurnedColor: Int = 0x24AFC4 - 0x242424;
	
	public var size(default, null): Int;
	public var index: IntPoint;
	
	private var isTurned: Bool;
	
	public function new(size: Float, index: IntPoint, isTurned: Bool) {
		
		super();
		
		this.size = Std.int(size);
		this.index = index;
		this.isTurned = isTurned;
		
		var color: Int = isTurned ? turnedColor : notTurnedColor;
		graphics.beginFill(color);
		graphics.drawRoundRect(0, 0, size, size, size * 0.5, size * 0.5);
		graphics.endFill();
		
		var bmpData: BitmapData = new BitmapData(this.size, this.size, true);
		graphics.beginBitmapFill(bmpData);
		graphics.endFill();
		
		var bmp: Bitmap = new Bitmap(bmpData);
		bmp.visible = false;
		addChild(bmp);
		
		cacheAsBitmap = true;
	}
	
	public function setState(isTurned: Bool): Void {
		
		if (isTurned) {
			changeColor(turnedColor);
		}
		else {
			changeColor(notTurnedColor);
		}
	}
	
	public function changeColor(color: Int) {
		
		graphics.beginFill(color);
		graphics.drawRoundRect(0, 0, size, size, size * 0.5, size * 0.5);
		graphics.endFill();
	}
}