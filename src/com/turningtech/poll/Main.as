package com.turningtech.poll
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.turningtech.poll.PollService
	/**
	 * ...
	 * @author Turning Technologies
	 */
	public class Main extends Sprite 
	{
		private var socketTest:PollService
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			socketTest.start();
			if (socketTest.isValidLicense("bill", "snyder")) {
				trace("valid");
			} else {
				trace("invalid");
			}
		}
		
		private function init(e:Event = null):void 
		{
			socketTest = new PollService();
			socketTest.start();
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}