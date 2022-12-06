package scene;

import model.Matrix;
import model.Point.IntPoint;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.events.Event;
import openfl.events.MouseEvent;

using GraphicsHelper;

typedef TileStateIndex = {
	var normal: Int;
	var flipped: Int;
	var normalWithDot: Int;
	var flippedWithDot: Int;
}

class TileBoardView extends Sprite {
	
	static public function create(tilemap: Tilemap, stateIndices: TileStateIndex, position: IntPoint): TileBoardView {
		
		var inst: TileBoardView = new TileBoardView(tilemap, stateIndices);
		inst.initTileBoard(position);
		return inst;
	}
	
	private final tilemap: Tilemap;
	private final stateIndices: TileStateIndex;
	private var background: Sprite;
	private var tiles: Matrix<TileView>;
	
	private function new(tilemap: Tilemap, stateIndices: TileStateIndex) {
		
		super();
		
		this.tilemap = tilemap;
		this.stateIndices = stateIndices;
	}
	
	public function addTiles(cols: Int, rows: Int): Void {
		
		tiles = new Matrix(cols, rows);
		
		var tile: TileView = null;
		var tileSize: Int = Settings.tileSize;
		var tilesGap: Float = Settings.tilesGap;
		var tileSizeHalf: Float = tileSize * 0.5;
		
		for (col in 0 ... cols) {
			for (row in 0 ... rows) {
				
				tile = TileView.create(stateIndices.normal, stateIndices.flipped);
				tile.x = col * tileSize + tileSizeHalf + col * tilesGap + tilesGap;
				tile.y = row * tileSize + tileSizeHalf + row * tilesGap + tilesGap;
				
				tile.originX = tileSizeHalf;
				tile.originY = tileSizeHalf;
				
				tiles.setCell(tile, col, row);
				tilemap.addTile(tile);
			}
		}
		
		var xSize: Int = Std.int(cols * (tileSize + tilesGap) + tilesGap);
		var ySize: Int = Std.int(rows * (tileSize + tilesGap) + tilesGap);
		
		resizeTileBoard(xSize, ySize);
	}
	
	public function addSolutionDots(solutionCells: Array<IntPoint>): Void {
		
	}
	
	public function removeAllTiles(): Void {
		tilemap.removeTiles();
	}
	
	private function initTileBoard(position: IntPoint): Void {
		
		background = new Sprite();
		background.x = position.x;
		background.y = position.y;
		
		background.addEventListener(MouseEvent.CLICK, handleBoardClick);
		
		addChild(background);
		addChild(tilemap);
		
		tilemap.x = position.x;
		tilemap.y = position.y;
	}
	
	private function resizeTileBoard(x: Int, y: Int): Void {
		background.fillColor(Settings.tileboardColor, {x: 0, y: 0, width: x, height: y}, Settings.tileSize * 0.5);
	}
	
	private function handleBoardClick(event: Event): Void {
		
	}
}