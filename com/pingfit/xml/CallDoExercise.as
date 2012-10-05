package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallDoExercise extends XmlCallBase {
		


		public function CallDoExercise(exerciseid:int, reps:int, exerciseplaceinlist:String) { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "doExercise");
			methodParams.push(param0);
			var param1:MethodParam = new MethodParam("exerciseid", String(exerciseid));
			methodParams.push(param1);
			var param2:MethodParam = new MethodParam("reps", String(reps));
			methodParams.push(param2);
			var param3:MethodParam = new MethodParam("exerciseplaceinlist", String(exerciseplaceinlist));
			methodParams.push(param3);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}