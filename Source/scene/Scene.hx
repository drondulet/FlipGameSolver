package scene;

import Settings;
import game.Session;
import mediator.PanelMediator;
import model.Matrix;
import model.Point;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import ui.MessageBox;

using GraphicsHelper;


class Scene extends Sprite {
	
	private var session: Null<Session>;
	private var tileBoard: Null<Sprite>;
	private var panelMediator: PanelMediator;
	private var tiles: Matrix<TileSprite>;
	private var tilemap: Tilemap;
	private var solutionTiles: Null<Matrix<Null<Shape>>>;
	
	public function new(panelMediator: PanelMediator) {
		
		super();
		this.panelMediator = panelMediator;
	}
	
	public function init(): Void {
		
		startNewSession({x: Settings.cols, y: Settings.rows});
		initControlPanel();
	}
	
	public function onStageResize(): Void {
		
		fillBgColor();
		panelMediator.stageResized();
	}
	
	private function startNewSession(settins: SessionSettings): Void {
		
		session = new Session(settins);
		session.onBoardChangeCb = onBoardChanged;
		session.setPlayMode();
		
		initTileBoard();
		removeAllTiles();
		clearSolutionDots();
		addTiles();
	}
	
	private function initControlPanel(): Void {
		
		panelMediator.applyButtonCb = onApplyBtnClicked;
		panelMediator.editButtonCb = onEditBtnClicked;
		panelMediator.randomButtonCb = onRandomBtnClicked;
		panelMediator.smartRndButtonCb = onSmartRndBtnClicked;
		panelMediator.solveButtonCb = onSolveBtnClicked;
	}
	
	private function initTileBoard(): Void {
		
		if (tileBoard != null) {
			return;
		}
		
		tileBoard = new Sprite();
		tileBoard.x = Settings.panelWidth + Settings.tileBoardOffset;
		tileBoard.y = Settings.tileBoardOffset;
		
		tileBoard.addEventListener(MouseEvent.CLICK, handleBoardClick);
		
		addChild(tileBoard);
	}
	
	private function resizeTileBoard(x: Int, y: Int): Void {
		tileBoard.fillColor(Settings.tileboardColor, {x: 0, y: 0, width: x, height: y}, Settings.tileSize * 0.5);
	}
	
	private function fillBgColor(): Void {
		this.fillColor(Settings.bgColor, {x: 0 , y: 0, width: stage.stageWidth, height: stage.stageHeight});
	}
	
	private function handleBoardClick(event: Event): Void {
		
		if (Std.is(event.target, TileSprite)) {
			
			var tile: TileSprite = cast(event.target, TileSprite);
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
	
	private function addTiles(): Void {
		
		var tile: TileSprite = null;
		var tileSize: Int = Settings.tileSize;
		var tilesGap: Float = Settings.tilesGap;
		var tileSizeHalf: Float = tileSize * 0.5;
		
		tiles = new Matrix(session.cols, session.rows);
		
		for (col in 0 ... session.cols) {
			for (row in 0 ... session.rows) {
				
				tile = new TileSprite(tileSize, {x: col, y: row}, session.isTileTurned(col, row));
				tile.x = col * tileSize + tileSizeHalf + col * tilesGap + tilesGap;
				tile.y = row * tileSize + tileSizeHalf + row * tilesGap + tilesGap;
				tiles.setCell(tile, col, row);
				tileBoard.addChild(tile);
			}
		}
		
		var xSize: Int = Std.int(session.cols * (tileSize + tilesGap) + tilesGap);
		var ySize: Int = Std.int(session.rows * (tileSize + tilesGap) + tilesGap);
		resizeTileBoard(xSize, ySize);
	}
	
	private function onBoardChanged(cells: Array<IntPoint>): Void {
		
		updateSellsStates(cells);
		
		if (session.isWin()) {
			onWin();
		}
	}
	
	private function onWin(): Void {
		
		showMsgBox('You win!');
		session.setPlayMode();
	}
	
	private function removeAllTiles(): Void {
		
		if (tiles != null) {
			tiles.fill(null);
		}
		
		var i: Int = 0;
		
		while (i < tileBoard.numChildren) {
			
			var child: DisplayObject = tileBoard.getChildAt(i);
			Std.is(child, TileSprite) ? tileBoard.removeChild(child) : i++;
		}
	}
	
	private function updateSellsStates(cells: Array<IntPoint>): Void {
		
		for (cell in cells) {
			tiles.getCell(cell.x, cell.y).setState(session.isTileTurned(cell.x, cell.y));
		}
	}
	
	private function onApplyBtnClicked(): Void {
		
		if (session.isEditMode()) {
			return;
		}
		
		startNewSession({x: panelMediator.colsInput, y: panelMediator.rowsInput});
	}
	
	private function onEditBtnClicked(): Void {
		session.switchEditMode();
	}
	
	private function onRandomBtnClicked(): Void {
		
		if (session.isEditMode()) {
			return;
		}
		
		session.fillRandom();
	}
	
	private function onSmartRndBtnClicked(): Void {
		
		if (session.isEditMode()) {
			return;
		}
		
		session.fillRandom(true);
	}
	
	private function onSolveBtnClicked(): Void {
		
		if (session.isEditMode()) {
			return;
		}
		
		var solutionCells: Array<IntPoint> = session.findSolution();
		
		if (solutionCells.length == 0) {
			showMsgBox('No solution.');
		}
		else {
			addSolutionDots(solutionCells);
		}
	}
	
	private function addSolutionDots(solutionCells: Array<IntPoint>): Void {
		
		clearSolutionDots();
		
		solutionTiles = new Matrix(session.cols, session.rows);
		
		var dotSize: Int = Settings.solutionDotSize;
		var dot: Shape;
		var tile: TileSprite;
		
		for (cell in solutionCells) {
			
			tile = tiles.getCell(cell.x, cell.y);
			
			dot = new Shape();
			dot.graphics.beginFill(Settings.solutionDotColor);
			dot.graphics.drawCircle(tile.x, tile.y, dotSize);
			dot.graphics.endFill();
			
			tileBoard.addChild(dot);
			solutionTiles.setCell(dot, cell.x, cell.y);
		}
	}
	
	private function clearSolutionDots(): Void {
		
		if (solutionTiles != null) {
			
			for (dot in solutionTiles) {
				if (dot != null) {
					tileBoard.removeChild(dot);
				}
			}
			
			solutionTiles.fill(null);
		}
	}
	
	private function showMsgBox(message: String): Void {
		
		var size: IntPoint = {x: 300, y: 200};
		var pos: IntPoint = {x: Std.int(stage.stageWidth * 0.5 - size.x * 0.5), y: Std.int(stage.stageHeight * 0.5 - size.y * 0.5)};
		var mgsBox: Sprite = new MessageBox(message, size, pos);
		addChild(mgsBox);
	}
}