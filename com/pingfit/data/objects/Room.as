package com.pingfit.data.objects {
	
	import com.pingfit.util.Util;
	
	public class Room {
		

		private var roomid:int;
		private var isenabled:Boolean;
		private var issystem:Boolean;
		private var isprivate:Boolean;
		private var isfriendautopermit:Boolean;
		private var useridofcreator:int;
		private var name:String;
		private var description:String;
		private var exerciselistid:int;
		private var exerciseList:ExerciseList;

		
		public function Room() { }
		
		public function load(xmlData:XML):void{
			if (xmlData!=null){
				roomid = int(xmlData.roomid);
				isenabled = Util.booleanFromString(xmlData.isenabled);
				issystem = Util.booleanFromString(xmlData.issystem);
				isprivate = Util.booleanFromString(xmlData.isprivate);
				isfriendautopermit = Util.booleanFromString(xmlData.isfriendautopermit);
				useridofcreator = int(xmlData.useridofcreator);
				name = xmlData.name;
				description = xmlData.description;
				exerciselistid = int(xmlData.exerciselistid);
				if (xmlData.exerciselist[0]!=null){
					var exerciseList:ExerciseList = new ExerciseList();
					exerciseList.load(xmlData.exerciselist[0]);
					this.exerciseList = exerciseList;
				}
			}
		}
		
		public function getRoomid():int{return roomid;}
		public function setRoomid(roomid:int):void{this.roomid=roomid;}
		
		public function getIsenabled():Boolean{return isenabled;}
		public function setIsenabled(isenabled:Boolean):void{this.isenabled=isenabled;}
		
		public function getIssystem():Boolean{return issystem;}
		public function setIssystem(issystem:Boolean):void{this.issystem=issystem;}
		
		public function getIsprivate():Boolean{return isprivate;}
		public function setIsprivate(isprivate:Boolean):void{this.isprivate=isprivate;}
		
		public function getIsfriendautopermit():Boolean{return isfriendautopermit;}
		public function setIsfriendautopermit(isfriendautopermit:Boolean):void{this.isfriendautopermit=isfriendautopermit;}
		
		public function getUseridofcreator():int{return useridofcreator;}
		public function setUseridofcreator(useridofcreator:int):void{this.useridofcreator=useridofcreator;}	
		
		public function getName():String{return name;}
		public function setName(name:String):void{this.name=name;}
		
		public function getDescription():String{return description;}
		public function setDescription(description:String):void{this.description=description;}
		
		public function getExerciselistid():int{return exerciselistid;}
		public function setExerciselistid(exerciselistid:int):void{this.exerciselistid=exerciselistid;}
		
		public function getExerciseList():ExerciseList{return exerciseList;}
		public function setExerciseList(exerciseList:ExerciseList):void{this.exerciseList=exerciseList;}
	
	}
	
}