package com.pingfit.data.objects {
	
	import com.pingfit.util.Util;
	
	public class Pingback {
		

		private var pingbackid:int;
		private var userid:int;
		private var date:String;
		private var reps:int;
		private var exercise:Exercise;

		
		public function Pingback() { }
		
		public function load(xmlData:XML):void{
			if (xmlData!=null){
				pingbackid = int(xmlData.pingbackid);
				userid = int(xmlData.userid);
				date = xmlData.date;
				reps = int(xmlData.reps);
				var ex:Exercise = new Exercise();
				ex.load(xmlData.exercise);
				exercise = ex;
			}
		}
		
		public function getPingbackid():int{return pingbackid;}
		public function setPingbackid(pingbackid:int):void { this.pingbackid = pingbackid; }
		
		public function getUserid():int{return userid;}
		public function setUserid(userid:int):void { this.userid = userid; }
		
		public function getDate():String{return date;}
		public function setDate(date:String):void { this.date = date; }
		
		public function getReps():int{return reps;}
		public function setReps(reps:int):void { this.reps = reps; }
		
		public function getExercise():Exercise{return exercise;}
		public function setExercise(date:Exercise):void { this.exercise = exercise; }

	}
	
}