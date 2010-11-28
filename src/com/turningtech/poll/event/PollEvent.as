package com.turningtech.poll.event {
	import flash.events.Event;
	/**
	 * ...
	 * @author Turning Technologies
	 */
	public class PollEvent extends Event{
		public static const STARTED:String = "pollStarted";
		public static const STOPPED:String = "pollStopped";
		public static const ERROR:String = "pollError";
		
		private var error:String;
		
		public function PollEvent(type:String, error:String) {
			super(type);
			this.error = error;
		}
		
		public function get errorMessage():String {
			return this.error;
		}
	}

}