package game;

import model.Matrix;
import model.Point;

class Board {
	
	public var board(default, null): Matrix<Int>;
	
	public function new(x: Int, y: Int) {
		board = new Matrix(x, y, 0);
	}
	
	public function turnCell(x: Int, y: Int): Void {
		
		var cells: Array<IntPoint> = getFlippingCells(x, y);
		
		for (cell in cells) {
			var newValue: Int = invertValue(board.getSell(cell.x, cell.y));
			board.setSell(newValue, cell.x, cell.y);
		}
		
	}
	
	public function invertValue(value: Int): Int {
		return value == 0 ? 1 : 0;
	}
	
	public function getFlippingCells(x: Int, y: Int): Array<IntPoint> {
		
		var result: Array<IntPoint> = [];
		var array: Array<IntPoint> = [];
		
		array.push({x: x, y: y});
		array.push({x: x - 1, y: y});
		array.push({x: x + 1, y: y});
		array.push({x: x, y: y + 1});
		array.push({x: x, y: y - 1});
		
		for (point in array) {
			if (board.isInside(point.x, point.y)) {
				result.push(point);
			}
		}
		
		return result;
	}
	
	inline public function toString(): String {
		return board.toString();
	}
}