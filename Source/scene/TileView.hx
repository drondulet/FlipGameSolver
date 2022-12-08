package scene;

import collision.RectangleMouseCollider;
import model.Point.IntPoint;
import motion.Actuate;
import motion.actuators.GenericActuator;
import openfl.display.Tile;

enum TileState {
	normal;
	flipped;
}

class TileView extends Tile {
	
	static public function create(normalIdx: Int, flippedIdx: Int, size: IntPoint, ?flipped: Bool = false): TileView {
		
		var inst: TileView = new TileView(size);
		
		inst.indexByState = [
			TileState.normal => normalIdx,
			TileState.flipped => flippedIdx
		];
		
		var state: TileState = flipped ? TileState.flipped : TileState.normal;
		inst.setState(state);
		
		return inst;
	}
	
	public final collider: RectangleMouseCollider;
	
	private var state: TileState;
	private var indexByState: Map<TileState, Int>;
	private var sizeActuator: Null<GenericActuator<TileView>>;
	private var flipActuator: Null<GenericActuator<TileView>>;
	
	private function new(size: IntPoint) {
		
		super();
		state = TileState.normal;
		collider = new RectangleMouseCollider({x: 0, y: 0}, {x: size.x, y: size.y});
		collider.receiver.onMouseOver = onMouseOver;
		collider.receiver.onMouseClick = onClick;
	}
	
	public function setState(newState: TileState): Void {
		
		switch ([state, newState]) {
			case [normal, flipped]: id = indexByState[flipped];
			case [flipped, normal]: id = indexByState[normal];
			
			default:
		}
		
		state = newState;
	}
	
	public function flip(): Void {
		
		var newState = 
			switch (state) {
				case normal: TileState.flipped;
				case flipped: TileState.normal;
			}
		
		setState(newState);
	}
	
	private function onClick(): Void {
		
		// remove and add callback to main game
		var newState = 
			switch (state) {
				case normal: TileState.flipped;
				case flipped: TileState.normal;
			}
		
		setState(newState);
	}
	
	private function onMouseOver(): Void {
		
		if (flipActuator != null) {
			return;
		}
		
		if (sizeActuator == null) {
			sizeActuator = Actuate.tween(this, 0.1, {"scaleX": 0.9, "scaleY": 0.9})
				.reverse()
				.onComplete(() -> { scaleX = 1.0; scaleY = 1.0; sizeActuator = null; });
		}
	}
	
	override private function set_x(value: Float): Float {
		collider.x = value - originX;
		return super.set_x(value);
	}
	
	override private function set_y(value: Float): Float {
		collider.y = value - originY;
		return super.set_y(value);
	}
	
	override private function set_originX(value: Float): Float {
		collider.x = x - value;
		return super.set_originX(value);
	}
	
	override private function set_originY(value: Float): Float {
		collider.y = y - value;
		return super.set_originY(value);
	}
	
	private function setStateIndecies(): Void {
		
	}
}