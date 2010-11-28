package com.turningtech.poll.event
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Turning Technologies
	 */
	public class ReceiverListEvent extends Event
	{
		public static const ALL_DATA:String = "receiverSummary";
		public static const ERROR:String = "reciverSummaryError";
		
		private var PROP_RECEIVER_ID:String = "receiverIds";
		private var PROP_RECEIVER_NAME:String = "receiverNames";
		private var PROP_RECEIVER_CHANNEL:String = "receiverChannels";
		
		private var data:Array = new Array();
		private var _error:String;
		
		public function ReceiverListEvent(type:String, data:Array, error:String) 
		{
			super(type);
			this.data = data;
			this._error = error;
		}
		
		public function get errorMessage():String {
			return _error;
		}
		
		public function get count():int {
			var r:Array = data[PROP_RECEIVER_ID];
			if (r == null) {
				return 0;
			} 
			var _r:String = r[0] as String;
			if (_r.length < 1) {
				return 0;
			}
			
			return r.length;
		}
		
		public function getReceiverId(index:int):String {
			if (index < count) {
				return data[PROP_RECEIVER_ID][index];
			} 
			return null;
		}
		
		public function getReceiverName(index:int):String {
			trace("looking for rname:" + index);
			if (index < count) {
				return data[PROP_RECEIVER_NAME][index];
			} 
			return null;
		}
		
		public function getReceiverChannel(index:int):String {
			if (index < count) {
				return data[PROP_RECEIVER_CHANNEL][index];
			} 
			return null;
		}
		
	}

}