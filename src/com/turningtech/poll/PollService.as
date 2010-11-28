package com.turningtech.poll
{
	import com.turningtech.poll.event.LicenseEvent;
	import com.turningtech.poll.event.PollEvent;
	import com.turningtech.poll.event.ReceiverChannelEvent;
	import com.turningtech.poll.event.ReceiverListEvent;
	import com.turningtech.poll.event.ResponseEvent;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.XMLSocket;
	import flash.net.navigateToURL;
	import flash.system.Security;
	/**
	 * ...
	 * @author Turning Technologies
	 */
	public class PollService extends EventDispatcher{
		/**
		 *
		 */
		private static var _instance:PollService;
		
		private var socket:XMLSocket;

		//protocol definition
		private static const TYPE_REQUEST:String = "request";
		private static const TYPE_REPLY:String = "reply";
		private static const MSG_SEP:String= "~";
		private static const PARAM_SEP:String = ";";
		private static const VALUE_SEP:String = ":";
		private static const KEY_SEP:String = "=";

		private static const CMD_VALIDATE_LICENSE:String = "validateLicense";
		private static const CMD_START_POLL:String = "startPoll";
		private static const CMD_STOP_POLL:String = "stopPoll";
		private static const CMD_SET_RECIEVER_CHANNEL:String = "setReceiverChannel";
		private static const CMD_RECEIVER_LIST:String = "listReceivers";
		private static const CMD_EXIT:String = "exit";
		private static const RESPONSE:String = "response";

		private static const PARAM_REFRESH_RECEIVERS:String = "refresh";
		private static const PARAM_RECEIVER_LIST_NAMES:String = "receiverNames";
		private static const PARAM_RECEIVER_LIST_IDS:String = "receiverIds";
		private static const PARAM_RECEIVER_LIST_CHANNELS:String = "receiverChannels";
		private static const PARAM_RECEIVER_INDEX:String = "index";
		private static const PARAM_RECEIVER_CHANNEL:String = "channel";
		private static const PARAM_RESPONSE_DATA:String = "resposeData";
		private static const PARAM_RESPONSE_CARD_ID:String = "resposeCardId";
		private static const PARAM_RESPONSE_RECEIVER_ID:String = "receiverId";
		private static const PARAM_COMPANY_NAME:String = "companyName";
		private static const PARAM_LICENSE:String = "license";
		private static const PARAM_RESULT:String = "result";
		private static const PARAM_ERROR:String = "error";
		
		private var licenseValid:Boolean = false;
		private var polling:Boolean = false;
		
		private static const DEFAULT_PORT:int = 8013;
		private var port:int = DEFAULT_PORT;
		
		//support install
		private var supportInstalled:Boolean = false;
		private var supportUrl:String = "file:///C:/development/RI_SDK_1/launch.jnlp"
		
		public function PollService(port:int = DEFAULT_PORT, supportUrl:String = null):void 	{
			_instance = this;
			this.supportUrl = supportUrl;
			
			if (port > 1024) 
				this.port = port;
		}
		
		public static function getInstance():PollService {
			return _instance;
		}
		

		public function start():void {
			if (isConnected) {
				return;
			}
			
			if (socket == null) {
				socket = new XMLSocket();	
				socket.addEventListener(DataEvent.DATA, handleData);
				socket.addEventListener(IOErrorEvent.IO_ERROR, handleError);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			}

			socket.connect("localhost", port);
			
			if (!isConnected) {
				//installSDKSupport();
			}
			
		}

		public function get isConnected():Boolean {
			if (socket == null)
				return false;
			else
				return socket.connected;
		}

		public function initializeLicense(companyName:String, licenseKey:String):void {
			//request:isValidLicense|companyName:sadfsdf,licenseKey:asdfasdfsdaf
			var params:Array = new Array();
			params[PARAM_COMPANY_NAME] = companyName;
			params[PARAM_LICENSE] = licenseKey;

			sendRequest(CMD_VALIDATE_LICENSE, params);

		}
		
		public function get isValid():Boolean {
			return licenseValid;
		}
		
		public function get isPolling():Boolean {
			return polling;
		}
		
		public function startPolling():void { 
			throwErrorIfLicenseInvalid();
			
			sendRequest(CMD_START_POLL,null);
		}
		
		public function stopPolling():void { 
			throwErrorIfLicenseInvalid();
			
			sendRequest(CMD_STOP_POLL,null);
		}
		
		public function stopPollingSupport():void {
			sendRequest(CMD_EXIT,null);
		}
		
		public function requestReceiverInfo(refresh:Boolean):void {
			var params:Array = new Array();
			if (refresh == true) {
				params[PARAM_REFRESH_RECEIVERS] = "true";	
			} else {
				params[PARAM_REFRESH_RECEIVERS] = "false";
			}
			
			sendRequest(CMD_RECEIVER_LIST,params);
		}
		
		public function setChannel(receiverIndex:int, channel:int):void {
			var params:Array = new Array();
			params[PARAM_RECEIVER_INDEX] = "" + receiverIndex;
			params[PARAM_RECEIVER_CHANNEL] = "" +  channel;
			sendRequest(CMD_SET_RECIEVER_CHANNEL, params);
		}
		
		private function throwErrorIfLicenseInvalid():void {
			if (!isValid) {
				throw new Error("No valid SDK license found. Please call 'initializeLicense' before using the SDK");
			}
		}

		private function createMessage(messageType:String, message:String, params:Array):String {
			var msg:String = messageType + KEY_SEP + message + MSG_SEP
			for (var key:Object in params) {
				msg += key + KEY_SEP + params[key] + PARAM_SEP;
			}
			msg = msg.substring(0, msg.length - 1);
			//trace(msg)
			return msg
		}

		private function sendRequest(command:String, params:Array):void {
			send(createMessage(TYPE_REQUEST, command, params));
		}

		private function send(message:String):void {
			if (! isConnected ) {
				start();
			}
			socket.send(message);
		}

		private function handleData(event:DataEvent):void {
			var message:String = event.data
			//trace("received:"+message);
			//send(message);
			if (message == null)
			return;

			var parts:Array = message.split(MSG_SEP);
			var header:Array = parts[0].split(KEY_SEP);
			var type:String = header[0];
			var _message:String = header[1];

			var params:Array = new Array();
			
			if (parts.length == 2) {
					var _params:Array = parts[1].split(PARAM_SEP);
				var i:int;
				for (i = 0; i < _params.length; i++) {
					var param:Array = _params[i].split(KEY_SEP);
					params[param[0]] = param[1];
				}
			}						

			if (TYPE_REQUEST == (type)) {
				processRequest(_message,params);
			} else if (TYPE_REPLY == (type)) {
				processReply(_message,params);
			}

		}

		private function processRequest(requestName:String , params:Array):void{
			//trace("request:" + requestName);
			//for (var key:Object in params) {
			//	trace(key + PARAM_SEP + params[key]);
			//}
			dispatchEvent(new PollEvent(PollEvent.ERROR, requestName));
		}

		private function processReply(replyName:String, params:Array):void {
			//trace("reply:"+replyName);
			//for (var key:Object in params) {
			//	trace(key + KEY_SEP + params[key]);
			//}
			
			var result:String = params[PARAM_RESULT];
			var error:String = params[PARAM_ERROR];

			if (replyName == CMD_VALIDATE_LICENSE) {
				if (result == "true") {
					licenseValid = true;
					dispatchEvent(new LicenseEvent(LicenseEvent.VALID));
				} else {
					licenseValid = false;
					dispatchEvent(new LicenseEvent(LicenseEvent.INVALID));
				}
			}
			
			if (replyName == CMD_START_POLL) {
				if (result == "true") {
					polling = true;
					dispatchEvent(new PollEvent(PollEvent.STARTED, error));
				} else {
					dispatchEvent(new PollEvent(PollEvent.ERROR, error));
				}
			}
			
			if (replyName == CMD_STOP_POLL) {
				if (result == "true") {
					polling = false;
					dispatchEvent(new PollEvent(PollEvent.STOPPED, error));
				} else {
					dispatchEvent(new PollEvent(PollEvent.ERROR, error));
				}
			}
					
			if (replyName == RESPONSE) {
				var response:String = params[PARAM_RESPONSE_DATA];
				var receiverId:String = params[PARAM_RESPONSE_RECEIVER_ID];
				var responseCardId:String = params[PARAM_RESPONSE_CARD_ID];
				dispatchEvent(new ResponseEvent(receiverId, responseCardId, response));
			}
			
			if (replyName == CMD_SET_RECIEVER_CHANNEL) {
				if (error != null) {
					dispatchEvent(new ReceiverChannelEvent(ReceiverChannelEvent.ERROR, error));
				} else {
					dispatchEvent(new ReceiverChannelEvent(ReceiverChannelEvent.CHANGED, result));
				}
			}
			
			if (replyName == CMD_RECEIVER_LIST) {
				var data:Array = new Array();
				if (error != null) {
					dispatchEvent(new ReceiverListEvent(ReceiverListEvent.ERROR, null, error));
				}
				//parse result
				//id=1,2,3,4;name=sdaf,asdf,asdf;channel=33,22,44
				var idString:String = params[PARAM_RECEIVER_LIST_IDS];
				var nameString:String = params[PARAM_RECEIVER_LIST_NAMES];
				var channelString:String = params[PARAM_RECEIVER_LIST_CHANNELS];
				if (idString != null) {
					var ids:Array = idString.split(VALUE_SEP);
					data["receiverIds"] = ids;
				}
				if (nameString != null) {
					var names:Array = nameString.split(VALUE_SEP);
					data["receiverNames"] = names;
				}
				if (channelString != null) {
					var channels:Array = channelString.split(VALUE_SEP);
					data["receiverChannels"] = channels;
				}
				
				dispatchEvent(new ReceiverListEvent(ReceiverListEvent.ALL_DATA, data, error));
			}
			
		}
		
		private function installSDKSupport():void {
			if (!supportInstalled && supportUrl != null) {
				dispatchEvent(new PollEvent(PollEvent.ERROR, "Started poll service. "));
				var targetURL:URLRequest = new URLRequest(supportUrl);
				navigateToURL(targetURL, "_self");
				supportInstalled = true;
			} else if (!isConnected && supportInstalled) {
				//try  starting
				//start();
			}
		}

		private function handleError(event:IOErrorEvent):void {
			//trace("(" + event.type + ") " + event.text + ":" + event.toString);
			dispatchEvent(new PollEvent(PollEvent.ERROR, "Unable to connect to Poll service:"+event.text));
			installSDKSupport();
		}
		
		private function handleSecurityError(event:SecurityErrorEvent):void {
			//trace("(" + event.type + ") " + event.text + ":" + event.toString);
			dispatchEvent(new PollEvent(PollEvent.ERROR, "Unable to connect to Poll service:"+event.text));
		}

	}

}

