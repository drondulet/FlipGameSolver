package game;

import haxe.ds.Vector;
import model.Matrix;

class Solver {
	
	static public var instance(get, null): Null<Solver> = null;
	
	static private var calcMat: Matrix<Int>;
	static private var calMatRows: Int;
	
	inline static public function get_instance(): Null<Solver> {
		
		if (instance == null) {
			instance = new Solver();
		}
		
		return instance;
	}
	
	private function new() {
		
	}
	
	public function solve(board: Board): Null<Matrix<Int>> {
		
		var solutionMat: Matrix<Int> = new Matrix(board.cols, board.rows);
		
		var patternMat: Matrix<Int> = generatePatternMatrix(board.cols);
		var cellsVector: Vector<Int> = unwrapGameCells(board.cells);
		
		makeCalMatrix(patternMat, cellsVector);
		
		var solutionVector: Vector<Int> = gaussianElimination();
		var i: Int = 0;
		
		for (row in 0 ... board.rows) {
			for (col in 0 ... board.cols) {
				solutionMat.setCell(solutionVector[i], col, row);
				i++;
			}
		}
		
		return solutionMat;
	}
	
	private function generatePatternMatrix(matSize: Int): Matrix<Int> {
		
		var colCount: Int = matSize;
		var rowCount: Int = matSize;
		var size: Int = matSize * matSize;
		
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
	
	private function unwrapGameCells(cells: Matrix<Int>): Vector<Int> {
		
		var cols: Int = cells.cols;
		var rows: Int = cells.rows;
		
		var result: Vector<Int> = new Vector(cols * rows);
		var i: Int = 0;
		
		for (row in 0 ... rows) {
			for (col in 0 ... cols) {
				
				result[i] = cells.getCell(col, row);
				i++;
			}
		}
		
		return result;
	}
	
	private function makeCalMatrix(patternMat: Matrix<Int>, cellsVector: Vector<Int>): Void {
		
		var fullCols: Int = patternMat.cols + 1;
		var rows: Int = patternMat.rows;
		var value: Int;
		
		calcMat = new Matrix(fullCols, rows);
		
		for (row in 0 ... rows) {
			for (col in 0 ... fullCols) {
				
				value = col < patternMat.cols ? patternMat.getCell(col, row) : cellsVector[row];
				calcMat.setCell(value, col, row);
			}
		}
	}
	
	private function gaussianElimination(): Vector<Int> {
		
		var solution: Vector<Int> = new Vector(calcMat.rows);
		
		forwardFlow();
		backwardFlow();
		
		for (i in 0 ... calcMat.rows) {
			solution[i] = calcMat.getCell(calcMat.cols - 1, i);
		}
		
		return solution;
	}
	
	private function forwardFlow(): Void {
		
		var size: Int = calcMat.rows;
		
		for (row in 0 ... size) {
			for (col in 0 ... row) {
				
				if (calcMat.getCell(col, row) != 0) {
					
					if (swapStep(col, row)) {
						break;
					}
					else {
						calculationStep(col, row);
					}
				}
			}
		}
	}
	
	private function backwardFlow(): Void {
		
		var size: Int = calcMat.rows;
		
		var col: Int = size - 2;
		var row: Int;
		
		while (col > -1) {
			
			row = col;
			while (row > -1){
				
				// if (!= 0)
				calculationStep(col, row, true);
				row--;
			}
			
			col--;
		}
	}
	
	private function calculationStep(col: Int, row: Int, ?isReverse: Bool = false): Void {
		
		var size: Int = calcMat.rows;
		
		var from: Int = isReverse ? row + 1 : 0;
		var to: Int = isReverse ? size : row;
		
		for (c in from ... to) {
			
			if (calcMat.getCell(c, row) != 0) {
				addRows(c, row);
			}
		}
	}
	
	private function swapStep(col: Int, row: Int): Bool {
		
		var size: Int = calcMat.rows;
		var canSwap: Bool;
		
		for (r in row + 1 ... size) {
			
			canSwap = true;
			for (c in 0 ... row) {
				
				if (calcMat.getCell(c, r) != 0) {
					
					canSwap = false;
					break;
				}
			}
			
			if (canSwap) {
				
				swapRows(row, r);
				return true;
			}
		}
		
		return false;
	}
	
	private function addRows(row1: Int, row2: Int): Void {
		
		var size: Int = calcMat.cols;
		
		for (i in 0 ... size) {
			
			var value1: Int = calcMat.getCell(i, row1);
			var value2: Int = calcMat.getCell(i, row2);
			calcMat.setCell(value1 ^ value2, i, row2);
		}
	}
	
	private function swapRows(row1: Int, row2: Int): Void {
		
		var temp: Vector<Int> = calcMat.mat[row1];
		calcMat.mat[row1] = calcMat.mat[row2];
		calcMat.mat[row2] = temp;
	}
}