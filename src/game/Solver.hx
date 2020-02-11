package game;

import model.Matrix;

typedef Turn = {
	var root: Null<Turn>;
	var x: Int;
	var y: Int;
	var mat: Matrix<Int>;
}

class Solver {
	
	static public function buildTree(board: Board): Void {
		
		var map: Map<String, Turn> = [];
		var xSize: Int = board.board.xSize;
		var ySize: Int = board.board.ySize;
		
		var rootTurn: Turn = {root: null, x: -1, y: -1, mat: new Matrix(xSize, ySize, 0)}
		map.set(rootTurn.mat.getHash(), rootTurn);
		
		for (i in 0 ... xSize) {
			for (j in 0 ... ySize) {
				
				board.turnCell(i, j);
				var turn: Turn = {root: rootTurn, x: i, y: j, mat: board.board};
				map.set(turn.mat.getHash(), turn);
				board.turnCell(i, j);
			}
		}
		
		trace('done');
	}
}