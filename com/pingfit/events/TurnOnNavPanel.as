package com.pingfit.events {
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class TurnOnNavPanel extends Event {
		
		public static var TYPE:String = "TurnOnNavPanelEvent";
		public var navPanelType:String; 
		public var navPanelName:String;  
		public var timeCreated:Number = 0;
		
		public function TurnOnNavPanel(navPanelType:String, navPanelName:String="", timeCreated:Number=0) { 
			this.navPanelType = navPanelType;
			//It's important to make sure the original time of creation is captured and used in the clone() function
			if (timeCreated==0){
				this.timeCreated = getTimer();
			} else {
				this.timeCreated = timeCreated;
			}
			//If no navPanelName is assigned use the type
			if (navPanelName==""){
				this.navPanelName = navPanelType;
			} else{
				this.navPanelName = navPanelName;
			}
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new TurnOnNavPanel(navPanelType, navPanelName, timeCreated);
		}
		
		

	}
	
}