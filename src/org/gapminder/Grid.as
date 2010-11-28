package org.gapminder
{

	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class Grid extends Sprite
	{

		private var _gridWidth:int;
		private var _gridHeight:int;
		public var horizontalLines:int = 6;
		public var verticalLines:int = 8;
		public var lineWeight:int = 2;
		public var lineColor:uint = 0x9DADB5; // 0x849197;
		
		
		public function Grid(gridWidth, gridHeight)
		{
			this._gridWidth = gridWidth;
			this._gridHeight = gridHeight;
			drawGrid();
		}
		
		
		private function drawGrid():void
		{
			var xPos:int = (_gridWidth / (verticalLines))/2 ;
			var yPos:int = 2;
			
			// draw all verticals
			for ( var i:int=0; i<verticalLines; i++ )
			{

				var v:Sprite = new Sprite();
				v.graphics.lineStyle( lineWeight, lineColor, 0.5);
				v.graphics.moveTo( xPos, yPos );
				v.graphics.lineTo( xPos, yPos + _gridHeight);
				addChild( v );
				
				// increment horizontal spacing
				xPos += _gridWidth / (verticalLines);
			}
			
			
			
			xPos = 2;
			yPos = (_gridHeight/ (horizontalLines))/2;
			
			// draw all horizontals
			for (i = 0; i<horizontalLines; i++ )
			{
				
				v = new Sprite();
				v.graphics.lineStyle( lineWeight, lineColor, 0.5);
				v.graphics.moveTo( xPos, yPos );
				v.graphics.lineTo( xPos + _gridWidth, yPos);
				addChild( v );
				
				// increment horizontal spacing
				yPos += _gridHeight / (horizontalLines);
			}
			
			
	/*
			
			var yPos:int = gridHeight / verticalLines+1 ;
			
			// draw all horizontals
			for ( var j:int=0; j<=horizontalLines; j++ )
			{
				var h:Sprite = new Sprite();
				h.graphics.lineStyle( lineWeight, lineColor, 1 );
				h.graphics.moveTo( xPos, yPos );
				h.graphics.lineTo( xPos + gridWidth, yPos );
				addChild( h );
				
				// increment vertical spacing
				yPos += gridHeight / horizontalLines+1;
			}
			*/
		}
		
		
		
		
	}
}