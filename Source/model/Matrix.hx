package model;

import haxe.ds.Vector;
// import utils.Assert;

class Matrix<T> {
	
	public var cols(default, null): Int;
	public var rows(default, null): Int;
	
	@:allow(game.Solver)
	private var mat: Vector<Vector<T>>;
	
	public function new(cols: Int, rows: Int, defaultValue: Null<T> = null) {
		
		this.cols = cols;
		this.rows = rows;
		mat = new Vector(rows);
		
		for (row in 0 ... rows) {
			mat[row] = new Vector(cols);
		}
		
		fill(defaultValue);
	}
	
	inline public function getCell(col: Int, row: Int): T {
		// Assert.assert(isInside(row, col));
		return mat[row][col];
	}
	
	inline public function setCell(value: T, col: Int, row: Int): Void {
		// Assert.assert(isInside(row, col));
		mat[row][col] = value;
	}
	
	public function fill(value: T): Void {
		
		for (col in 0 ... cols) {
			for (row in 0 ... rows) {
				setCell(value, col, row);
			}
		}
	}
	
	public function iterator(): Iterator<T> {
		return new MatrixIterator(this);
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
	
	public function getHash(): String {
		
		var result: String = "";
		
		for (col in 0 ... cols) {
			for (row in 0 ... rows) {
				result += '${getCell(col, row)}';
			}
		}
		
		return result;
	}
}

class MatrixIterator<T> {
	
	final mat: Matrix<T>;
	private var col: Int;
	private var row: Int;
	
	public function new(mat: Matrix<T>): Void {
		
		this.mat = mat;
		col = -1;
		row = 0;
	}
	
	public function hasNext(): Bool {
		
		inc();
		return mat.isInside(col, row);
	}
	
	public function next(): T {
		return mat.getCell(col, row);
	}
	
	private function inc(): Void {
		
		if(col < mat.cols - 1) {
			col++;
		}
		else {
			
			col = 0;
			row++;
		}
	}
}