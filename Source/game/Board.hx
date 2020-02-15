package game;

import model.Matrix;
import model.Point;

class Board {
	
	public var cells(default, null): Matrix<Int>;
	public var xSize(get, null): Int;
	public var ySize(get, null): Int;
	public var winValue: Int;
	
	public function new(x: Int, y: Int, winValue: Int) {
		
		cells = new Matrix(x, y, 0);
		this.winValue = winValue;
	}
	
	public function turnCell(x: Int, y: Int, ?isSingle: Bool = false): Array<IntPoint> {
		
		var flippingCells: Array<IntPoint> = isSingle ? [{x: x, y: y}] : getFlippingCells(x, y);
		
		for (cell in flippingCells) {
			invertCell(cell.x, cell.y);
		}
		
		return flippingCells;
	}
	
	private function invertCell(x: Int, y: Int): Void {
		
		var newValue: Int = invertValue(cells.getCell(x, y));
		cells.setCell(newValue, x, y);
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
		
		for (x in 0 ... xSize) {
			for (y in 0 ... ySize) {
				if (cells.getCell(x, y) != winValue) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	inline public function toString(): String {
		return cells.toString();
	}
	
	inline public function get_xSize(): Int {
		return cells.xSize;
	}
	
	inline public function get_ySize(): Int {
		return cells.ySize;
	}
}