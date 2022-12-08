package collision;

import openfl.geom.Rectangle;
import quadtree.QuadTree;
import quadtree.types.Collider;

class MouseCollisionController {
	
	static final MAX_TICKS: Int = 255;
	
	static public var inst(get, never): MouseCollisionController;
	
	static private var instance: Null<MouseCollisionController> = null;
	static private function get_inst(): MouseCollisionController {
		
		if (instance == null) {
			instance = new MouseCollisionController();
		}
		
		return instance;
	}
	
	
	private final mouseCollider: BasePointCollider;
	private var quadTree: QuadTree;
	private var tick: Int;
	private var dirty: Bool;
	private var receivers: Map<IMouseCollisionReceiver, Bool>;
	private var currentCollisons: Array<IMouseCollisionReceiver>;
	
	private function new() {
		
		tick = 0;
		dirty = true;
		receivers = [];
		currentCollisons = [];
		mouseCollider = new BasePointCollider();
	}
	
	public function init(size: Rectangle): Void {
		
		clearAllRecevers();
		quadTree = new QuadTree(size.x, size.y, size.width, size.height);
	}
	
	public function registerReceiver(receiver: IMouseCollisionReceiver): Void {
		
		dirty = true;
		receivers[receiver] = true;
	}
	
	public function removeReceiver(receiver: IMouseCollisionReceiver): Void {
		
		dirty = true;
		receivers.remove(receiver);
	}
	
	public function hasReceiver(receiver: IMouseCollisionReceiver): Bool {
		return receivers.exists(receiver);
	}
	
	public function clearAllRecevers(): Void {
		
		dirty = true;
		currentCollisons.resize(0);
		receivers.clear();
	}
	
	public function handleMouseMove(mouseX: Float, mouseY: Float): Void {
		
		var newColliders: Null<Array<Collider>> = dirty ? [] : null;
		
		for (receiver in receivers.keys()) {
			
			receiver.prepareForCollisionCheck(tick);
			
			if (newColliders != null) {
				newColliders.push(receiver.collider);
			}
		}
		
		if (dirty) {
			
			quadTree.reset();
			quadTree.load(null, newColliders);
			dirty = false;
		}
		
		mouseCollider.x = mouseX;
		mouseCollider.y = mouseY;
		quadTree.load([mouseCollider]);
		quadTree.execute();
		quadTree.resetFirstGroup();
		
		tick = tick < MAX_TICKS ? tick + 1 : 0;
		
		currentCollisons.resize(0);
		for (receiver in receivers.keys()) {
			
			receiver.handleAfterCollisionCheck();
			
			if (receiver.isColliding) {
				currentCollisons.push(receiver);
			}
		}
	}
	
	public function handleClick(): Void {
		
		for (receiver in currentCollisons) {
			receiver.handleClick();
		}
	}
}