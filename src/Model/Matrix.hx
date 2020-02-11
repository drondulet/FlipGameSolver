package model;

import haxe.ds.Vector;

class Matrix {
	
	private var xSize: Int;
	private var ySize: Int;
	private var mat: Vector<Vector<Int>>;
	
	public function new(x: Int, y: Int) {
		
		this.xSize = x;
		this.ySize = y;
		mat = new Vector(x);
		
		for (i in 0 ... xSize) {
			mat[i] = new Vector(y);
			for (j in 0 ... ySize) {
				mat[i][j] = 0;
			}
		}
	}
	
	inline public function getSell(x: Int, y: Int): Int {
		return mat[x][y];
	}
	
	inline public function setSell(value: Int, x: Int, y: Int): Void {
		mat[x][y] = value;
	}
	
	public function fill(value: Int): Void {
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				mat[i][j] = value;
			}
		}
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
}