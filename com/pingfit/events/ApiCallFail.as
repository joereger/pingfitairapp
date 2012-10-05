package com.pingfit.events {
	
	import flash.events.Event;
	
	public class ApiCallFail extends Event {
		
		public static const TYPE:String = "ApiCallFail";
		public var xmlData:XML; 
		public var error:String;
		public var errorcode:String;
		
		public function ApiCallFail(xmlData:XML, error:String, errorcode:String) { 
			this.xmlData = xmlData;
			trace("ApiCallFail xmlData="+xmlData);
			this.error = error;
			this.errorcode = errorcode;
			super(TYPE);
		}
		
		public override function clone():Event{
			return new ApiCallFail(xmlData, error, errorcode);
		}

	}
	
}