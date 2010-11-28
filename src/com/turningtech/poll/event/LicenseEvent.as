package com.turningtech.poll.event {
	import flash.events.Event;
	/**
	 * ...
	 * @author Turning Technologies
	 */
	public class LicenseEvent extends Event{
		public static const INVALID:String = "invalidLicense";
		public static const VALID:String = "validLicense";
		
		public function LicenseEvent(type:String) {
			super(type);
		}
		
	}

}