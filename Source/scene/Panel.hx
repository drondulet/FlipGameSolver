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
	static private final textBtnName: String = 'Rows';
	
	public var rowsInput(get, null): Int;
	public var colsInput(get, null): Int;
	public var applyButtonCb: Void->Void;
	public var editButtonCb: Void->Void;
	public var randomButtonCb: Void->Void;
	
	private final textFormat: TextFormat = new TextFormat("Lucida", 18, 0x80FF80);
	private final textFormatNums: TextFormat = new TextFormat("Lucida", 20, 0x80FF80, true);
	
	public function new() {
		
		super();
		init();
	}
	
	private function init(): Void {
		
		final indentText: Int = 10;
		final indentInput: Int = 100;
		
		var rows: TextField = createInputText(indentInput, 50, rowsName);
		rows.text = '${Settings.rows}';
		
		var cols: TextField = createInputText(indentInput, 80, colsName);
		cols.text = '${Settings.cols}';
		
		addChild(rows);
		addChild(cols);
		
		addChild(createStaticText(indentText, 50, rowsName));
		addChild(createStaticText(indentText, 80, colsName));
		
		var applyButton: Sprite = createButton({x: 10, y: 120}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.resetBtnText);
		applyButton.addEventListener(MouseEvent.CLICK, (e) -> applyButtonCb());
		addChild(applyButton);
		
		var editButton: Sprite = createButton({x: 10, y: 160}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.editBtnText);
		editButton.addEventListener(MouseEvent.CLICK, editBtnClicked);
		addChild(editButton);
		
		var randomButton: Sprite = createButton({x: 10, y: 200}, {x: Settings.panelWidth - 10 * 2, y: 30}, Settings.randomBtnText);
		randomButton.addEventListener(MouseEvent.CLICK, (e) -> randomButtonCb());
		addChild(randomButton);
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
	
	private function createInputText(x: Int, y: Int, name: String): TextField {
		
		var input: TextField = new TextField();
		input.type = TextFieldType.INPUT;
		input.defaultTextFormat = textFormatNums;
		input.x = x;
		input.y = y;
		input.name = name;
		input.height = input.textHeight + 2;
		input.width = 50;
		input.border = true;
		
		return input;
	}
	
	private function createStaticText(x: Int, y: Int, text: String): TextField {
		
		var input: TextField = new TextField();
		input.defaultTextFormat = textFormat;
		input.x = x;
		input.y = y;
		input.text = text;
		input.height = input.textHeight + 2;
		input.width = 100;
		// input.border = true;
		
		return input;
	}
	
	private function createButton(pos: IntPoint, size: IntPoint, text: String): Sprite {
		
		var button: Sprite = new Sprite();
		button.x = pos.x;
		button.y = pos.y;
		button.useHandCursor = true;
		button.buttonMode = true;
		
		button.fillColor(Settings.buttonColor, {x: 0, y: 0, width: size.x, height: size.y}, 10);
		button.addBmp(size);
		
		var text: TextField = createStaticText(Std.int(size.x * 0.25), Std.int(size.y * 0.15), text);
		text.name = textBtnName;
		button.addChild(text);
		
		return button;
	}
}