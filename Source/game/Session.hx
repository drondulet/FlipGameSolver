package game;

import model.Point.IntPoint;
import game.Board;

typedef SessionSettings = {
	var x: Int;
	var y: Int;
}

enum EState {
	NoState;
	Edit;
	Play;
	Win;
}

class Session {
	
	public var onBoardChangeCb: Null<Array<IntPoint>->Void> = null;
	public var cols(get, null): Int;
	public var rows(get, null): Int;
	
	private var board(default, null): Board;
	private var state: EState;
	private var scene = null;
	
	public function new(settings: SessionSettings) {
		
		board = new Board(settings.x, settings.y, 0);
		state = EState.NoState;
	}
	
	public function get_cols(): Int {
		return board.cols;
	}
	
	public function get_rows(): Int {
		return board.rows;
	}
	
	public function isTileTurned(col: Int, row: Int): Bool {
		return board.cells.getCell(col, row) == 0 ? true : false;
	}
	
	public function switchEditMode(): Void {
		state.match(EState.Edit) ? setState(EState.Play) : setState(EState.Edit);
	}
	
	public function setPlayMode(): Void {
		setState(Play);
	}
	
	public function isWin(): Bool {
		return state.match(EState.Win);
	}
	
	public function isEditMode(): Bool {
		return state.match(EState.Edit);
	}
	
	public function tilePressed(x: Int, y: Int): Void {
		
		var isEdit: Bool = state.match(EState.Edit);
		
		var changedCells: Array<IntPoint> = board.turnCell(x, y, isEdit);
		
		if (board.isWin() && !isEdit) {
			setState(EState.Win);
		}
		
		boardChanged(changedCells);
	}
	
	public function fillRandom(): Void {
		
		var changedCells: Array<IntPoint> = [];
		
		for (i in 0 ... cols) {
			for (j in 0 ... rows) {
				
				changedCells.push({x: i, y: j});
				board.cells.setCell(Std.random(2), i, j);
			}
		}
		
		boardChanged(changedCells);
	}
	
	public function findSolution(): Array<IntPoint> {
		return board.findSolution();
	}
	
	private function boardChanged(changedCells: Array<IntPoint>): Void {
		
		if (onBoardChangeCb != null) {
			onBoardChangeCb(changedCells);
		}
		
		changedCells.resize(0);
	}
	
	private function setState(state: EState): Void {
		
		switch (state) {
			
			default:
		}
		
		this.state = state;
	}
}