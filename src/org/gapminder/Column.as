package org.gapminder
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Column extends Sprite
	{
		
		
		public function Block()
		{
			this.graphics.beginFill(0x0079b5);
			this.graphics.drawRect(0,0,0,0);
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