package org.gapminder {
	// Import class
	import flash.events.Event;
	// EventType
	public class CustomEvent extends Event {
		// Properties
		public var arg:*;
		// Constructor
		public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, ... a:*) {
			super(type, bubbles, cancelable);
			arg = a;
		}
		// Override clone
		override public function clone():Event{
			return new CustomEvent(type, bubbles, cancelable, arg);
		};
	}
}
