package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class XmlCallBase extends EventDispatcher {
		
		public var xmlCaller:XmlCaller;
		//public var xmlData:XML = new XML();

		public function XmlCallBase(){}
	
		public function doneLoading(e:Event):void{
			//trace("XmlCallBase.doneLoading() - Is this an error??? xmlCaller.getXmlData()=" + xmlCaller.getXmlData());
			if (xmlCaller.getXmlData().success == "false") {
				trace("XmlCallBase.doneLoading() - Is an error xmlCaller.getXmlData().apimessage="+xmlCaller.getXmlData().apimessage+" xmlCaller.getXmlData().errorcode="+xmlCaller.getXmlData().errorcode);
				dispatchEvent(new ApiCallFail(xmlCaller.getXmlData(), xmlCaller.getXmlData().apimessage, xmlCaller.getXmlData().errorcode));
			} else {
				trace("XmlCallBase.doneLoading() - Not an error");
				dispatchEvent(new ApiCallSuccess(xmlCaller.getXmlData()));
			}	
		}
		
		public function errorLoading(e:Event):void{
			trace("errorLoading() called");
			dispatchEvent(new ApiCallFail(xmlCaller.getXmlData(), "Are you connected to the internet?", "NETWORKFAIL"));
		}
		
		
        public function getXmlData():XML{
			return xmlCaller.getXmlData();
		}
		
	}
	
}