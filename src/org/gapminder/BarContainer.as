package org.gapminder
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BarContainer extends BarContainer_design 
	{
		
		private var _chimpCurve:Sprite;
		private var _chimpPhoto:Sprite;
		
		private var _results:Array;
		private var bar:Sprite = new Sprite();
		private var barWidth:Number;
		private var horizontalPadding:Number = 25;
		private var verticalPadding:Number = 2;

		private var barPositions:Array = new Array(0,0,0,0,0,0,0,0,0); //0,1,2,3,4 etc.
		
		private var barLabelContainer:Sprite = new Sprite();
		private var blockContainer:Sprite = new Sprite();
		private var chimpBlockContainer:Sprite = new Sprite();
		
		private var blockWidth:Number;
		private var blockHeight:Number;
		
		public function BarContainer(results:Array)
		{
			this._results = results;
		
			//bar
			var barWidth:Number = 1100;
			var barHeight:Number = 4;
			var barX:Number = 0;
			var barY:Number = 0;
			var barPositionsLength = barPositions.length;
			
			blockWidth = (barWidth - horizontalPadding*(barPositionsLength+1))/barPositionsLength;
			blockHeight = 50;
			
			bar.x = barX;
			bar.y = barY;
			bar.graphics.beginFill(0x333333);
			bar.graphics.drawRect(0,0,barWidth,barHeight);
			bar.graphics.endFill();
			addChild(bar);
			
			//axis numbers
			barLabelContainer.y = barY + 25;
			barLabelContainer.x = barX;
			addChild(barLabelContainer);
			var tf:TextField = new TextField();
			var tFormat:TextFormat = new TextFormat();
			tFormat.font = "Helvetica";
			tFormat.bold = true;
			tFormat.size = 25;
			tFormat.align = "center";
			
			
			for(var i:Number=0; i < barPositions.length; i++) {
				tf = new TextField();
				tf.width = blockWidth;
				tf.height = 30;
				tf.x = i*(blockWidth+horizontalPadding) + horizontalPadding;
				tf.text = i.toString();
				tf.setTextFormat(tFormat);
				barLabelContainer.addChild(tf);
			}	
		
			//blocks
			blockContainer.y = barY;
			blockContainer.x = barX;
			addChild(blockContainer);
			
			
		}
		
		public function showBlocks() {
			
			var blockArray:Array = [];
			
			for each(var user:Object in _results) {
				//trace(participant.correctAnswers)
				var correctAnswers = user.score;
				
				var block:Block = new Block(blockWidth,blockHeight, user.id);
				block.alpha = 0;
				block.x = correctAnswers*(blockWidth+horizontalPadding) + horizontalPadding;
				block.y = barPositions[correctAnswers] * -(blockHeight+verticalPadding);
				barPositions[correctAnswers]++;
				blockContainer.addChild(block);
				blockArray.push(block);
				
			}
			
			TweenMax.allTo(blockArray, 0.5, {autoAlpha:1}, 0.2); 
			//TweenMax.to(blockArray,0.5,{autoAlpha:1});	
		}
		
		private function addBlockToPosition(correctAnswers, userID) {
			//trace(barPositions[correctAnswers]);

		}
		
		
		
		private function addChimpBlocks(){
			for each(var user:Object in _results) {
				//trace(participant.correctAnswers)
				addBlockToPosition(user.score, user.id);
			}
			
			
			//chimpBlockContainer.
		
		}
		
	
		
	}
}