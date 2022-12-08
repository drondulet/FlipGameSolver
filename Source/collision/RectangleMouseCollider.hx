package collision;

import model.Point.IntPoint;
import quadtree.types.Collider;

class RectangleMouseCollider extends BaseRectangleCollider {
	
	public var receiver(default, null): BaseMouseCollisionReceiver;
	
	public function new(pos: IntPoint, size: IntPoint) {
		
		super(pos, size);
		receiver = new BaseMouseCollisionReceiver(this);
	}
	
	override public function onOverlap(other: Collider): Void {
		receiver.onCollide();
	}
	
	override public function moveToSeparate(deltaX: Float, deltaY: Float): Void {
		
	}
}