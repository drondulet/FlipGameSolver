package scene;

import openfl.display.Sprite;
import model.Point;

using scene.SceneHelper;

class Tile extends Sprite {
	
	public var size(default, null): Int;
	public var index(default, null): IntPoint;
	
	private var isTurned: Bool;
	
	public function new(size: Int, index: IntPoint, isTurned: Bool) {
		
		super();
		
		this.size = size;
		this.index = index;
		this.isTurned = isTurned;
		
		this.addBmp({x: this.size, y: this.size});
		
		setState(isTurned);
	}
	
	public function setState(isTurned: Bool): Void {
		isTurned ? changeColor(Settings.tileTurnedColor) : changeColor(Settings.tileNotTurnedColor);
	}
	
	private function changeColor(color: Int) {
		this.fillColor(color, { x: 0, y: 0, width: size, height: size }, size * 0.5);
	}
}