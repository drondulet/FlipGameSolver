package;

import openfl.events.Event;
import openfl.display.Sprite;
import scene.Scene;

class Main extends Sprite {
	
	private var scene: Scene;
	
	public function new() {
		
		super();
		
		scene = GameFactory.createScene();
		addChild(scene);
		scene.init();
		
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	private function onResize(event: Event): Void {
		scene.onStageResize();
	}
}
