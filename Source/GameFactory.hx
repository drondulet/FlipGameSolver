package;

import mediator.PanelMediator;
import ui.Panel;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.utils.Future;
import openfl.utils.Promise;
import scene.Scene;
import scene.TileSprite;

using GameFactory;

class GameFactory {
	
	static public function createScene(): Scene {
		
		var panel: Panel = new Panel();
		var panelMediator: PanelMediator = new PanelMediator(panel);
		
		var scene: Scene = new Scene(panelMediator);
		
		function onTilesAtlasReady(bitmap: BitmapData): Void {
			scene.addTileMap(bitmap, Settings.tileSize);
		}
		
		prepareTilesSprite().onComplete(onTilesAtlasReady);
		
		scene.addChild(panel);
		
		return scene;
	}
	
	static public function addTileMap(parent: DisplayObjectContainer, bitmapData: BitmapData, size: Int): Tilemap {
		
		var tileset: Tileset = new Tileset(bitmapData);
		var tileNormalIdx: Int = tileset.addRect(new Rectangle(0, 0, size, size));
		var tileFlippedIdx: Int = tileset.addRect(new Rectangle(size, 0, size, size));
		
		var tilemap: Tilemap = new Tilemap(parent.stage.stageWidth, parent.stage.stageHeight, tileset);
		parent.addChild(tilemap);
		
		// drop this
		// var tileNormal: Tile = new Tile(tileNormalIdx, 600, 20);
		// tileNormal.originX = size * 0.5;
		
		// var tileFlipped: Tile = new Tile(tileFlippedIdx, 600, 60 + Settings.tilesGap);
		// tileFlipped.originX = size * 0.5;
		// tileFlipped.id = 0;
		
		// tilemap.addTile(tileNormal);
		// tilemap.addTile(tileFlipped);
		// drop that
		
		return tilemap;
	}
	
	static private function prepareTilesSprite(): Future<BitmapData> {
		
		var tileContaner: Sprite = new Sprite();
		
		var tileNormal: TileSprite = new TileSprite(Settings.tileSize, {x: 0, y: 0}, true);
		tileContaner.addChild(tileNormal);
		
		var tileFlipped: TileSprite = new TileSprite(Settings.tileSize, {x: 0, y: 0}, false);
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