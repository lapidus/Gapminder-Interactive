package com.turningtech.poll.event
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Turning Technologies
	 */
	public class ResponseEvent extends Event
	{
		public static const RESPONSE:String = "Response";
		private var _receiverId:String;
		private var _responseCardId:String;
		private var _response:String;
		
		public function ResponseEvent(receiverId:String, responseCardId:String, response:String) 
		{
			super(RESPONSE);
			this._receiverId = receiverId;
			this._responseCardId = responseCardId;
			this._response = response;
		}
		
		public function get receiverId():String {
			return this._receiverId;
		}
		
		public function get responseCardId():String {
			return this._responseCardId;
		}
		
		public function get response():String  {
			return this._response;
		}
	}

}