package scene;

import Settings;
import game.Session;
import mediator.PanelMediator;
import model.Matrix;
import model.Point;
import openfl.display.Shape;
import openfl.display.Sprite;
import ui.MessageBox;

using GraphicsHelper;


class Scene extends Sprite {
	
	private final panelMediator: PanelMediator;
	private final tileBoard: TileBoardView;
	private var session: Null<Session>;
	private var solutionTiles: Null<Matrix<Null<Shape>>>;
	
	public function new(panelMediator: PanelMediator, tileBoard: TileBoardView) {
		
		super();
		this.panelMediator = panelMediator;
		this.tileBoard = tileBoard;
		tileBoard.tileClickedSignal.add(handleBoardClick);
		addChild(tileBoard);
	}
	
	public function init(): Void {
		
		onStageResize();
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
		
		tileBoard.removeAllTiles();
		tileBoard.clearSolutionDots();
		tileBoard.addTiles(session.cols, session.rows, true);
	}
	
	private function initControlPanel(): Void {
		
		panelMediator.applyButtonCb = onApplyBtnClicked;
		panelMediator.editButtonCb = onEditBtnClicked;
		panelMediator.randomButtonCb = onRandomBtnClicked;
		panelMediator.smartRndButtonCb = onSmartRndBtnClicked;
		panelMediator.solveButtonCb = onSolveBtnClicked;
	}
	
	private function resizeTileBoard(x: Int, y: Int): Void {
		tileBoard.fillColor(Settings.tileboardColor, {x: 0, y: 0, width: x, height: y}, Settings.tileSize * 0.5);
	}
	
	private function fillBgColor(): Void {
		this.fillColor(Settings.bgColor, {x: 0 , y: 0, width: stage.stageWidth, height: stage.stageHeight});
	}
	
	private function handleBoardClick(index: IntPoint): Void {
		
		var col: Int = index.x;
		var row: Int = index.y;
		tileBoard.removeSolutionDots([index]);
		session.tilePressed(col, row);
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
	
	private function updateSellsStates(cells: Array<IntPoint>): Void {
		for (cell in cells) {
			tileBoard.setTileState(cell.x, cell.y, session.isTileTurned(cell.x, cell.y));
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
		
		tileBoard.clearSolutionDots();
		tileBoard.addSolutionDots(solutionCells);
	}
	
	private function showMsgBox(message: String): Void {
		
		var size: IntPoint = {x: 300, y: 200};
		var pos: IntPoint = {x: Std.int(stage.stageWidth * 0.5 - size.x * 0.5), y: Std.int(stage.stageHeight * 0.5 - size.y * 0.5)};
		var mgsBox: Sprite = new MessageBox(message, size, pos);
		addChild(mgsBox);
	}
}