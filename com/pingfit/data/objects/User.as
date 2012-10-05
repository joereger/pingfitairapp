package com.pingfit.data.objects {
	
	import com.pingfit.util.Util;
	
	public class User {
		
		private var userid:int;
		private var email:String;
		private var firstname:String;
		private var lastname:String;
		private var nickname:String;
		private var exerciselistid:int;
		private var exercisechooserid:int;
		private var exerciseeveryxminutes:int;
		private var isusereulauptodate:Boolean;
		private var room:Room;
		private var plid:int;
		private var pingbacks:Array;
		private var facebookuid:String;
		private var profileimageurl:String;
		private var isonline:Boolean;
		
		public function User() { }
		
		public function load(xmlData:XML):void{
			if (xmlData!=null){
				userid = int(xmlData.userid);
				plid = int(xmlData.plid);
				email = xmlData.email;
				firstname = xmlData.firstname;
				lastname = xmlData.lastname;
				nickname = xmlData.nickname;
				profileimageurl = xmlData.profileimageurl;
				facebookuid = xmlData.facebookuid;
				exerciselistid = int(xmlData.exerciselistid);
				exercisechooserid = int(xmlData.exercisechooserid);
				//trace("objects.User.load() exercisechooserid="+exercisechooserid);
				exerciseeveryxminutes = int(xmlData.exerciseeveryxminutes);
				isusereulauptodate = Util.booleanFromString(xmlData.isusereulauptodate);
				var room:Room = new Room();
				room.load(xmlData.room[0]);
				this.room = room;
				this.isonline = false;
				//Load the pingbacks
				var tmpPingbacks:Array = new Array();
				var pingbacksXML:XMLList  = xmlData.pingback;
				trace("User.as - xmlData.pingback="+xmlData.pingback);
				for each (var pingback:XML in pingbacksXML) {
					trace("User.as - pingback="+pingback);
					var pingbackObj:Pingback = new Pingback();
					pingbackObj.load(pingback);
					tmpPingbacks.push(pingbackObj);
				}
				pingbacks = tmpPingbacks;
			}
		}
		
		public function getUserid():int{return userid;}
		public function setUserid(userid:int):void { this.userid = userid; }
		
		public function getPlid():int{return plid;}
		public function setPlid(plid:int):void{this.plid=plid;}
		
		public function getEmail():String{return email;}
		public function setEmail(email:String):void{this.email=email;}
		
		public function getFirstname():String{return firstname;}
		public function setFirstname(firstname:String):void{this.firstname=firstname;}
		
		public function getLastname():String{return lastname;}
		public function setLastname(lastname:String):void{this.lastname=lastname;}
		
		public function getNickname():String{return nickname;}
		public function setNickname(nickname:String):void { this.nickname = nickname; }
		
		public function getProfileimageurl():String{return profileimageurl;}
		public function setProfileimageurl(profileimageurl:String):void{this.profileimageurl=profileimageurl;}
		
		public function getFacebookuid():String{return facebookuid;}
		public function setFacebookuid(facebookuid:String):void{this.facebookuid=facebookuid;}
		
		public function getExerciselistid():int{return exerciselistid;}
		public function setExerciselistid(exerciselistid:int):void{this.exerciselistid=exerciselistid;}
		
		public function getExercisechooserid():int{return exercisechooserid;}
		public function setExercisechooserid(exercisechooserid:int):void{this.exercisechooserid=exercisechooserid;}
		
		public function getExerciseeveryxminutes():int{return exerciseeveryxminutes;}
		public function setExerciseeveryxminutes(exerciseeveryxminutes:int):void{this.exerciseeveryxminutes=exerciseeveryxminutes;}
		
		public function getIsusereulauptodate():Boolean{return isusereulauptodate;}
		public function setIsusereulauptodate(isusereulauptodate:Boolean):void{this.isusereulauptodate=isusereulauptodate;}
		
		public function getRoom():Room{return room;}
		public function setRoom(room:Room):void { this.room = room; }
		
		public function getPingbacks():Array{return pingbacks;}
		public function setPingbacks(pingbacks:Array):void { this.pingbacks = pingbacks; }
		
		public function getIsonline():Boolean{return isonline;}
		public function setIsonline(isonline:Boolean):void { this.isonline = isonline; }
		

	}
	
}