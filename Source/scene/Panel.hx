package scene;

import Settings;
import model.Point;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

using scene.SceneHelper;

class Panel extends Sprite {
	
	static private final colsName: String = 'Columns';
	static private final rowsName: String = 'Rows';
	static private final textBtnName: String = 'editBtn';
	
	public var rowsInput(get, null): Int;
	public var colsInput(get, null): Int;
	public var applyButtonCb: Void->Void;
	public var editButtonCb: Void->Void;
	public var randomButtonCb: Void->Void;
	public var smartRndButtonCb: Void->Void;
	public var solveButtonCb: Void->Void;
	
	public function new() {
		
		super();
		init();
	}
	
	private function init(): Void {
		
		final indentText: Int = 10;
		final indentInput: Int = 100;
		
		var rows: TextField = SceneHelper.createInputText(indentInput, 50, rowsName);
		rows.text = '${Settings.rows}';
		
		var cols: TextField = SceneHelper.createInputText(indentInput, 80, colsName);
		cols.text = '${Settings.cols}';
		
		addChild(rows);
		addChild(cols);
		
		addChild(SceneHelper.createStaticText(indentText, 50, rowsName));
		addChild(SceneHelper.createStaticText(indentText, 80, colsName));
		
		var applyButton: Sprite = SceneHelper.createButton({x: 10, y: 120}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.resetBtnText);
		applyButton.addEventListener(MouseEvent.CLICK, (e) -> applyButtonCb());
		addChild(applyButton);
		
		var editButton: Sprite = SceneHelper.createButton({x: 10, y: 160}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.editBtnText, textBtnName);
		editButton.addEventListener(MouseEvent.CLICK, editBtnClicked);
		addChild(editButton);
		
		var randomButton: Sprite = SceneHelper.createButton({x: 10, y: 200}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.randomBtnText);
		randomButton.addEventListener(MouseEvent.CLICK, (e) -> randomButtonCb());
		addChild(randomButton);
		
		var smartRndButton: Sprite = SceneHelper.createButton({x: 10, y: 240}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.smartRndBtnText);
		smartRndButton.addEventListener(MouseEvent.CLICK, (e) -> smartRndButtonCb());
		addChild(smartRndButton);
		
		var solveButton: Sprite = SceneHelper.createButton({x: 10, y: 300}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.solveBtnText);
		solveButton.addEventListener(MouseEvent.CLICK, (e) -> solveButtonCb());
		addChild(solveButton);
	}
	
	public function onStageResize(): Void {
		this.fillColor(Settings.panelColor, {x: 0, y: 0, width: Settings.panelWidth, height: stage.stageHeight});
	}
	
	public function get_rowsInput(): Int {
		
		var text: TextField = cast(getChildByName(rowsName), TextField);
		return validateInput(text);
	}
	
	public function get_colsInput(): Int {
		
		var text: TextField = cast(getChildByName(colsName), TextField);
		return validateInput(text);
	}
	
	private function validateInput(textField: TextField): Int {
		
		var number: Null<Int> = Std.parseInt(textField.text);
		number = number != null && number >= Settings.minTilesCount && number <= Settings.maxTilesCount ? number : Settings.rows;
		textField.text = '${number}';
		
		return number;
	}
	
	private function editBtnClicked(e: Event): Void {
		
		var text:TextField;
		
		if (Std.is(e.target, Sprite)) {
			
			var btn: Sprite = cast(e.target, Sprite);
			text = cast(btn.getChildByName(textBtnName), TextField);
		}
		else if (Std.is(e.target, TextField)) {
			text = cast(e.target, TextField);
		}
		else {
			throw 'click on button with something not sprite or text';
		}
		
		text.text = text.text == Settings.editBtnText ? Settings.editDoneBtnText : Settings.editBtnText;
		
		editButtonCb();
	}
}