package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallAddFriendsByFacebookuid extends XmlCallBase {
		


		public function CallAddFriendsByFacebookuid(facebookuids:String) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "addFriendsByFacebookuid"));
			methodParams.push(new MethodParam("facebookuids", facebookuids));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}