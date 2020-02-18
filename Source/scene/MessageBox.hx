package scene;

import model.Point.IntPoint;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;

using scene.SceneHelper;

class MessageBox extends Sprite {
	
	public function new(message: String, size: IntPoint, pos: IntPoint) {
		
		super();
		
		this.x = pos.x;
		this.y = pos.y;
		
		var shadowOffset: Int = 2;
		this.fillColor(Settings.msgBoxColor - 0x202020, {x: shadowOffset, y: shadowOffset, width: size.x + shadowOffset, height: size.y + shadowOffset}, size.x * 0.1);
		
		var window: Sprite = new Sprite();
		window.fillColor(Settings.msgBoxColor, {x: 0, y: 0, width: size.x, height: size.y}, size.x * 0.1);
		addChild(window);
		
		var msgText: TextField = SceneHelper.createStaticText(Std.int(size.x * 0.3), Std.int(size.y * 0.3), message);
		addChild(msgText);
		
		var btnSize: IntPoint = {x: Std.int(msgText.width + 5), y: Std.int(msgText.height + 5)};
		var btnPos: IntPoint = {x: Std.int(size.x * 0.5 - btnSize.x * 0.5), y: Std.int(size.y * 0.5 + btnSize.y)};
		var okBtn: Sprite = SceneHelper.createButton(btnPos, btnSize, 'Close');
		okBtn.addEventListener(MouseEvent.CLICK, onOkClicked);
		addChild(okBtn);
	}
	
	private function onOkClicked(e: Event): Void {
		parent.removeChild(this);
	}
}