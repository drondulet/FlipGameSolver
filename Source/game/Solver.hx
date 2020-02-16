package game;

import model.Matrix;

class Solver {
	
	static public var instance(get, null): Null<Solver> = null;
		
	inline static public function get_instance(): Null<Solver> {
		
		if (instance == null) {
			instance = new Solver();
		}
		
		return instance;
	}
	
	private function new() {
		
	}
	
	public function solve(board: Board, goal: Int): Null<Matrix<Int>> {
		
		var solvedMat: Matrix<Int> = new Matrix(board.cols, board.rows);
		
		return solvedMat;
	}
}