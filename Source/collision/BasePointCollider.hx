package collision;

import model.Point.IntPoint;
import quadtree.CollisionAreaType;
import quadtree.types.Collider;
import quadtree.types.Point;

class BasePointCollider implements Point {
	
	public var x: Float;
	public var y: Float;
	public final areaType: CollisionAreaType;
	public final collisionsEnabled: Bool;
	
	public function new(?pos: IntPoint) {
		
		if (pos != null) {
			
			x = pos.x;
			y = pos.y;
		}
		else {
			
			x = 0;
			y = 0;
		}
		
		areaType = CollisionAreaType.Point;
		collisionsEnabled = true;
	}
	
	public function onOverlap(other: Collider): Void {
		
	}
	
	public function moveToSeparate(deltaX: Float, deltaY: Float): Void {
		
	}
}