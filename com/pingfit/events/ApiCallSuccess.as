package com.pingfit.events {
	
	import flash.events.Event;
	
	public class ApiCallSuccess extends Event {
		
		public static const TYPE:String = "ApiCallSuccess";
		public var xmlData:XML;  
		
		public function ApiCallSuccess(xmlData:XML) { 
			this.xmlData = xmlData;
			super(TYPE);
		}
		
		public override function clone():Event{
			return new ApiCallSuccess(xmlData);
		}

	}
	
}