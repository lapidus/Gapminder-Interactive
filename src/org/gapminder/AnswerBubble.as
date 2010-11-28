package org.gapminder
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	public class AnswerBubble extends Answer_design 
	{
		
		private var tField:TextField;
		
		public function AnswerBubble(name)
		{			
			this.name = name;
			
			this.addEventListener(MouseEvent.CLICK, showName);		
			tField = createTextField(name.substr(-3))
			tField.y = -20;
			tField.visible = 0;
			addChild(tField);
		}

		private function createTextField(txt):TextField {
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.LEFT;
			format.color = 0x333333;
			format.size = 35;
			format.font = "Arial";
			
			var field:TextField = new TextField();
			field.text = txt;
			
			field.autoSize = TextFieldAutoSize.LEFT;
			field.setTextFormat(format);
			
			return field;
		}
		
		private function showName(e:MouseEvent){
			tField.visible = true;
		
		}
		
	}
}
