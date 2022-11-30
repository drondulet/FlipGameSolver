package ui;

import model.Point.IntPoint;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import ui.Button;

using GraphicsHelper;

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
		
		var msgText: TextField = GraphicsHelper.createStaticText(0, Std.int(size.y * 0.3), message);
		msgText.width = window.width;
		var format = msgText.getTextFormat();
		format.align = TextFormatAlign.CENTER;
		msgText.setTextFormat(format);
		addChild(msgText);
		
		var btnSize: IntPoint = {x: Std.int(window.width * 0.25), y: Std.int(msgText.height + 5)};
		var okBtn: Button = Button.create(btnSize, null, 'Close');
		okBtn.onClick = () -> { okBtn.dispose(); parent.removeChild(this); };
		okBtn.x = Std.int(size.x * 0.5 - btnSize.x * 0.5);
		okBtn.y = Std.int(size.y * 0.5 + btnSize.y);
		addChild(okBtn);
	}
}