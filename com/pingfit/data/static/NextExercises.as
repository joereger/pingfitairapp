package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.events.*;
	import com.pingfit.xml.CallGetNextExercises;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	
	public class NextExercises extends EventDispatcher {
		
		private static var nextExercises:Array;
		
		
		public function NextExercises() { }
		
		public static function load(xmlData:XML):void{
			var nextExercises:Array = new Array();
			if (xmlData!=null){
				var secondsuntilnextexercise:int = int(xmlData.attribute("secondsuntilnextexercise"));
				NextWorkoutTimer.getTimer().reset(secondsuntilnextexercise);
			
				var exercises:XMLList  = xmlData.exercise;
				for each (var ex:XML in exercises) {
					var exercise:Exercise = new Exercise();
					exercise.load(ex);
					nextExercises.push(exercise);
				}
			}
			NextExercises.setNextExercises(nextExercises);
		}
		
		public static function getCurrentExercise():Exercise{
			if (nextExercises!=null && nextExercises.length>0){
				return nextExercises[0];
			}
			trace("NextExercises was empty... doh!");
			return new Exercise();
		} 
		
		public static function advanceOneExercise():void{
			trace("NextExercises.advanceOneExercise()");
			if (nextExercises!=null){
				trace("NextExercises.advanceOneExercise() PRE  nextExercises.length="+nextExercises.length);
				nextExercises.shift();
				trace("NextExercises.advanceOneExercise() POST nextExercises.length="+nextExercises.length);
			}
			if (nextExercises==null || nextExercises.length<=2){
				//Go refresh
				trace("NextExercises.advanceOneExercise() had <=2 exercises left... time to refresh the pot");
				refreshViaAPI();
			}
		}
		
		public static function setNextExercises(newNextExercises:Array):void{
			var isItADifferentExercise:Boolean = true;
			if (nextExercises!=null && newNextExercises!=null && nextExercises.length>0 && newNextExercises.length>0 && nextExercises[0].getExerciseid()==newNextExercises[0].getExerciseid()){
				isItADifferentExercise = false;
			}
			NextExercises.nextExercises=newNextExercises;
			if (isItADifferentExercise){
				Broadcaster.dispatchEvent(new PEvent(PEvent.NEWEXERCISEDATALOADED));
			}
		}
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetNextExercises = new CallGetNextExercises();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("NextExercises.onApiCallSuccess()");
			load(e.xmlData.nextexercises[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
		
		
	
	}
	
}