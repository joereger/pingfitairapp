package com.pingfit.events {
	
	import flash.events.Event;
	import com.pingfit.data.objects.Exercise;
	
	public class SkipExercise extends Event {
		
		public static const TYPE:String = "SkipExercise";
		public var exercise:Exercise;  
		
		public function SkipExercise(exercise:Exercise) { 
			this.exercise = exercise;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new SkipExercise(exercise);
		}

	}
	
}