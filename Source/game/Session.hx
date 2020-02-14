package game;

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
	
	public var onBoardChangeCb: Null<Void->Void> = null;
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
		
		board.turnCell(x, y);
		
		if (board.isWin()) {
			setState(EState.Win);
		}
		
		boardChanged();
	}
	
	private function boardChanged(): Void {
		
		if (onBoardChangeCb != null) {
			onBoardChangeCb();
		}
	}
	
	private function setState(state: EState): Void {
		
		switch (state) {
			
			default:
		}
		
		this.state = state;
	}
}