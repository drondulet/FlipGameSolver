package scene;

import Settings;
import game.Session;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

class Scene extends Sprite {
	
	private var session: Null<Session>;
	private var tileBoard: Null<Sprite>;
	private var panel: Null<Panel>;
	
	public function new() {
		
		super();
	}
	
	public function init(): Void {
		
		cacheAsBitmap = true;
		
		startNewSession({x: Settings.cols, y: Settings.rows});
		
		initControlPanel();
	}
	
	public function onStageResize(): Void {
		
		fillBgColor();
		// Assert.assert(panel != null);
		panel.onStageResize();
	}
	
	private function startNewSession(settins: SessionSettings): Void {
		
		session = new Session(settins);
		session.onBoardChangeCb = onBoardChanged;
		session.setPlayMode();
		
		initTileBoard();
		removeAllTiles();
		addTiles();
	}
	
	private function handleBoardClick(event: Event): Void {
		
		if (Std.is(event.target, Tile)) {
			
			var tile: Tile = cast(event.target, Tile);
			session.tilePressed(tile.index.x, tile.index.y);
		}
	}
	
	private function initTileBoard(): Void {
		
		if (tileBoard != null) {
			return;
		}
		
		tileBoard = new Sprite();
		tileBoard.x = 200;
		tileBoard.y = 200;
		
		tileBoard.addEventListener(MouseEvent.CLICK, handleBoardClick);
		
		addChild(tileBoard);
	}
	
	private function resizeTileBoard(x: Int, y: Int): Void {
		
		var bmpData: BitmapData = new BitmapData(x, y);
		graphics.beginBitmapFill(bmpData);
		graphics.endFill();
		
		var child: Null<DisplayObject> = tileBoard.getChildByName('tileboardBmp');
		
		if (child != null) {
			tileBoard.removeChild(child);
		}
		
		var bmp: Bitmap = new Bitmap(bmpData);
		bmp.visible = false;
		bmp.name = 'tileboardBmp';
		tileBoard.addChild(bmp);
		
		fillColorTileboard();
	}
	
	private function fillColorTileboard(): Void {
		
		tileBoard.graphics.beginFill(0x202020);
		tileBoard.graphics.drawRoundRect(0, 0, tileBoard.width, tileBoard.height, tileBoard.width * 0.1, tileBoard.height * 0.1);
		tileBoard.graphics.endFill();
	}
	
	private function addTiles(): Void {
		
		var tile: Tile;
		
		for (i in 0 ... session.cols) {
			for (j in 0 ... session.rows) {
				
				tile = new Tile(Settings.tileSize, {x: i, y: j}, session.isTileTurned(i, j));
				tile.x = i * tile.width + i * Settings.tilesGap + Settings.tilesGap;
				tile.y = j * tile.height + j * Settings.tilesGap + Settings.tilesGap;
				tileBoard.addChild(tile);
			}
		}
		
		var xSize: Int = 2 * Std.int(Settings.tilesGap) + session.cols * Settings.tileSize;
		var ySize: Int = 2 * Std.int(Settings.tilesGap) + session.rows * Settings.tileSize;
		resizeTileBoard(xSize, ySize);
	}
	
	private function fillBgColor(): Void {
		
		graphics.beginFill(Settings.bgColor);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();
	}
	
	private function onBoardChanged(): Void {
		
		updateSellsStates();
		
		if (session.isWin()) {
			onWin();
		}
	}
	
	private function onWin(): Void {
		
		trace('Win!');
		session.setPlayMode();
	}
	
	private function removeAllTiles(): Void {
		
		var i: Int = 0;
		
		while (i < tileBoard.numChildren) {
			
			var child: DisplayObject = tileBoard.getChildAt(i);
			
			if (Std.is(child, Tile)) {
				tileBoard.removeChild(child);
			}
			else {
				i++;
			}
		}
	}
	
	private function updateSellsStates(): Void {
		
		var tile: Tile;
		
		for (i in 0 ... tileBoard.numChildren) {
			
			var child: DisplayObject = tileBoard.getChildAt(i);
			
			if (Std.is(child, Tile)) {
				
				tile = cast(child, Tile);
				tile.setState(session.isTileTurned(tile.index.x, tile.index.y));
			}
		}
	}
	
	private function initControlPanel(): Void {
		
		panel = new Panel();
		panel.applyButtonCb = applyButtonClick;
		addChild(panel);
	}
	
	private function applyButtonClick(): Void {
		startNewSession({x: panel.rowsInput, y: panel.colsInput});
	}
}