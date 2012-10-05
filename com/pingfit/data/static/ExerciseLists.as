package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.*;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;

	
	public class ExerciseLists extends EventDispatcher {
		
		private static var exerciseLists:Array;
		
		public function ExerciseLists() { }
		
		public static function load(xmlData:XML):void{
			var exerciseLists:Array = new Array();
			if (xmlData!=null){
				var exerciselists:XMLList  = xmlData.exerciselist;
				for each (var exerciselist:XML in exerciselists) {
					var exerciseList:ExerciseList = new ExerciseList();
					exerciseList.load(exerciselist);
					exerciseLists.push(exerciseList);
				}
			}
			ExerciseLists.setExerciseLists(exerciseLists);
		}
		
		public static function getExerciseLists():Array{
			return exerciseLists;
		} 
		public static function setExerciseLists(exerciseLists:Array):void{
			ExerciseLists.exerciseLists=exerciseLists;
		}
		public static function getByExerciselistid(exerciselistid:int):ExerciseList{
			for each (var exerciselist:ExerciseList in exerciseLists) {
				if (exerciselist.getExerciselistid()==exerciselistid){
					return exerciselist;
				}
			}
			return null;
		}
		public static function getCurrentExerciseList():ExerciseList{
			return getByExerciselistid(NextExercises.getCurrentExercise().getExerciselistid());
		}
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetExerciseLists = new CallGetExerciseLists();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.exerciselists[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}