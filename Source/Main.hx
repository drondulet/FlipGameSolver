package;

import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Stage;
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
		
		stage.frameRate = 1000;
		var fpsMonitor = new FPS(10, 10, 0xFAFF00);
		addChild(fpsMonitor);
		
		var renderTypeAndVersion: String = '${stage.window.context.type} ${stage.window.context.version}';
		var contextInfo = GraphicsHelper.createStaticText(10, 20, '${renderTypeAndVersion} ppi: ${stage.window.display.dpi}');
		contextInfo.setTextFormat(fpsMonitor.getTextFormat());
		addChild(contextInfo);

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
