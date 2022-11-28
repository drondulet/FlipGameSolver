package ui;

import Settings;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import ui.Button;

using GraphicsHelper;


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
	
	private var editButton: Button;
	private var editMode: Bool;
	private var buttonsToHide: Array<Button>;
	
	public function new() {
		
		super();
		editMode = false;
		init();
	}
	
	private function init(): Void {
		
		final indentText: Int = 10;
		final indentInput: Int = 100;
		
		var rows: TextField = GraphicsHelper.createInputText(indentInput, 50, rowsName);
		rows.text = '${Settings.rows}';
		
		var cols: TextField = GraphicsHelper.createInputText(indentInput, 80, colsName);
		cols.text = '${Settings.cols}';
		
		addChild(rows);
		addChild(cols);
		
		addChild(GraphicsHelper.createStaticText(indentText, 50, rowsName));
		addChild(GraphicsHelper.createStaticText(indentText, 80, colsName));
		
		var btnOffset: Int = 10;
		var btnWidth: Int = 30;
		var btnPosY: Int = 120;
		var btnPosYOffset: Int = 40;
		
		var applyButton: Button = Button.create(
			{x: Settings.panelWidth - btnOffset * 2, y: btnWidth},
			() -> applyButtonCb(),
			Settings.resetBtnText);
		
		applyButton.x = btnOffset;
		applyButton.y = btnPosY;
		addChild(applyButton);
		
		btnPosY += btnPosYOffset;
		
		editButton = Button.create(
			{x: Settings.panelWidth - btnOffset * 2, y: btnWidth},
			editBtnClicked,
			Settings.editBtnText);
		
		editButton.x = btnOffset;
		editButton.y = btnPosY;
		addChild(editButton);
		
		btnPosY += btnPosYOffset;
		
		var randomButton: Button = Button.create(
			{x: Settings.panelWidth - btnOffset * 2, y: btnWidth},
			() -> randomButtonCb(),
			Settings.randomBtnText);
		
		randomButton.x = btnOffset;
		randomButton.y = btnPosY;
		addChild(randomButton);
		
		btnPosY += btnPosYOffset;
		
		var smartRndButton: Button = Button.create(
			{x: Settings.panelWidth - btnOffset * 2, y: btnWidth},
			() -> smartRndButtonCb(),
			Settings.smartRndBtnText);
		
		smartRndButton.x = btnOffset;
		smartRndButton.y = btnPosY;
		addChild(smartRndButton);
		
		btnPosY += btnPosYOffset * 2;
		
		var solveButton: Button = Button.create(
			{x: Settings.panelWidth - btnOffset * 2, y: btnWidth},
			() -> solveButtonCb(),
			Settings.solveBtnText);
		
		solveButton.x = btnOffset;
		solveButton.y = btnPosY;
		addChild(solveButton);
		
		buttonsToHide = [applyButton, randomButton, smartRndButton, solveButton];
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