package com.pingfit.data.objects {
	
	import com.pingfit.util.Util;
	
	public class Exercise {
		

		private var exerciseid:int;
		private var name:String;
		private var description:String;
		private var image:String;
		private var imagecredit:String;
		private var imagecrediturl:String;
		private var reps:int;
		private var ispublic:Boolean;
		private var issystem:Boolean;
		private var exerciseplaceinlist:String;
		private var timeinseconds:int;
		private var exerciselistid:int;
		private var exerciselistitemid:int;
	
		
		
		public function Exercise() { }
		
		public function load(xmlData:XML):void{
			if (xmlData!=null){
				exerciseid = int(xmlData.exerciseid);
				name = xmlData.title;
				description = xmlData.description;
				image = xmlData.image;
				imagecredit = xmlData.imagecredit;
				imagecrediturl = xmlData.imagecrediturl;
				reps = int(xmlData.reps);
				ispublic = Util.booleanFromString(xmlData.ispublic);
				issystem = Util.booleanFromString(xmlData.issystem);
				exerciseplaceinlist = xmlData.exerciseplaceinlist;
				timeinseconds = int(xmlData.timeinseconds);
				exerciselistid = int(xmlData.exerciselistid);
				exerciselistitemid = int(xmlData.exerciselistitemid);
			}
		}
		
		public function getExerciseid():int{return exerciseid;}
		public function setExerciseid(exerciseid:int):void{this.exerciseid=exerciseid;}
		
		public function getName():String{return name;}
		public function setName(name:String):void{this.name=name;}
		
		public function getDescription():String{return description;}
		public function setDescription(description:String):void{this.description=description;}
		
		public function getImage():String{return image;}
		public function setImage(image:String):void{this.image=image;}
		
		public function getImagecredit():String{return imagecredit;}
		public function setImagecredit(imagecredit:String):void { this.imagecredit = imagecredit; }
		
		public function getImagecrediturl():String{return imagecrediturl;}
		public function setImagecrediturl(imagecrediturl:String):void{this.imagecrediturl=imagecrediturl;}
		
		public function getReps():int{return reps;}
		public function setReps(reps:int):void{this.reps=reps;}
		
		public function getIspublic():Boolean{return ispublic;}
		public function setIspublic(ispublic:Boolean):void{this.ispublic=ispublic;}
		
		public function getIssystem():Boolean{return issystem;}
		public function setIssystem(issystem:Boolean):void{this.issystem=issystem;}
		
		public function getExerciseplaceinlist():String{return exerciseplaceinlist;}
		public function setExerciseplaceinlist(exerciseplaceinlist:String):void{this.exerciseplaceinlist=exerciseplaceinlist;}
		
		public function getTimeinseconds():int{return timeinseconds;}
		public function setTimeinseconds(timeinseconds:int):void{this.timeinseconds=timeinseconds;}
		
		public function getExerciselistid():int{return exerciselistid;}
		public function setExerciselistid(exerciselistid:int):void{this.exerciselistid=exerciselistid;}
	
		public function getExerciselistitemid():int{return exerciselistitemid;}
		public function setExerciselistitemid(exerciselistitemid:int):void{this.exerciselistitemid=exerciselistitemid;}

	}
	
}