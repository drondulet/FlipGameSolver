package scene;

import collision.BasePointCollider;
import collision.MouseCollisionController;
import model.Matrix;
import model.Point.IntPoint;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import signals.Signal1;

using GraphicsHelper;


typedef TileIndex = {
	var normal: Int;
	var flipped: Int;
	var dot: Int;
}

class TileBoardView extends Sprite {
	
	static public function create(tilemap: Tilemap, tileIndices: TileIndex, position: IntPoint): TileBoardView {
		
		var inst: TileBoardView = new TileBoardView(tilemap, tileIndices);
		inst.initTileBoard(position);
		return inst;
	}
	
	public final tileClickedSignal: Signal1<IntPoint>;
	
	private final tilemap: Tilemap;
	private final tileIndices: TileIndex;
	private final mouseCollider: BasePointCollider;
	private var background: Sprite;
	private var tiles: Matrix<TileView>;
	private var dots: Matrix<Tile>;
	
	private function new(tilemap: Tilemap, tileIndices: TileIndex) {
		
		super();
		
		this.tilemap = tilemap;
		this.tileIndices = tileIndices;
		tileClickedSignal = new Signal1();
		mouseCollider = new BasePointCollider();
	}
	
	public function dispose(): Void {
		
		if (parent != null) {
			parent.removeChild(this);
		}
		
		removeAllTiles();
		clearSolutionDots();
		background.disposeBitmap();
		tilemap.tileset.bitmapData.dispose();
	}
	
	public function addTiles(cols: Int, rows: Int, isFlipped: Bool): Void {
		
		var tileSize: Int = Settings.tileSize;
		var tilesGap: Float = Settings.tilesGap;
		var tileSizeHalf: Float = tileSize * 0.5;
		
		var xSize: Int = Std.int(cols * (tileSize + tilesGap) + tilesGap);
		var ySize: Int = Std.int(rows * (tileSize + tilesGap) + tilesGap);
		resizeTileBoard(xSize, ySize);
		
		tiles = new Matrix(cols, rows);
		dots = new Matrix(cols, rows);
		
		var tile: TileView = null;
		for (col in 0 ... cols) {
			for (row in 0 ... rows) {
				
				tile = TileView.create(tileIndices, {x: tileSize, y: tileSize}, {x: col, y: row}, isFlipped);
				tile.x = col * tileSize + tileSizeHalf + col * tilesGap + tilesGap;
				tile.y = row * tileSize + tileSizeHalf + row * tilesGap + tilesGap;
				
				tile.originX = tileSizeHalf;
				tile.originY = tileSizeHalf;
				
				tile.clickSignal.add(onTileClicked);
				
				tiles.setCell(tile, col, row);
				tilemap.addTile(tile);
				
				MouseCollisionController.inst.registerReceiver(tile.collider.receiver);
			}
		}
	}
	
	public function setTileState(col: Int, row: Int, flipped: Bool): Void {
		tiles.getCell(col, row).setFlipped(flipped);
	}
	
	public function addSolutionDots(solutionCells: Array<IntPoint>): Void {
		
		var dotTile: Tile;
		var tileView: TileView;
		for (cell in solutionCells) {
			
			tileView = tiles.getCell(cell.x, cell.y);
			dotTile = new Tile(tileIndices.dot, tileView.x, tileView.y);
			dotTile.originX = tileView.originX;
			dotTile.originY = tileView.originY;
			tilemap.addTile(dotTile);
			
			dots.setCell(dotTile, cell.x, cell.y);
		}
	}
	
	public function removeSolutionDots(cells: Array<IntPoint>): Void {
		for(cell in cells) {
			tilemap.removeTile(dots.getCell(cell.x, cell.y));
		}
	}
	
	public function removeAllTiles(): Void {
		
		if (tiles != null) {
			for (tile in tiles) {
				tile.dispose();
			}
		}
		tiles = null;
		tilemap.removeTiles();
		
		MouseCollisionController.inst.clearAllRecevers();
	}
	
	public function clearSolutionDots(): Void {
		
		if (dots == null) {
			return;
		}
		
		for (dot in dots) {
			tilemap.removeTile(dot);
		}
	}
	
	private function onTileClicked(tile: TileView): Void {
		tileClickedSignal.dispatch(tile.cell);
	}
	
	private function initTileBoard(position: IntPoint): Void {
		
		background = new Sprite();
		background.x = position.x;
		background.y = position.y;
		
		background.addEventListener(MouseEvent.CLICK, onBoardClick);
		background.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		addChild(background);
		addChild(tilemap);
		
		tilemap.x = position.x;
		tilemap.y = position.y;
	}
	
	private function resizeTileBoard(x: Int, y: Int): Void {
		
		background.fillBitmap(Settings.tileboardColor, {x: 0, y: 0, width: x, height: y}, Settings.tileSize * 0.5);
		MouseCollisionController.inst.init(background.getRect(null));
	}
	
	private function onBoardClick(event: Event): Void {
		MouseCollisionController.inst.handleClick();
	}
	
	private function onMouseMove(event: Event): Void {
		
		var mouseEvent: MouseEvent = cast(event, MouseEvent);
		MouseCollisionController.inst.handleMouseMove(mouseEvent.localX, mouseEvent.localY);
	}
}