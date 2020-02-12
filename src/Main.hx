import game.Board;
import game.Solver;
import model.Matrix;
import haxe.ds.BalancedTree;
import haxe.ds.HashMap;


class Main {
	
	static function main() {
		
		var board: Board = new Board(3, 3, 0);
		
		Solver.buildTree(board);
		
		trace(board);
	}
}
