package com.pingfit.data.objects {
	
	import com.pingfit.util.Util;
	
	public class Pl {
		

		private var plid:int = 1;
		private var name:String = "dNeero";
		private var airlogo:String = "";
		private var airbgcolor:String = "";

		
		public function Pl() { }
		
		public function load(xmlData:XML):void {
			trace("Pl: load() called XML="+xmlData);
			if (xmlData!=null){
				plid = int(xmlData.plid);
				name = xmlData.name;
				airlogo = xmlData.airlogo;
				airbgcolor = xmlData.airbgcolor;
			}
		}
		
		public function getPlid():int{return plid;}
		public function setPlid(plid:int):void{this.plid=plid;}
		
		public function getName():String{return name;}
		public function setName(name:String):void{this.name=name;}
		
		public function getAirlogo():String{return airlogo;}
		public function setAirlogo(airlogo:String):void{this.airlogo=airlogo;}
		
		public function getAirbgcolor():String{return airbgcolor;}
		public function setAirbgcolor(airbgcolor:String):void{this.airbgcolor=airbgcolor;}

	}
	
}