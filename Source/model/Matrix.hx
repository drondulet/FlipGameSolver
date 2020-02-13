package model;

import haxe.ds.Vector;
// import utils.Assert;

class Matrix<T> {
	
	public var xSize(default, null): Int;
	public var ySize(default, null): Int;
	public var mat(default, null): Vector<Vector<T>>;
	
	public function new(x: Int, y: Int, defaultValue:Null<T> = null) {
		
		this.xSize = x;
		this.ySize = y;
		mat = new Vector(x);
		
		for (i in 0 ... xSize) {
			mat[i] = new Vector(y);
		}
		
		fill(defaultValue);
	}
	
	inline public function getSell(x: Int, y: Int): T {
		// Assert.assert(isInside(x, y));
		return mat[x][y];
	}
	
	inline public function setSell(value: T, x: Int, y: Int): Void {
		// Assert.assert(isInside(x, y));
		mat[x][y] = value;
	}
	
	public function fill(value: T): Void {
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				setSell(value, i, j);
			}
		}
	}
	
	inline public function isInside(x: Int, y: Int): Bool {
		return x < xSize && y < ySize && x >= 0 && y >= 0;
	}
	
	public function toString(): String {
		
		var result: String = "\n";
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				result += '${getSell(i, j)} ';
			}
			result += "\n";
		}
		
		return result;
	}
	
	public function getHash(): String {
		
		var result: String = "";
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				result += '${getSell(i, j)}';
			}
		}
		
		return result;
	}
}

// class MatrixIterator<T> {
	
// 	final mat: Matrix<T>;
// 	private var x: Int;
// 	private var y: Int;
	
// 	public function new(mat: Matrix<T>): Void {
		
// 		this.mat = mat;
// 		x = 0;
// 		y = 0;
// 	}
	
// 	public function hasNext(): Bool {
// 		return mat.isInside(x, y);
// 	}
	
// 	public function next(): T {
// 		return mat.getSell(x++, y++);
// 	}
// }