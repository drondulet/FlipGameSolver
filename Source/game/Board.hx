package game;

import model.Matrix;
import model.Point;

class Board {
	
	public var cells(default, null): Matrix<Int>;
	public var cols(get, null): Int;
	public var rows(get, null): Int;
	public var winValue: Int;
	
	public function new(col: Int, row: Int, winValue: Int) {
		
		cells = new Matrix(col, row, 0);
		this.winValue = winValue;
	}
	
	public function turnCell(col: Int, row: Int, ?isSingle: Bool = false): Array<IntPoint> {
		
		var flippingCells: Array<IntPoint> = isSingle ? [{x: col, y: row}] : getFlippingCells(col, row);
		
		for (cell in flippingCells) {
			invertCell(cell.x, cell.y);
		}
		
		return flippingCells;
	}
	
	inline public function invertValue(value: Int): Int {
		return value == 0 ? 1 : 0;
	}
	
	public function getFlippingCells(x: Int, y: Int): Array<IntPoint> {
		
		var result: Array<IntPoint> = [];
		var flippingCells: Array<IntPoint> = [];
		
		flippingCells.push({x: x, y: y});
		flippingCells.push({x: x - 1, y: y});
		flippingCells.push({x: x + 1, y: y});
		flippingCells.push({x: x, y: y + 1});
		flippingCells.push({x: x, y: y - 1});
		
		for (point in flippingCells) {
			if (cells.isInside(point.x, point.y)) {
				result.push(point);
			}
		}
		
		return result;
	}
	
	public function isWin(): Bool {
		
		for (col in 0 ... cols) {
			for (row in 0 ... rows) {
				if (cells.getCell(col, row) != winValue) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	public function findSolution(): Array<IntPoint> {
		
		var solutionCells: Array<IntPoint> = [];
		
		var solver: Solver = Solver.instance;
		var matrix: Null<Matrix<Int>> = solver.solve(this, 0);
		
		if (matrix != null) {
			
			trace(matrix);
			
			for (col in 0 ... cols) {
				for (row in 0 ... rows) {
					
					var value: Int = matrix.getCell(col ,row);
					
					if (value == 1) {
						solutionCells.push({x: col, y: row});
					}
				}
			}
		}
		
		return solutionCells;
	}
	
	inline public function toString(): String {
		return cells.toString();
	}
	
	inline public function get_cols(): Int {
		return cells.cols;
	}
	
	inline public function get_rows(): Int {
		return cells.rows;
	}
	
	private function invertCell(col: Int, row: Int): Void {
		
		var newValue: Int = invertValue(cells.getCell(col, row));
		cells.setCell(newValue, col, row);
	}
}