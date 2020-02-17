package scene;

import Settings;
import game.Session;
import model.Matrix;
import model.Point;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

using scene.SceneHelper;

class Scene extends Sprite {
	
	private var session: Null<Session>;
	private var tileBoard: Null<Sprite>;
	private var panel: Null<Panel>;
	private var tiles: Matrix<Tile>;
	private var solutionTiles: Null<Matrix<Null<Shape>>>;
	
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
		clearSolutions();
		addTiles();
	}
	
	private function initControlPanel(): Void {
		
		panel = new Panel();
		panel.applyButtonCb = applyButtonClicked;
		panel.editButtonCb = editButtonClicked;
		panel.randomButtonCb = randomButtonClicked;
		panel.solveButtonCb = solveButtonClicked;
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
			var col: Int = tile.index.x;
			var row: Int = tile.index.y;
			
			session.tilePressed(col, row);
			
			if (solutionTiles != null) {
				
				var solutionDot: Null<Shape> = solutionTiles.getCell(col, row);
				
				if (solutionDot != null) {
					
					solutionTiles.setCell(null, col, row);
					tileBoard.removeChild(solutionDot);
				}
			}
		}
	}
	
	private function resizeTileBoard(x: Int, y: Int): Void {
		tileBoard.fillColor(Settings.tileboardColor, {x: 0, y: 0, width: x, height: y}, Settings.tileSize * 0.5);
	}
	
	private function addTiles(): Void {
		
		var tile: Tile;
		
		tiles = new Matrix(session.cols, session.rows);
		
		for (col in 0 ... session.cols) {
			for (row in 0 ... session.rows) {
				
				tile = new Tile(Settings.tileSize, {x: col, y: row}, session.isTileTurned(col, row));
				tile.x = col * tile.width + col * Settings.tilesGap + Settings.tilesGap;
				tile.y = row * tile.height + row * Settings.tilesGap + Settings.tilesGap;
				tiles.setCell(tile, col, row);
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
		
		startNewSession({x: panel.colsInput, y: panel.rowsInput});
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
	
	private function solveButtonClicked(): Void {
		
		if (session.isEditMode()) {
			return;
		}
		
		var solutionCells: Array<IntPoint> = session.findSolution();
		
		if (solutionCells.length == 0) {
			trace('No solution');
		}
		else {
			addSolutionTiles(solutionCells);
		}
	}
	
	private function addSolutionTiles(solutionCells: Array<IntPoint>): Void {
		
		solutionTiles = new Matrix(session.cols, session.rows);
		
		var dotSize: Int = Settings.solutionDotSize;
		var offset: Float = Settings.tileSize * 0.5;
		var dot: Shape;
		var tile: Tile;
		
		for (cell in solutionCells) {
			
			tile = tiles.getCell(cell.x, cell.y);
			
			dot = new Shape();
			dot.graphics.beginFill(Settings.solutionDotColor);
			dot.graphics.drawCircle(tile.x + offset, tile.y + offset, dotSize);
			dot.graphics.endFill();
			
			tileBoard.addChild(dot);
			solutionTiles.setCell(dot, cell.x, cell.y);
		}
	}
	
	private function clearSolutions(): Void {
		
		if (solutionTiles != null) {
			
			for (dot in solutionTiles) {
				if (dot != null) {
					tileBoard.removeChild(dot);
				}
			}
			
			solutionTiles.fill(null);
		}
	}
}