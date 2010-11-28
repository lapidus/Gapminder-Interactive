package org.gapminder
{
	/*
	var filt:GlowFilter = new GlowFilter;
	filt.color = 0x333333;
	filt.blurX = 4;
	filt.blurY = 4;
	bubble.filters = [filt];
	*/
	
	public class Utils extends Object
	{
							
		public static function createTextField(txt):TextField {
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
			
		
		/*
		var filt:GlowFilter = new GlowFilter;
		filt.color = 0x333333;
		filt.blurX = 4;
		filt.blurY = 4;
		bubble.filters = [filt];
		*/
		
		
	}
}