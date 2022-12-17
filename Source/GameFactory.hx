package;

import mediator.PanelMediator;
import motion.Actuate;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.utils.Future;
import openfl.utils.Promise;
import scene.Scene;
import scene.TileBoardView;
import ui.Panel;

using GameFactory;
using GraphicsHelper;

class GameFactory {
	
	static public function createScene(): Future<Scene> {
		
		var promise: Promise<Scene> = new Promise();
		
		var panel: Panel = new Panel();
		var panelMediator: PanelMediator = new PanelMediator(panel);
		
		function onTilesAtlasReady(bitmap: BitmapData): Void {
			
			var tileboadView: TileBoardView = crateTileMap(bitmap);
			
			var scene: Scene = new Scene(panelMediator, tileboadView);
			scene.addChild(panel);
			
			promise.complete(scene);
		}
		
		prepareTilesAtlas().onComplete(onTilesAtlasReady);
		
		return promise.future;
	}
	
	static private function crateTileMap(atlas: BitmapData): TileBoardView {
		
		var tileSize: Int = Settings.tileSize;
		
		var tileset: Tileset = new Tileset(atlas);
		var tileNormalIdx: Int = tileset.addRect(new Rectangle(0, 0, tileSize, tileSize));
		var tileFlippedIdx: Int = tileset.addRect(new Rectangle(tileSize, 0, tileSize, tileSize));
		var dotIdx: Int = tileset.addRect(new Rectangle(tileSize * 2, 0, tileSize, tileSize));
		
		var tileBoardMaxSize: Int = Math.ceil(Settings.maxTilesCount * (Settings.tileSize + Settings.tilesGap));
		
		var tilemap: Tilemap = new Tilemap(tileBoardMaxSize, tileBoardMaxSize, tileset);
		
		var tileIndices = {
				normal: tileNormalIdx,
				flipped: tileFlippedIdx,
				dot: dotIdx,
			};
		
		var tileboardPosition = {
				x: Settings.panelWidth + Settings.tileBoardOffset,
				y: Settings.tileBoardOffset
			};
		
		var tileboadView: TileBoardView = TileBoardView.create(tilemap, tileIndices, tileboardPosition);
		
		return tileboadView;
	}
	
	static private function prepareTilesAtlas(): Future<BitmapData> {
		
		var tileContaner: Sprite = new Sprite();
		
		#if debug
		Main.oflStage.addChild(tileContaner);
		tileContaner.y = 500;
		Actuate.tween(tileContaner, 1, {"x": 5}).repeat().reverse();
		#end
		
		var tileSize: Int = Settings.tileSize;
		var tileSizeHalf: Float = tileSize * 0.5;
		
		var tileNormal: Sprite = new Sprite();
		tileNormal.fillColor(Settings.tileNotTurnedColor, { x: 0, y: 0, width: tileSize, height: tileSize }, tileSizeHalf);
		tileContaner.addChild(tileNormal);
		
		var tileFlipped: Sprite = new Sprite();
		tileFlipped.fillColor(Settings.tileTurnedColor, { x: 0, y: 0, width: tileSize, height: tileSize }, tileSizeHalf);
		tileContaner.addChild(tileFlipped);
		
		var tileWithDot: Sprite = new Sprite();
		tileWithDot.fillColor(0x000000, { x: 0, y: 0, width: tileSize, height: tileSize }, tileSizeHalf, 0);
		tileContaner.addChild(tileWithDot);
		
		var dot: Shape = new Shape();
		dot.graphics.beginFill(Settings.solutionDotColor);
		dot.graphics.drawCircle(0, 0, Settings.solutionDotSize);
		dot.graphics.endFill();
		dot.x = tileSizeHalf;
		dot.y = tileSizeHalf;
		tileWithDot.addChild(dot);
		
		tileNormal.x = 0;
		tileNormal.y = 0;
		
		tileFlipped.x = Settings.tileSize;
		tileFlipped.y = 0;
		
		tileWithDot.x = Settings.tileSize * 2;
		tileWithDot.y = 0;
		
		var promise: Promise<BitmapData> = new Promise();
		
		function onFrame(_): Void {
			
			tileContaner.removeEventListener(Event.ENTER_FRAME, onFrame);
			
			var bitmap: BitmapData = new BitmapData(Std.int(tileContaner.width), Std.int(tileContaner.height), true, 0x00000000);
			bitmap.draw(tileContaner);
			promise.complete(bitmap);
		}
		
		tileContaner.addEventListener(Event.ENTER_FRAME, onFrame);
		
		return promise.future;
	}
}