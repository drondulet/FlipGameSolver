package scene;

import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Quad;
import openfl.display.Tile;

enum TileState {
	normal;
	flipped;
}

class TileView extends Tile {
	
	static public function create(normalIdx: Int, flippedIdx: Int, ?flipped: Bool = false): TileView {
		
		var inst: TileView = new TileView();
		
		inst.indexByState = [
			TileState.normal => normalIdx,
			TileState.flipped => flippedIdx
		];
		
		var state: TileState = flipped ? TileState.flipped : TileState.normal;
		inst.setState(state);
		
		return inst;
	}
	
	private var state: TileState;
	private var indexByState: Map<TileState, Int>;
	private var sizeActuator: Null<GenericActuator<TileView>>;
	private var flipActuator: Null<GenericActuator<TileView>>;
	
	private function new() {
		
		super();
		state = TileState.normal;
	}
	
	public function onMouseOver(): Void {
		
		if (flipActuator != null) {
			return;
		}
		
		if (sizeActuator == null) {
			sizeActuator = Actuate.tween(this, 0.1, {"scaleX": 0.9, "scaleY": 0.9})
				.reverse()
				.onComplete(() -> { scaleX = 1.0; scaleY = 1.0; sizeActuator = null; });
		}
	}
	
	private function setStateIndecies(): Void {
		
	}
	
	private function setState(newState: TileState): Void {
		
		switch ([state, newState]) {
			case [normal, flipped]:
			case [flipped, normal]:
			
			default:
		}
	}
}