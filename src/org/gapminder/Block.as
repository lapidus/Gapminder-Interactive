package org.gapminder
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Block extends Sprite
	{
		
		private var _userID:String;
		
		public function Block(blockWidth,blockHeight, userID)
		{
			_userID = userID;
			
			this.graphics.beginFill(0x0079b5);
			this.graphics.drawRect(0,0,blockWidth,-blockHeight);
			this.graphics.endFill();
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOverHandler);
		}
		
		public function rollOverHandler(e:MouseEvent){
		
			trace(_userID)
		
		}
		
		public function rollOutHandler(e:MouseEvent){
			
			trace(_userID)
			
		}
		
		

	}
}