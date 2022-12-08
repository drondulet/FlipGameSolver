package collision;

import model.Point.IntPoint;
import quadtree.CollisionAreaType;
import quadtree.types.Collider;
import quadtree.types.Rectangle;

class BaseRectangleCollider implements Rectangle {
	
	public var x: Float;
	public var y: Float;
	
	public final width: Float;
	public final height: Float;
	public final angle: Float;
	public final areaType: CollisionAreaType;
	public final collisionsEnabled: Bool;
	
	public function new(pos: IntPoint, size: IntPoint) {
		
		x = pos.x;
		y = pos.y;
		width = size.x;
		height = size.y;
		angle = 0;
		areaType = CollisionAreaType.Rectangle;
		collisionsEnabled = true;
	}
	
	public function onOverlap(other: Collider): Void {
		
	}
	
	public function moveToSeparate(deltaX: Float, deltaY: Float): Void {
		
	}
}