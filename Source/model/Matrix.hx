package model;

import haxe.ds.Vector;
// import utils.Assert;

@:generic
class Matrix<T> {
	
	public var cols(default, null): Int;
	public var rows(default, null): Int;
	
	private final mat: Vector<T>;
	private final mIterator: MatrixIterator<T>;
	
	public function new(cols: Int, rows: Int, defaultValue: T) {
		
		this.cols = cols;
		this.rows = rows;
		mat = new Vector(rows * cols);
		mIterator = new MatrixIterator(this);
		fill(defaultValue);
	}
	
	inline public function getCell(col: Int, row: Int): T {
		// Assert.assert(isInside(row, col));
		return mat[cols * row + col];
	}
	
	inline public function setCell(value: T, col: Int, row: Int): Void {
		// Assert.assert(isInside(row, col));
		mat[cols * row + col] = value;
	}
	
	public function fill(value: T): Void {
		
		for (col in 0 ... cols) {
			for (row in 0 ... rows) {
				setCell(value, col, row);
			}
		}
	}
	
	inline public function swapRows(row1: Int, row2: Int): Void {
		
		var temp: Vector<T> = new Vector(cols);
		for (col in 0 ... cols) {
			temp[col] = getCell(col, row1);
		}
		for (col in 0 ... cols) {
			setCell(getCell(col, row2), col, row1);
		}
		for (col in 0 ... cols) {
			setCell(temp[col], col, row2);
		}
	}
	
	public function iterator(): Iterator<T> {
		return mIterator.reset();
	}
	
	inline public function isInside(col: Int, row: Int): Bool {
		return col < cols && row < rows && col >= 0 && row >= 0;
	}
	
	public function toString(): String {
		
		var result: String = "\n";
		
		for (row in 0 ... rows) {
			for (col in 0 ... cols) {
				result += '${getCell(col, row)} ';
			}
			result += "\n";
		}
		
		return result;
	}
}

@:generic
class MatrixIterator<T> {
	
	final mat: Matrix<T>;
	private var i: Int;
	
	public function new(mat: Matrix<T>): Void {
		
		this.mat = mat;
		i = 0;
	}
	
	public function reset(): MatrixIterator<T> {
		
		i = 0;
		return this;
	}
	
	inline public function hasNext(): Bool {
		
		inc();
		@:privateAccess return i < mat.mat.length;
	}
	
	inline public function next(): T {
		@:privateAccess return mat.mat[i];
	}
	
	inline private function inc(): Void {
		i++;
	}
}
