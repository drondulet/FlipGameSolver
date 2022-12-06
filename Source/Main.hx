package;

import openfl.display.Sprite;
import openfl.events.Event;
import scene.Scene;

class Main extends Sprite {
	
	private var scene: Scene;
	
	public function new() {
		
		super();
		
		GameFactory.createScene().onComplete(onSceneReady);
	}
	
	private function onSceneReady(scene: Scene): Void {
		
		this.scene = scene;
		addChild(scene);
		scene.init();
		
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	private function onResize(event: Event): Void {
		scene.onStageResize();
	}
}
