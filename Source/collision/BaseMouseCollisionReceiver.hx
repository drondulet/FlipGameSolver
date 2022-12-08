package collision;

import quadtree.types.Collider;

class BaseMouseCollisionReceiver implements IMouseCollisionReceiver {
	
	static final TICK_OUT_OF_RANGE: Int = -1;
	
	
	public var collider(get, never): Collider;
	private var _collider: Collider;
	inline private function get_collider(): Collider {
		return _collider;
	}
	
	public var isColliding(get, never): Bool;
	inline private function get_isColliding(): Bool {
		return lastTick != TICK_OUT_OF_RANGE;
	}
	
	public var onMouseOut: Null<Void->Void>;
	public var onMouseOver: Null<Void->Void>;
	public var onMouseMove: Null<Void->Void>;
	public var onMouseClick: Null<Void->Void>;
	
	private var lastTick: Int;
	private var currentTick: Int;
	
	public function new(collider: Collider) {
		
		_collider = collider;
		lastTick = TICK_OUT_OF_RANGE;
	}
	
	public function prepareForCollisionCheck(currentTick: Int): Void {
		this.currentTick = currentTick;
	}
	
	public function onCollide(): Void {
		
		if (lastTick == TICK_OUT_OF_RANGE && onMouseOver != null) {
			onMouseOver();
		}
		else if (onMouseMove != null) {
			onMouseMove();
		}
		
		lastTick = currentTick;
	}
	
	public function handleAfterCollisionCheck(): Void {
		
		if (lastTick != TICK_OUT_OF_RANGE && lastTick != currentTick) {
			
			lastTick = TICK_OUT_OF_RANGE;
			
			if (onMouseOut != null) {
				onMouseOut();
			}
		}
	}
	
	public function handleClick(): Void {
		
		if (isColliding && onMouseClick != null) {
			onMouseClick();
		}
	}
}