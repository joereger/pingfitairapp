package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallInviteByEmail extends XmlCallBase {
		


		public function CallInviteByEmail(emailtoinvite:String, custommessage:String) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "inviteByEmail"));
			methodParams.push(new MethodParam("emailtoinvite", emailtoinvite));
			methodParams.push(new MethodParam("custommessage", custommessage));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}