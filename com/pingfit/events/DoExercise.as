package com.pingfit.events {
	
	import flash.events.Event;
	import com.pingfit.data.objects.Exercise;
	
	public class DoExercise extends Event {
		
		public static var TYPE:String = "DoExerciseEvent";
		public var exercise:Exercise;  
		
		public function DoExercise(exercise:Exercise) { 
			this.exercise = exercise;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new DoExercise(exercise);
		}

	}
	
}