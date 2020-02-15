package scene;

import Settings;
import game.Session;
import model.Matrix;
import model.Point;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

using scene.SceneHelper;

class Scene extends Sprite {
	
	private var session: Null<Session>;
	private var tileBoard: Null<Sprite>;
	private var panel: Null<Panel>;
	private var tiles: Matrix<Tile>;
	
	public function new() {
		super();
	}
	
	public function init(): Void {
		
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
	
	private function initControlPanel(): Void {
		
		panel = new Panel();
		panel.applyButtonCb = applyButtonClicked;
		panel.editButtonCb = editButtonClicked;
		panel.randomButtonCb = randomButtonClicked;
		addChild(panel);
	}
	
	private function initTileBoard(): Void {
		
		if (tileBoard != null) {
			return;
		}
		
		tileBoard = new Sprite();
		tileBoard.x = 200;
		tileBoard.y = 50;
		
		tileBoard.addEventListener(MouseEvent.CLICK, handleBoardClick);
		
		addChild(tileBoard);
	}
	
	private function handleBoardClick(event: Event): Void {
		
		if (Std.is(event.target, Tile)) {
			
			var tile: Tile = cast(event.target, Tile);
			session.tilePressed(tile.index.x, tile.index.y);
		}
	}
	
	private function resizeTileBoard(x: Int, y: Int): Void {
		tileBoard.fillColor(Settings.tileboardColor, {x: 0, y: 0, width: x, height: y}, Settings.tileSize * 0.5);
	}
	
	private function addTiles(): Void {
		
		var tile: Tile;
		
		tiles = new Matrix(session.cols, session.rows);
		
		for (i in 0 ... session.cols) {
			for (j in 0 ... session.rows) {
				
				
				tile = new Tile(Settings.tileSize, {x: i, y: j}, session.isTileTurned(i, j));
				tile.x = i * tile.width + i * Settings.tilesGap + Settings.tilesGap;
				tile.y = j * tile.height + j * Settings.tilesGap + Settings.tilesGap;
				tiles.setCell(tile, i, j);
				tileBoard.addChild(tile);
			}
		}
		
		var xSize: Int = Std.int(session.cols * (Settings.tileSize + Settings.tilesGap) + Settings.tilesGap);
		var ySize: Int = Std.int(session.rows * (Settings.tileSize + Settings.tilesGap) + Settings.tilesGap);
		resizeTileBoard(xSize, ySize);
	}
	
	private function fillBgColor(): Void {
		this.fillColor(Settings.bgColor, {x: 0 , y: 0, width: stage.stageWidth, height: stage.stageHeight});
	}
	
	private function onBoardChanged(cells: Array<IntPoint>): Void {
		
		updateSellsStates(cells);
		
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
			Std.is(child, Tile) ? tileBoard.removeChild(child) : i++;
		}
	}
	
	private function updateSellsStates(cells: Array<IntPoint>): Void {
		
		for (cell in cells) {
			tiles.getCell(cell.x, cell.y).setState(session.isTileTurned(cell.x, cell.y));
		}
	}
	
	private function applyButtonClicked(): Void {
		
		if (session.isEditMode()) {
			return;
		}
		
		startNewSession({x: panel.rowsInput, y: panel.colsInput});
	}
	
	private function editButtonClicked(): Void {
		session.switchEditMode();
	}
	
	private function randomButtonClicked(): Void {
		
		if (session.isEditMode()) {
			return;
		}
		
		session.fillRandom();
	}
}