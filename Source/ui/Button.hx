package ui;

import model.Point;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.DropShadowFilter;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

using GraphicsHelper;


class Button extends Sprite {
	
	static final hoverFilter: ColorMatrixFilter = new ColorMatrixFilter(
		[
			1.2, 0.0, 0.0, 0.0, 0.0,
			0.0, 1.2, 0.0, 0.0, 0.0,
			0.0, 0.0, 1.2, 0.0, 0.0,
			0.0, 0.0, 0.0, 1.0, 0.0
		]);
	
	static public function create(size: IntPoint, onPressed: Void->Void, ?label: String = ""): Button {
		
		var inst: Button = new Button(onPressed);
		inst.background.fillBitmap(Settings.buttonColor, {x: 0, y: 0, width: size.x, height: size.y}, 10);
		inst.setLabel(label); // after fillBitmap(), wrong "this.width" otherwise
		
		return inst;
	}
	
	public var label(default, null): Null<TextField>;
	public var onClick: Void->Void;
	
	private final background: Sprite;
	private var pressed: Bool;
	
	private function new(clickCb: Void->Void): Void {
		
		super();
		buttonMode = true;
		useHandCursor = true;
		pressed = false;
		onClick = clickCb;
		
		background = new Sprite();
		addChild(background);
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	public function dispose(): Void {
		
		if (parent != null) {
			parent.removeChild(this);
		}
		
		background.disposeBitmap();
		
		removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	public function setLabel(newLabel: String): Void {
		
		if (label == null) {
			
			addLabel(newLabel);
			return;
		}
		
		if (label.text == newLabel) {
			return;
		}
		
		label.text = newLabel;
	}
	
	private function addLabel(newLabel: String): Void {
		
		label = GraphicsHelper.createStaticText(0, 0, newLabel);
		var shadow: DropShadowFilter = new DropShadowFilter(2, 45, 0x000000, 1, 0, 0);
		label.filters = [shadow];
		
		var format: TextFormat = label.getTextFormat();
		format.align = TextFormatAlign.CENTER;
		label.setTextFormat(format);
		
		label.width = this.width;
		label.y = Math.floor((this.height - label.textHeight) * 0.5) - 1;
		
		addChild(label);
	}
	
	private function onMouseOver(e: Event): Void {
		filters = [hoverFilter];
	}
	
	private function onMouseOut(e: Event): Void {
		
		filters = null;
		
		if (pressed) {
			
			y -= 1;
			pressed = false;
		}
	}
	
	private function onMouseUp(e: Event): Void {
		
		y -= 1;
		pressed = false;
		onClick();
	}
	
	private function onMouseDown(e: Event): Void {
		
		y += 1;
		pressed = true;
	}
}