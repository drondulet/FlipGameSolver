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
		state = NoState;
	}
	
	public function get_cols(): Int {
		return board.xSize;
	}
	
	public function get_rows(): Int {
		return board.ySize;
	}
	
	public function isTileTurned(x: Int, y: Int): Bool {
		return board.cells.mat[x][y] == 0 ? true : false;
	}
	
	public function setEditMode(): Void {
		setState(Edit);
	}
	
	public function setPlayMode(): Void {
		setState(Play);
	}
	
	public function isWin(): Bool {
		return state.match(Win);
	}
	
	public function tilePressed(x: Int, y: Int): Void {
		
		var isEdit: Bool = state.match(EState.Edit);
		
		var changedCells: Array<IntPoint> = board.turnCell(x, y, isEdit);
		
		if (board.isWin() && !isEdit) {
			setState(EState.Win);
		}
		
		boardChanged(changedCells);
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