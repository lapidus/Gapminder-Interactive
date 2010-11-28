package org.gapminder
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import spark.primitives.Rect;
	
	public class DistributionChart extends Sprite 
	{
		
		
		private var xAxis:Sprite = new Sprite();
		private var xAxisWidth:Number = 800;
		private var horizontalPadding = 2;
		
		//Indicator settings
		private var xMin = 25; 
		private var xMax = 85; 
		
		
		private var xPositions:Array = new Array(xMax-xMin+1)
		private var xPositionsLength = xPositions.length;
		
		private var columnWidth = (xAxisWidth - horizontalPadding*(xPositionsLength-1))/xPositionsLength;

		
		private var xLabelContainer:Sprite = new Sprite();
		private var columnContainer:Sprite = new Sprite();

		private var dataArray = new Array(500);
		
		public function DistributionChart()
		{
				
			
			//draw axis
			xAxis.graphics.beginFill(0x333333);
			xAxis.graphics.drawRect(0,0,xAxisWidth,3);
			xAxis.graphics.endFill();
			
			xLabelContainer.y = 25;
			
			addChild(xAxis);
			addChild(columnContainer);
			addChild(xLabelContainer);
			
			drawColumns();
			drawLabels();
	
		}
		
		
		function drawLabels(){

			var tf:TextField = new TextField();
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Helvetica";
			tFormat.bold = true;
			tFormat.size = 25;
			tFormat.align = "center";
			
			
			for(var i:Number=xMin; i <= xMax; i++) {
				if(i % 5 == 0) {
					tf = new TextField();
					tf.width = 50;
					tf.height = 30;
					tf.x = (i-xMin)*(columnWidth+horizontalPadding) + horizontalPadding - (tf.width/2);
					tf.text = i.toString();
					tf.setTextFormat(tFormat);
					xLabelContainer.addChild(tf);
				}
				
			}	
			
		}
		
		
		private function drawColumns(){
		
			dataArray[25] = 4;
			dataArray[56] = 8;
			dataArray[60] = 14;
			dataArray[61] = 13;
			dataArray[63] = 8;
			dataArray[85] = 8;
			
		
			var maxHeight = 300;
			var maxValue = 14;
			
			
			for(var i:Number = xMin; i <= xMax; i++) {
			
				if(dataArray[i] is Number) {
					var columnHeight:Number = dataArray[i] / maxValue * 300;
				}
				else{
					var columnHeight:Number = 0;
				}
				
				var columnSprite:Sprite = new Sprite();
				columnSprite.graphics.beginFill(0x0079b5);
				columnSprite.graphics.drawRect(0,0,columnWidth,-columnHeight);
				columnSprite.graphics.endFill();
				columnSprite.x = (i-xMin) * columnWidth + horizontalPadding*(i-xMin);
				
				columnContainer.addChild(columnSprite);
				
			}	
		}

	}
}