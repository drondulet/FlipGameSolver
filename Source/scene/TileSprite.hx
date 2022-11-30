package scene;

import model.Point;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Quad;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

using GraphicsHelper;

class TileSprite extends Sprite {
	
	public var size(default, null): Int;
	public var index(default, null): IntPoint;
	
	private var isTurned: Bool;
	private var sizeActuator: Null<GenericActuator<TileSprite>>;
	private var flipActuator: Null<GenericActuator<TileSprite>>;
	
	public function new(size: Int, index: IntPoint, isTurned: Bool) {
		
		super();
		
		this.size = size;
		this.index = index;
		this.isTurned = isTurned;
		
		setState(isTurned);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
	}
	
	public function setState(isTurned: Bool): Void {
		isTurned ? changeColor(Settings.tileTurnedColor) : changeColor(Settings.tileNotTurnedColor);
	}
	
	private function changeColor(color: Int): Void {
		
		function fill(): Void {
			
			var sizeHalf: Float = size * 0.5;
			this.fillColor(color, { x: -sizeHalf, y: -sizeHalf, width: size, height: size }, sizeHalf);
		}
		
		function actuatorfill(): Void {
			
			fill();
			flipActuator = Actuate.tween(this, 0.1, {"scaleX": 1.0}).onComplete(() -> flipActuator = null).ease(Quad.easeOut);
		}
		
		if (flipActuator == null) {
			flipActuator = Actuate.tween(this, 0.1, {"scaleX": 0.1}).onComplete(actuatorfill).ease(Quad.easeIn);
		}
		else {
			fill();
		}
	}
	
	private function onMouseOver(e: Event): Void {
		
		if (flipActuator != null) {
			return;
		}
		
		if (sizeActuator == null) {
			sizeActuator = Actuate.tween(this, 0.1, {"scaleX": 0.9, "scaleY": 0.9})
				.reverse()
				.onComplete(() -> { scaleX = 1.0; scaleY = 1.0; sizeActuator = null; });
		}
	}
}