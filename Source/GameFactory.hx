package;

import mediator.PanelMediator;
import openfl.display.BitmapData;
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
		
		prepareTilesSprite().onComplete(onTilesAtlasReady);
		
		return promise.future;
	}
	
	static private function crateTileMap(atlas: BitmapData): TileBoardView {
		
		var tileSize: Int = Settings.tileSize;
		
		var tileset: Tileset = new Tileset(atlas);
		var tileNormalIdx: Int = tileset.addRect(new Rectangle(0, 0, tileSize, tileSize));
		var tileFlippedIdx: Int = tileset.addRect(new Rectangle(tileSize, 0, tileSize, tileSize));
		
		var tileBoardMaxSize: Int = Math.ceil(Settings.maxTilesCount * (Settings.tileSize + Settings.tilesGap));
		
		var tilemap: Tilemap = new Tilemap(tileBoardMaxSize, tileBoardMaxSize, tileset);
		
		var tileStateIndices = {
				normal: tileNormalIdx,
				flipped: tileFlippedIdx,
				normalWithDot: -1,
				flippedWithDot: -1
			};
		
		var tileboardPosition = {
				x: Settings.panelWidth + Settings.tileBoardOffset,
				y: Settings.tileBoardOffset
			};
		
		var tileboadView: TileBoardView = TileBoardView.create(tilemap, tileStateIndices, tileboardPosition);
		
		return tileboadView;
	}
	
	static private function prepareTilesSprite(): Future<BitmapData> {
		
		var tileContaner: Sprite = new Sprite();
		
		var tileSize: Int = Settings.tileSize;
		var tileSizeHalf: Float = tileSize * 0.5;
		
		var tileNormal: Sprite = new Sprite();
		tileNormal.fillColor(Settings.tileNotTurnedColor, { x: 0, y: 0, width: tileSize, height: tileSize }, tileSizeHalf);
		tileContaner.addChild(tileNormal);
		
		var tileFlipped: Sprite = new Sprite();
		tileFlipped.fillColor(Settings.tileTurnedColor, { x: 0, y: 0, width: tileSize, height: tileSize }, tileSizeHalf);
		tileContaner.addChild(tileFlipped);
		
		tileNormal.x = 0;
		tileNormal.y = 0;
		
		tileFlipped.x = Settings.tileSize;
		tileFlipped.y = 0;
		
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