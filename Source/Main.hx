package;

import game.Board;
import game.Solver;
import openfl.display.Sprite;

class Main extends Sprite {
	
	public function new() {
		
		super();
		init();
	}
	
	private function init(): Void {
		
		var board: Board = new Board(3, 3, 0);
		
		Solver.solve(board);
		
		trace(board);
	}
}
