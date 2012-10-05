package com.pingfit.data.objects {
	
	import com.pingfit.util.Util;
	
	public class ExerciseList {
		
		private var exerciselistid:int;
		private var name:String;
		private var description:String;
		private var ispublic:Boolean;
		private var issystem:Boolean;
		private var issystemdefault:Boolean;
		private var isautoadvance:Boolean;
		private var useridofcreator:int;
		
		public function ExerciseList() { }
		
		public function load(xmlData:XML):void{
			//trace("objects.ExerciseList xmlData=\n"+xmlData);
			if (xmlData!=null){
				exerciselistid = int(xmlData.exerciselistid);
				name = xmlData.title;
				description = xmlData.description;
				ispublic = Util.booleanFromString(xmlData.ispublic);
				issystem = Util.booleanFromString(xmlData.issystem);
				issystemdefault = Util.booleanFromString(xmlData.issystemdefault);
				isautoadvance = Util.booleanFromString(xmlData.isautoadvance);
				useridofcreator = int(xmlData.useridofcreator);
			}
		}
		
		public function getExerciselistid():int{return exerciselistid;}
		public function setExerciselistid(exerciselistid:int):void{this.exerciselistid=exerciselistid;}
		
		public function getName():String{return name;}
		public function setName(name:String):void{this.name=name;}
		
		public function getDescription():String{return description;}
		public function setDescription(description:String):void{this.description=description;}
		
		public function getIspublic():Boolean{return ispublic;}
		public function setIspublic(ispublic:Boolean):void{this.ispublic=ispublic;}
		
		public function getIssystem():Boolean{return issystem;}
		public function setIssystem(issystem:Boolean):void{this.issystem=issystem;}
		
		public function getIssystemdefault():Boolean{return issystemdefault;}
		public function setIssystemdefault(issystemdefault:Boolean):void{this.issystemdefault=issystemdefault;}
		
		public function getIsautoadvance():Boolean{return isautoadvance;}
		public function setIsautoadvance(isautoadvance:Boolean):void{this.isautoadvance=isautoadvance;}
		
		public function getUseridofcreator():int{return useridofcreator;}
		public function setUseridofcreator(useridofcreator:int):void{this.useridofcreator=useridofcreator;}	
	
	}
	
}