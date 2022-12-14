package;

import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.events.Event;
import scene.Scene;

class Main extends Sprite {
	
#if debug
	static public var oflStage: Stage;
#end
	private var scene: Scene;
	
	public function new() {
		
		super();
#if debug
		oflStage = stage;
#end
		GameFactory.createScene().onComplete(onSceneReady);
	}
	
	private function onSceneReady(scene: Scene): Void {
		
		this.scene = scene;
		addChildAt(scene, 0);
		scene.init();
		
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	private function onResize(event: Event): Void {
		scene.onStageResize();
	}
}
