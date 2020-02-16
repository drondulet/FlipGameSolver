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
		
		generatePatternMatrix(board);
		
		return solvedMat;
	}
	
	private function generatePatternMatrix(board: Board): Matrix<Int> {
		
		var sourceMat: Matrix<Int> = board.cells;
		var colCount: Int = sourceMat.cols;
		var rowCount: Int = sourceMat.rows;
		var size: Int = colCount * rowCount;
		
		var patternMat: Matrix<Int> = new Matrix(size, size, 0);
		var i: Int = 0;
		var value: Int = 1;
		
		for (col in 0 ... colCount) {
			for (row in 0 ... rowCount) {
				
				i = row * colCount + col;
				patternMat.setCell(value, i, i);
				
				if (col > 0) {
					patternMat.setCell(value, i, i - 1);
				}
				if (row > 0) {
					patternMat.setCell(value, i, i - colCount);
				}
				if (col < colCount - 1) {
					patternMat.setCell(value, i, i + 1);
				}
				if (row < rowCount - 1) {
					patternMat.setCell(value, i, i + colCount);
				}
			}
		}
		
		return patternMat;
	}
}