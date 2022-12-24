package ui;

import Settings;
import openfl.display.Sprite;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.ui.Keyboard;
import ui.Button;

using GraphicsHelper;


class Panel extends Sprite {
	
	static private final colsName: String = 'Columns';
	static private final rowsName: String = 'Rows';
	static private final textBtnName: String = 'editBtn';
	
	public var rowsInput(get, null): Int;
	public function get_rowsInput(): Int {
		var text: TextField = cast(getChildByName(rowsName), TextField);
		return validateInput(text);
	}
	
	public var colsInput(get, null): Int;
	public function get_colsInput(): Int {
		var text: TextField = cast(getChildByName(colsName), TextField);
		return validateInput(text);
	}
	
	public var applyButtonCb: Void->Void;
	public var editButtonCb: Void->Void;
	public var randomButtonCb: Void->Void;
	public var smartRndButtonCb: Void->Void;
	public var solveButtonCb: Void->Void;
	
	private final background: Sprite;
	private var allButtons: Array<Button>;
	private var editButton: Button;
	private var editMode: Bool;
	private var buttonsToHide: Array<Button>;
	private var onFocusRowsValue: String;
	private var onFocusColsValue: String;
	
	public function new() {
		
		super();
		editMode = false;
		background = new Sprite();
		addChild(background);
		init();
	}
	
	public function dispose(): Void {
		
		if (allButtons != null) {
			for (button in allButtons) {
				button.dispose();
			}
		}
		background.disposeBitmap();
	}
	
	public function onStageResize(): Void {
		background.fillBitmap(Settings.panelColor, {x: 0, y: 0, width: Settings.panelWidth, height: stage.stageHeight});
	}
	
	private function init(): Void {
		
		final indentText: Int = 10;
		final indentInput: Int = 100;
		
		var rows: TextField = GraphicsHelper.createInputText(indentInput, 50, rowsName);
		rows.text = '${Settings.rows}';
		rows.addEventListener(FocusEvent.FOCUS_IN, (_) -> { onFocusRowsValue = rows.text; rows.setSelection(0, rows.text.length); });
		rows.addEventListener(FocusEvent.FOCUS_OUT, (_) -> if (onFocusRowsValue != rows.text) applyButtonCb());
		rows.addEventListener(KeyboardEvent.KEY_UP, (event) -> if (event.keyCode == Keyboard.ENTER) stage.focus = null);
		
		var cols: TextField = GraphicsHelper.createInputText(indentInput, 80, colsName);
		cols.text = '${Settings.cols}';
		cols.addEventListener(FocusEvent.FOCUS_IN, (_) -> { onFocusColsValue = cols.text; cols.setSelection(0, cols.text.length); });
		cols.addEventListener(FocusEvent.FOCUS_OUT, (_) -> if (onFocusColsValue != cols.text) applyButtonCb());
		cols.addEventListener(KeyboardEvent.KEY_UP, (event) -> if (event.keyCode == Keyboard.ENTER) stage.focus = null);
		
		addChild(rows);
		addChild(cols);
		
		addChild(GraphicsHelper.createStaticText(indentText, 50, rowsName));
		addChild(GraphicsHelper.createStaticText(indentText, 80, colsName));
		
		createButtons();
	}
	
	private function createButtons(): Void {
		
		var btnOffset: Int = 10;
		var btnPosY: Int = 120;
		var btnPosYOffset: Int = 40;
		var panelWidth: Int = Settings.panelWidth;
		var btnWidth: Int = panelWidth - btnOffset * 2;
		var btnHeight: Int = 30;
		
		var applyButton: Button = Button.create(
			{x: btnWidth, y: btnHeight},
			() -> applyButtonCb(),
			Settings.resetBtnText);
		
		applyButton.x = btnOffset;
		applyButton.y = btnPosY;
		addChild(applyButton);
		
		btnPosY += btnPosYOffset;
		
		editButton = Button.create(
			{x: btnWidth, y: btnHeight},
			editBtnClicked,
			Settings.editBtnText);
		
		editButton.x = btnOffset;
		editButton.y = btnPosY;
		addChild(editButton);
		
		btnPosY += btnPosYOffset;
		
		var randomButton: Button = Button.create(
			{x: btnWidth, y: btnHeight},
			() -> randomButtonCb(),
			Settings.randomBtnText);
		
		randomButton.x = btnOffset;
		randomButton.y = btnPosY;
		addChild(randomButton);
		
		btnPosY += btnPosYOffset;
		
		var smartRndButton: Button = Button.create(
			{x: btnWidth, y: btnHeight},
			() -> smartRndButtonCb(),
			Settings.smartRndBtnText);
		
		smartRndButton.x = btnOffset;
		smartRndButton.y = btnPosY;
		addChild(smartRndButton);
		
		btnPosY += btnPosYOffset * 2;
		
		var solveButton: Button = Button.create(
			{x: btnWidth, y: btnHeight},
			() -> solveButtonCb(),
			Settings.solveBtnText);
		
		solveButton.x = btnOffset;
		solveButton.y = btnPosY;
		addChild(solveButton);
		
		buttonsToHide = [applyButton, randomButton, smartRndButton, solveButton];
		allButtons = [applyButton, editButton, randomButton, smartRndButton, solveButton];
	}
	
	private function validateInput(textField: TextField): Int {
		
		var number: Null<Int> = Std.parseInt(textField.text);
		
		if (number == null) {
			number = Settings.rows;
		}
		else if (number < Settings.minTilesCount) {
			number = Settings.minTilesCount;
		}
		else if (number > Settings.maxTilesCount) {
			number = Settings.maxTilesCount;
		}
		
		textField.text = '${number}';
		
		return number;
	}
	
	private function editBtnClicked(): Void {
		
		if (editMode) {
			
			editButton.setLabel(Settings.editBtnText);
			showButtons();
			editMode = false;
		}
		else {
			
			editButton.setLabel(Settings.editDoneBtnText);
			hideButtons();
			editMode = true;
		}
		
		editButtonCb();
	}
	
	private function hideButtons(): Void {
		for (button in buttonsToHide) {
			button.visible = false;
		}
	}
	
	private function showButtons(): Void {
		for (button in buttonsToHide) {
			button.visible = true;
		}
	}
}
