package org.gapminder {
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	public class BubbleContainer extends Sprite {
		
		//GameBoard
		private var _gameBoard:GameBoard;
		
		//bubble
		private var _bubble:Sprite;
		private var _bubbleGraphics:Graphics;
		private var _bubbleColor:uint;
		
		//label
		private var _labelsContainer:Sprite;
		public var _label:Sprite;
		
		//trail
		private var _trail:Sprite;
		private var _trailGraphics:Graphics;
		private var _trailCoord:Object;

		//history bubble
		private var _historyBubble:Sprite;
		private var _historyBubbleGraphics:Graphics;
		private var _historyBubbleContainer:Sprite;
		
		private var _startX:int;
		private var _startY:int;
		public var _startRadius:int;
		
		private var _newX:int;
		private var _newY:int;
		private var _newRadius:Number;
			
		public function BubbleContainer(name:String, color, startX, startY, startRadius, labelsContainer:Sprite) {
			
			//declare stage instances
			_labelsContainer = labelsContainer;
			_gameBoard = GameBoard.getInstance();
			
			//instantiate bubble
			this.name = name;
			this._bubbleColor = color;
			this._startX = startX;
			this._startY = startY;
			this._startRadius = startRadius;
			
			//build trail 
			_trailCoord = new Object();
			_trailCoord = {currentX:startX,currentY:startY};
			
			_trail = new Sprite();
			_trailGraphics = _trail.graphics;
			_trailGraphics.lineStyle(2,_bubbleColor);
			_trailGraphics.moveTo(startX,startY);
			
			//draw first history bubble
			_historyBubbleContainer = new Sprite();
			_historyBubble = new Sprite();
			_historyBubbleGraphics = _historyBubble.graphics;
			_historyBubble.x = startX;
			_historyBubble.y = startY;
			_historyBubbleGraphics.lineStyle(1,1,1,false,LineScaleMode.NONE);
			_historyBubbleGraphics.beginFill(_bubbleColor);
			_historyBubbleGraphics.drawCircle(0,0,startRadius);
			_historyBubbleContainer.addChild(_historyBubble);
			
			
			//draw first bubble
			_bubble = new Sprite();
			_bubbleGraphics = _bubble.graphics;
			_bubble.x = startX;
			_bubble.y = startY;
			_bubble.buttonMode = true;
			_bubble.useHandCursor = true;
			_bubble.mouseChildren = false;
			_bubbleGraphics.lineStyle(1,1,1,false,LineScaleMode.NONE);
			_bubbleGraphics.beginFill(_bubbleColor);
			_bubbleGraphics.drawCircle(0,0,startRadius);
		

			//create label
			_label = new Sprite();
			_label.mouseEnabled = false;
			_label.mouseChildren = false;
			var labelTxt:TextField = createTextField(this.name + " 1950")
				
			_label.graphics.beginFill(0x999999)
			_label.graphics.drawRoundRect(-2,-2,labelTxt.width+12,labelTxt.height+8,10,10);
			_label.graphics.beginFill(0xffffff)
			_label.graphics.drawRoundRect(0,0,labelTxt.width+8,labelTxt.height+4,10,10);
			_label.addChild(labelTxt);
			_label.x = startX - labelTxt.width/2;
			if(_label.x > 800) _label.x = 800;
			_label.y = startY + startRadius + 5;			
			_label.visible = false;
			_labelsContainer.addChild(_label);
			
			//add children
			addChild(_trail);
			addChild(_historyBubbleContainer);
			addChild(_bubble);

			
			//add event listeners
			_bubble.addEventListener(MouseEvent.CLICK, bubbleClickHandler);
			_bubble.addEventListener(MouseEvent.ROLL_OVER, bubbleRollOverHandler)
			_bubble.addEventListener(MouseEvent.ROLL_OUT, bubbleRollOutHandler)
		}	
		
		
		public function update(newX, newY, newRadius) {
				
			this._newX = newX;
			this._newY = newY;
			this._newRadius = newRadius;
			var scale = newRadius / _startRadius;
			
			TweenMax.to(_bubble, _gameBoard.speed, {ease:Linear.easeNone, x : newX, y : newY, scaleX: scale, scaleY: scale, onComplete: drawHistoryBubble});
			TweenMax.to(_trailCoord, _gameBoard.speed, {ease:Linear.easeNone, currentX : newX, currentY : newY, onUpdate:drawTrail});
			
			
		}
		
		public function drawHistoryBubble() {
			_historyBubble = new Sprite();
			_historyBubble.x = _newX;
			_historyBubble.y = _newY;
			
			_historyBubbleGraphics = _historyBubble.graphics;
			_historyBubbleGraphics.lineStyle(1,1,1,false,LineScaleMode.NONE);
			_historyBubbleGraphics.beginFill(_bubbleColor);
			_historyBubbleGraphics.drawCircle(0,0,_newRadius);
			_historyBubbleContainer.addChild(_historyBubble);
		}
		
		public function drawTrail() {
			_trailGraphics.lineTo(_trailCoord.currentX,_trailCoord.currentY);
		}
		
		
		public function bubbleRollOverHandler(e:MouseEvent){
			
			if(_gameBoard.selectedBubbleContainerName == "") { //no bubble selected
				_label.visible = true;
			}
			
			else {
				if (_gameBoard.selectedBubbleContainerName != this.name) { //bubble selected, not this
					_label.visible = true;
					this.alpha = 1;
				}	
			}

		}
		
		public function bubbleRollOutHandler(e:MouseEvent){
			if(_gameBoard.selectedBubbleContainerName == "") { //no bubble selected
				_label.visible = false;
			}
				
			else {
				if (_gameBoard.selectedBubbleContainerName != this.name) { //bubble selected, not this
					_label.visible = false;
					this.alpha = 0.05;
				}	
			}		
		}
				
		public function bubbleClickHandler(e:MouseEvent){
			if(_gameBoard.isPolling == false) {
				dispatchEvent(new CustomEvent("BubbleSelected", true, false, this));
			}
		}
		
			
		private function createTextField(txt):TextField {
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.LEFT;
			format.color = 0x333333;
			format.size = 10;
			format.font = "Arial";
			
			var field:TextField = new TextField();
			field.text = txt;
			field.width = 400;			
			field.autoSize = TextFieldAutoSize.LEFT;
			field.setTextFormat(format);
			
			return field;
		}
		
	}
}
