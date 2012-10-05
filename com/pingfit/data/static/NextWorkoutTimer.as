package com.pingfit.data.static {
	
	import com.pingfit.timing.*;
	import com.pingfit.events.Broadcaster;
	
	public class NextWorkoutTimer {
		
		private static var countdownTimer:CountdownSecondsTimer;
	
		public function NextWorkoutTimer() { }
		
		public static function getTimer():CountdownSecondsTimer{
			if (countdownTimer==null){
				countdownTimer = new CountdownSecondsTimer(0, "nextWorkoutTimer");
			}
			return countdownTimer
		}
		
		public static function setTimer(countdownTimer:CountdownSecondsTimer):void{
			NextWorkoutTimer.countdownTimer = countdownTimer;
		}
		
		public static function resetWithNextExercisesAndUser():void{
			if (CurrentUser.getUser().getExercisechooserid()==2){
				NextWorkoutTimer.getTimer().reset(NextExercises.getCurrentExercise().getTimeinseconds());
			} else {
				NextWorkoutTimer.getTimer().reset(60 * CurrentUser.getUser().getExerciseeveryxminutes());
			}
		}
		

	}
	
}