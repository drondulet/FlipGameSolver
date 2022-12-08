package collision;

import quadtree.types.Collider;

interface IMouseCollisionReceiver {
	
	public var collider(get, never): Collider;
	public var isColliding(get, never): Bool;
	
	public var onMouseOut: Null<Void->Void>;
	public var onMouseOver: Null<Void->Void>;
	public var onMouseMove: Null<Void->Void>;
	public var onMouseClick: Null<Void->Void>;
	
	public function prepareForCollisionCheck(tick: Int): Void;
	public function handleAfterCollisionCheck(): Void;
	public function handleClick(): Void;
}