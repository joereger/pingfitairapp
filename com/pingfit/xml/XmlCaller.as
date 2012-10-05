package com.pingfit.xml
{
	

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	import com.pingfit.xml.ApiParams;
	

	public class XmlCaller extends EventDispatcher{
		
		public static const XML_LOADED = "xml_loaded";
		public static const XML_ERROR = "xml_error";
		private var xmlLoader:URLLoader  = new  URLLoader();
		private var xmlData:XML = new XML();
		private var apiParams:ApiParams;
		private var methodParams:Array;
		
		public function XmlCaller(methodParams:Array){
			//trace("XmlCaller instanciated");
			this.methodParams = methodParams;
			//Add params to string
			var paramsAsString:String = "";
			for each (var methodParam:MethodParam in methodParams) {
				paramsAsString = paramsAsString + "&" + methodParam.getName() + "=" + methodParam.getValue();
			}
			//Call the api
			xmlLoader = new URLLoader();
			xmlData = new XML();
			xmlLoader.addEventListener(Event.COMPLETE, loadXML);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadXMLError);
			xmlLoader.load(new URLRequest(ApiParams.getBaseurl()+"api.xml?email="+ApiParams.getEmail()+"&password="+ApiParams.getPassword()+"&facebookapikey="+ApiParams.getFacebookapikey()+"&facebook_session_key="+ApiParams.getFacebook_session_key()+"&facebook_session_secret="+ApiParams.getFacebook_session_secret()+"&facebookuid="+ApiParams.getFacebookuid()+""+paramsAsString));
		}
		
		function loadXML(e:Event):void{
			//trace("XmlCaller -- loadXML() called");
			xmlData = new XML(e.target.data);
			//trace(xmlData);
			dispatchEvent(new Event(XmlCaller.XML_LOADED));
		}
		
		function loadXMLError(e:Event):void{
			//trace("XmlCaller -- loadXMLError() called");
			dispatchEvent(new Event(XmlCaller.XML_ERROR));
		}
		
        public function getXmlData():XML{
			return xmlData;
		}
		
	}
	
	
}