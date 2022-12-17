package scene;

import collision.RectangleMouseCollider;
import model.Point.IntPoint;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Quad;
import openfl.display.Tile;
import scene.TileBoardView.TileIndex;
import signals.Signal1;

enum TileState {
	normal;
	flipped;
}

class TileView extends Tile {
	
	static public function create(stateIndices: TileIndex, size: IntPoint, cell: IntPoint, ?flipped: Bool = false): TileView {
		
		var inst: TileView = new TileView(size, cell);
		
		inst.indexByState = [
			TileState.normal => stateIndices.normal,
			TileState.flipped => stateIndices.flipped,
		];
		
		var state: TileState = flipped ? TileState.flipped : TileState.normal;
		inst.setState(state);
		
		return inst;
	}
	
	public final collider: RectangleMouseCollider;
	public final cell: IntPoint;
	public final clickSignal: Signal1<TileView>;
	
	private var state: TileState;
	private var indexByState: Map<TileState, Int>;
	private var sizeActuator: Null<GenericActuator<TileView>>;
	private var flipActuator: Null<GenericActuator<TileView>>;
	
	private function new(size: IntPoint, cell: IntPoint) {
		
		super();
		this.cell = cell;
		state = TileState.normal;
		clickSignal = new Signal1();
		collider = new RectangleMouseCollider({x: 0, y: 0}, {x: size.x, y: size.y});
		collider.receiver.onMouseOver = onMouseOver;
		collider.receiver.onMouseClick = onClick;
	}
	
	public function dispose(): Void {
		
		clickSignal.remove(true);
		if (flipActuator != null) {
			
			Actuate.stop(flipActuator);
			flipActuator = null;
		}
		if (sizeActuator != null) {
			
			Actuate.stop(sizeActuator);
			sizeActuator = null;
		}
	}
	
	public function setFlipped(flipped: Bool): Void {
		
		var newState = flipped ? TileState.flipped : TileState.normal;
		setState(newState);
	}
	
	private function setState(newState: TileState): Void {
		
		if (state.equals(newState)) {
			return;
		}
		
		switch ([state, newState]) {
			
			case [normal, flipped]:
				startFlipAnimation(indexByState[flipped]);
				
			case [flipped, normal]:
				startFlipAnimation(indexByState[normal]);
				
			default:
		}
		
		state = newState;
	}
	
	private function onClick(): Void {
		clickSignal.dispatch(this);
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
	
	private function startFlipAnimation(index: Int): Void {
		
		if (flipActuator != null) {
			Actuate.stop(flipActuator);
		}
		
		function changeState(): Void {
			
			id = index;
			flipActuator = Actuate.tween(this, 0.1, {"scaleX": 1.0})
				.onComplete(() -> { flipActuator = null; scaleX = 1.0; }).ease(Quad.easeOut);
		}
		
		flipActuator = Actuate.tween(this, 0.1, {"scaleX": 0.1}).onComplete(changeState).ease(Quad.easeIn);
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
}