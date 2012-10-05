﻿package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallCreateRoom extends XmlCallBase {
		


		public function CallCreateRoom(name:String, description:String, exerciselistid:int, isprivate:Boolean, isfriendautopermit:Boolean) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "createRoom"));
			methodParams.push(new MethodParam("name", name));
			methodParams.push(new MethodParam("description", description));
			methodParams.push(new MethodParam("exerciselistid", String(exerciselistid)));
			methodParams.push(new MethodParam("isprivate", String(isprivate)));
			methodParams.push(new MethodParam("isfriendautopermit", String(isfriendautopermit)));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}