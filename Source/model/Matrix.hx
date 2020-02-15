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
	
	inline public function getCell(x: Int, y: Int): T {
		// Assert.assert(isInside(x, y));
		return mat[x][y];
	}
	
	inline public function setCell(value: T, x: Int, y: Int): Void {
		// Assert.assert(isInside(x, y));
		mat[x][y] = value;
	}
	
	public function fill(value: T): Void {
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				setCell(value, i, j);
			}
		}
	}
	
	public function iterator(): Iterator<T> {
		return new MatrixIterator(this);
	}
	
	inline public function isInside(x: Int, y: Int): Bool {
		return x < xSize && y < ySize && x >= 0 && y >= 0;
	}
	
	public function toString(): String {
		
		var result: String = "\n";
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				result += '${getCell(i, j)} ';
			}
			result += "\n";
		}
		
		return result;
	}
	
	public function getHash(): String {
		
		var result: String = "";
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				result += '${getCell(i, j)}';
			}
		}
		
		return result;
	}
}

class MatrixIterator<T> {
	
	final mat: Matrix<T>;
	private var x: Int;
	private var y: Int;
	
	public function new(mat: Matrix<T>): Void {
		
		this.mat = mat;
		x = -1;
		y = 0;
	}
	
	public function hasNext(): Bool {
		
		inc();
		return mat.isInside(x, y);
	}
	
	public function next(): T {
		return mat.getCell(x, y);
	}
	
	private function inc(): Void {
		
		if(x < mat.xSize - 1) {
			x++;
		}
		else {
			
			x = 0;
			y++;
		}
	}
}