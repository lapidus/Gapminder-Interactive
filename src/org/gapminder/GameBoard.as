package org.gapminder
{
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import mx.containers.Grid;
	
	import net.hires.debug.Stats;
	
	import org.gapminder.LexFertData;
	
	import spark.components.Window;
	
	public class GameBoard extends GameBoard_design
	{
		
		//Singleton
		public static var _instance:GameBoard;
		
		//Data
		public var countries:Array = ["Afghanistan","Albania","Algeria","Angola","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Central African Rep.","Chad","Channel Islands","Chile","China","Colombia","Comoros","Congo, Dem. Rep.","Congo, Rep.","Costa Rica","Cote d'Ivoire","Croatia","Cuba","Cyprus","Czech Rep.","Denmark","Djibouti","Dominican Rep.","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","French Guiana","French Polynesia","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guadeloupe","Guam","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hong Kong, China","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Korea, Dem. Rep.","Korea, Rep.","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Lithuania","Luxembourg","Macao, China","Macedonia, FYR","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Martinique","Mauritania","Mauritius","Mexico","Micronesia, Fed. Sts.","Moldova","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Lucia","Saint Vincent and the Grenadines","Samoa","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia","Sierra Leone","Singapore","Slovak Republic","Slovenia","Solomon Islands","Somalia","South Africa","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan","Vanuatu","Venezuela","Vietnam","Virgin Islands (U.S.)","Palestine","Western Sahara","Yemen, Rep.","Zambia","Zimbabwe"] ;
		public var data:Object;
				
		public var indicatorMinX:Number=0.5;
		public var indicatorMaxX:Number=8.5;
		public var indicatorDistanceX:Number;
		
		public var indicatorMinY:Number=25;
		public var indicatorMaxY:Number=85;	
		public var indicatorDistanceY:Number;
		
		public var sizeConstantDividedByPI:Number= 0.000009 / Math.PI;

		//Settings
		public var speed:Number = 0.45;
		public var isPolling = false;
		public var selectedBubbleContainer:BubbleContainer;
		public var selectedBubbleContainerName = "";
		
		//Containers
		public var canvasWidth:int;
		public var canvasHeight:int;
		private var _answersContainer:Sprite;
		private var _indicatorLabelX:Sprite;
		private var _indicatorLabelY:Sprite;
		
		//Timer
		public var timer:Timer;
		public var repeatCount:int;
		public var currentCount:int;
		
		//Display
		public var canvasBubbles:Array = [];		
			
		public function GameBoard(window)
		{			
		
			_instance = this;
			_answersContainer = this.answersContainer;
			_indicatorLabelX = this.indicatorLabelX;
			_indicatorLabelY = this.indicatorLabelY;
			
			//Parse data
			var lexFertData = new LexFertData();
			data = JSON.decode(lexFertData.lfData);
			
			//Store canvas dimensions
			canvasWidth = canvas.width;
			canvasHeight = canvas.height;
			
			
			//draw Grid
			grid.addChild(new org.gapminder.Grid(canvasWidth, canvasHeight));
			
			
			//precalc values
			indicatorDistanceX = canvasWidth / (indicatorMaxX - indicatorMinX);
			indicatorDistanceY = canvasHeight / (indicatorMaxY - indicatorMinY);
			
			timer = new Timer(speed*1000, repeatCount);
			
			//start screen
			reset();
			
			addEventListener("BubbleSelected", bubbleClickHandler);
			
		}
		
		public static function getInstance():GameBoard {
			return _instance;
		}
		
		public function addBubbles(countries:Array) {
					
			for each(var countryName:String in countries){
				
				var startX = calculateX(data[countryName].tfr[0],"toPixels");
				var startY = calculateY(data[countryName].lex[0],"toPixels");
				var startRadius = calculateRadius(data[countryName].pop[0],"toPixels");
				var color = regionToColor(data[countryName].color);		
				var bubbleContainer:BubbleContainer = new BubbleContainer(countryName, color, startX, startY, startRadius, Sprite(this.getChildByName("labelsContainer")));			
				canvasBubbles.push(bubbleContainer);
			}	
			
			canvasBubbles = canvasBubbles.sortOn("_startRadius",Array.NUMERIC, Array.DESCENDING);
			canvasBubbles.reverse();
			
			for each (var canvasBubble in canvasBubbles) {
				graphicsContainer.addChild(canvasBubble);
			}
		
		}
		
		public function bubbleClickHandler(e:CustomEvent){
			selectedBubbleContainer = e.arg[0];
			selectedBubbleContainerName = selectedBubbleContainer.name;				
			
			
			tuneDownBubbles();
					
		}
		
		public function tuneDownBubbles(){
		
			for each(var bubbleContainer:BubbleContainer in canvasBubbles) {
				if(bubbleContainer.name != selectedBubbleContainerName) {
					TweenMax.to(bubbleContainer,0.2,{alpha: 0.05});
					bubbleContainer._label.visible = false;
				}
			}
		
		}
		
		
		//Animation
		
		public function startAnimaton(){
			repeatCount = data["Sweden"].pop.length-1;
			timer = new Timer(speed*1000, repeatCount);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			timer.start();
		}
		
		public function timerHandler(e:TimerEvent) {
			currentCount = timer.currentCount
			updateAnimation();
			TweenMax.delayedCall(speed, updateYear);
		}
		
		public function updateYear(){
			yearContainer.txt.text = String(1950 + currentCount);
		}
		
		public function updateAnimation(){				
				var newX = calculateX(data[selectedBubbleContainerName].tfr[currentCount],"toPixels");
				var newY = calculateY(data[selectedBubbleContainerName].lex[currentCount],"toPixels");
				var newRadius = calculateRadius(data[selectedBubbleContainerName].pop[currentCount],"toPixels");
				selectedBubbleContainer.update(newX, newY, newRadius);		
		}
			
		public function reset(){
			timer.reset();
			yearContainer.txt.text = "1950";
			selectedBubbleContainerName = "";
			
			while (graphicsContainer.numChildren)
			{
				graphicsContainer.removeChildAt(0);
			}
			
			addBubbles(countries);
		}
		
		
		
		public function showAnswers(answers:Array){
			
			var answerContainer:AnswerBubble;
			//var tweenArray:Array = [];
			
			for each (var answer:Object in answers){	
				
				answerContainer = new AnswerBubble(answer.id);
				answerContainer.x = calculateX(answer.tfr,"toPixels");
				answerContainer.y = calculateY(answer.lex,"toPixels");
			
				graphicsContainer.addChild(answerContainer);
			}

			
			
		}
		
		public function hideLabel(identifier:String){
			switch (identifier) {
				case "x":
				TweenMax.to(_indicatorLabelX,0.2,{alpha : 0});
				break;
				
				case "y":
				TweenMax.to(_indicatorLabelY,0.2,{alpha : 0});
				break;
			}
		}
		
		public function showLabels(){
			TweenMax.allTo([_indicatorLabelX,_indicatorLabelY],0.2,{alpha : 1});
		}
		
		public function calculateX(value, option) {
			
			switch (option) {
				case "toPixels":
					return (value - indicatorMinX) * indicatorDistanceX;
					break;
				
				case "toRealValue" :
					return value / indicatorDistanceX + indicatorMinX;
					break;
			}
		}
		
		
		public function calculateY(yValue, option) {
			
			switch (option) {
				case "toPixels" :
					return canvasHeight - ( (yValue - indicatorMinY) * indicatorDistanceY );
					break;
				
				case "toRealValue" :
					return (canvasHeight - yValue) / indicatorDistanceY + indicatorMinY;
					break;
			}
		}
		
		public function calculateRadius(radiusValue, option) {
			
			switch (option) {
				case "toPixels" :
					var radius:Number = Math.round(Math.sqrt(radiusValue*sizeConstantDividedByPI));
					if(radius < 3) {
						return 3;
					} 
					else {
						return radius;
					}
					
					break;
				
				case "toRealValue" :
					
					// return Math.round(Math.sqrt(radiusValue*sizeConstant/Math.PI));
					break;
			}
			
		}
		
		public function regionToColor(region) {
		
			var bubbleColor:uint = 0xff0000;
			
			switch(region) {
				
				case "South Asia":
					bubbleColor = 0x00bfe7;
					break;
				
				case "Middle East & North Africa":
					bubbleColor = 0x3ade3f;
					break;
				
				case "Sub-Saharan Africa":
					bubbleColor = 0x215eff;
					break;
				
				case "East Asia & Pacific":
					bubbleColor = 0xff3b23;
					break;	
				
				case "America":
					bubbleColor = 0xe7fa1d;
					break;
				
				case "Europe & Central Asia":
					bubbleColor = 0xff9820;
					break;					
				
				default:
					bubbleColor = 0xff0000;
					break;	

		}

		return bubbleColor;
	
		}
		
		
	}
}