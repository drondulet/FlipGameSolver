package scene;

import game.Session;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

class Scene extends Sprite {
	
	inline static private final gap: Float = 2.0;
	
	private var session: Session;
	private var tileBoard: Sprite;
	
	public function new() {
		
		super();
		session = new Session({x: 3, y: 3});
		session.onBoardChangeCb = onBoardChange;
	}
	
	public function init(): Void {
		
		fillColor();
		cacheAsBitmap = true;
		
		initTileBoard();
		addTiles();
		session.setPlayMode();
	}
	
	public function onStageResize(): Void {
		fillColor();
	}
	
	private function handleBoardClick(event: Event): Void {
		
		if (Std.is(event.target, Tile)) {
			
			var tile: Tile = cast(event.target, Tile);
			session.tilePressed(tile.index.x, tile.index.y);
		}
	}
	
	private function initTileBoard(): Void {
		
		tileBoard = new Sprite();
		tileBoard.x = 200;
		tileBoard.y = 200;
		
		tileBoard.graphics.beginFill(0x202020);
		tileBoard.graphics.drawRoundRect(0, 0, tileBoard.width, tileBoard.height, tileBoard.width * 0.1, tileBoard.height * 0.1);
		tileBoard.graphics.endFill();
		tileBoard.addEventListener(MouseEvent.CLICK, handleBoardClick);
		
		addChild(tileBoard);
	}
	
	private function addTiles(): Void {
		
		var tile: Tile;
		
		for (i in 0 ... session.cols) {
			for (j in 0 ... session.rows) {
				
				tile = new Tile(40, {x: i, y: j}, session.isTileTurned(i, j));
				tile.x = i * tile.width + i * gap;
				tile.y = j * tile.height + j * gap;
				tileBoard.addChild(tile);
			}
		}
	}
	
	private function fillColor(): Void {
		
		graphics.beginFill(0x505050);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();
	}
	
	private function onBoardChange(): Void {
		
		updateSellsStates();
		
		if (session.isWin()) {
			onWin();
		}
	}
	
	private function onWin(): Void {
		
		trace('Win!');
		session.setPlayMode();
	}
	
	private function updateSellsStates(): Void {
		
		var tile: Tile;
		
		for (i in 0 ... tileBoard.numChildren) {
			
			tile = cast(tileBoard.getChildAt(i), Tile);
			tile.setState(session.isTileTurned(tile.index.x, tile.index.y));
		}
	}
}