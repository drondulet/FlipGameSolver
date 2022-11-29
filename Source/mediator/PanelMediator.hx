package mediator;

import ui.Panel;

class PanelMediator {
	
	public var applyButtonCb(never, set): Void->Void;
	private function set_applyButtonCb(cb: Void->Void): Void->Void {
		panel.applyButtonCb = cb;
		return cb;
	}
	
	public var editButtonCb(never, set): Void->Void;
	private function set_editButtonCb(cb: Void->Void): Void->Void {
		panel.editButtonCb = cb;
		return cb;
	}
	
	public var randomButtonCb(never, set): Void->Void;
	private function set_randomButtonCb(cb: Void->Void): Void->Void {
		panel.randomButtonCb = cb;
		return cb;
	}
	
	public var smartRndButtonCb(never, set): Void->Void;
	private function set_smartRndButtonCb(cb: Void->Void): Void->Void {
		panel.smartRndButtonCb = cb;
		return cb;
	}
	
	public var solveButtonCb(never, set): Void->Void;
	private function set_solveButtonCb(cb: Void->Void): Void->Void {
		panel.solveButtonCb = cb;
		return cb;
	}
	
	
	public var colsInput(get, never): Int;
	function get_colsInput(): Int {
		return panel.colsInput;
	}
	
	public var rowsInput(get, never): Int;
	function get_rowsInput(): Int {
		return panel.rowsInput;
	}
	
	private var panel: Panel;
	
	public function new(panel: Panel) {
		this.panel = panel;
	}
	
	public function stageResized(): Void {
		panel.onStageResize();
	}
}