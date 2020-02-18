package game;

import haxe.ds.Vector;
import model.Matrix;

class Solver {
	
	static public var instance(get, null): Null<Solver> = null;
	
	static private var calcMat: Matrix<Int>;
	static private var calMatRows: Int;
	
	static public function get_instance(): Solver {
		
		if (instance == null) {
			instance = new Solver();
		}
		
		return instance;
	}
	
	private function new() {
		
	}
	
	public function solve(gameMatrix: Matrix<Int>): Null<Matrix<Int>> {
		
		var rows: Int = gameMatrix.rows;
		var cols: Int = gameMatrix.cols;
		
		if (cols != rows) {
			return null;
		}
		
		var patternMat: Matrix<Int> = generatePatternMatrix(cols);
		var cellsVector: Vector<Int> = unwrapGameCells(gameMatrix);
		
		makeCalcMatrix(patternMat, cellsVector);
		
		var solutionVector: Null<Vector<Int>> = gaussianElimination();
		
		if (solutionVector == null) {
			return null;
		}
		
		var solutionMat: Matrix<Int> = new Matrix(cols, rows);
		var i: Int = 0;
		
		for (row in 0 ... rows) {
			for (col in 0 ... cols) {
				
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
	
	private function makeCalcMatrix(patternMat: Matrix<Int>, cellsVector: Vector<Int>): Void {
		
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
	
	private function gaussianElimination(): Null<Vector<Int>> {
		
		forwardFlow();
		backwardFlow();
		
		var solution: Vector<Int> = new Vector(calcMat.rows);
		
		for (i in 0 ... calcMat.rows) {
			solution[i] = calcMat.getCell(calcMat.cols - 1, i);
		}
		
		return solution;
	}
	
	private function forwardFlow(): Void {
		
		// -1 col with solution values
		var cols: Int = calcMat.cols - 1;
		var rows: Int = calcMat.rows;
		
		for (col in 0 ... cols) {
			
			if (calcMat.getCell(col, col) != 1) {
				swapStep(col, col);
			}
			
			for (row in col + 1 ... rows) {
				
				if (calcMat.getCell(col, row) != 0) {
					addRows(col, row);
				}
			}
		}
	}
	
	private function backwardFlow(): Void {
		
		// -1 for cycle, -1 col with solution values
		var col: Int = calcMat.cols - 2;
		var row: Int = calcMat.rows;
		
		while (col > -1) {
			
			row = col - 1;
			while (row > -1){
				
				if (calcMat.getCell(col, row) != 0) {
					addRows(col, row);
				}
				row--;
			}
			
			col--;
		}
	}
	
	private function swapStep(col: Int, row: Int) {
		
		var rows: Int = calcMat.rows;
		
		for (r in row + 1 ... rows) {
			
			if (calcMat.getCell(col, r) != 0) {
				
				swapRows(row, r);
				return;
			}
		}
	}
	
	/**
		adds row1 to row2, row2 will be replaced!
	**/
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