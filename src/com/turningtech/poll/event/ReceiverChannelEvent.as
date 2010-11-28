package com.turningtech.poll.event {
	import flash.events.Event;
	/**
	 * ...
	 * @author Turning Technologies
	 */
	public class ReceiverChannelEvent extends Event {
		
		public static const CHANGED:String = "channel";
		public static const ERROR:String = "error";
		
		private var eventData:String;
		private var _errorMessage:String;
		
		public function ReceiverChannelEvent(type:String, value:String) {
			super(type);
			if (type == ERROR) {
				_errorMessage = value;
			} else 
				eventData = value;
		}
		
		public function get value():String {
			return eventData;
		}
		
		public function get errorMessage():String {
			return _errorMessage;
		}
		
	}

}