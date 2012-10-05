package com.pingfit.nav {
	
	
	import flash.display.MovieClip;
	import com.pingfit.controls.Background;
	import com.pingfit.events.*;
	import flash.events.Event;
	
	
	public class NavPanelAll extends MovieClip {
		
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		
		private var navPanelNotifications:NavPanelNotifications;
		private var navPanelEula:NavPanelEula;
		private var navPanelHelp:NavPanelHelp;
		private var navPanelExercise:NavPanelExercise;
		private var navPanelExerciseLists:NavPanelExerciseLists;
		private var navPanelFriends:NavPanelFriends;
		private var navPanelLoginSignup:NavPanelLoginSignup;
		private var navPanelRooms:NavPanelRooms;
		private var navPanelSettings:NavPanelSettings;

		
		
		public function NavPanelAll(maxWidth:Number, maxHeight:Number){
			//trace("NavPanelAll instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		function initListener(e:Event):void {
			trace("NavPanelAll.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			//Listen
			Broadcaster.addEventListener(TurnOnNavPanel.TYPE, onTurnOnNavPanel);
			Broadcaster.addEventListener(PEvent.EXERCISEALARM, onExerciseAlarm);
			
			navPanelExercise = new NavPanelExercise(maxWidth, maxHeight);
			navPanelExercise.visible = false;
			addChild(navPanelExercise);
			
			navPanelNotifications = new NavPanelNotifications(maxWidth, maxHeight);
			navPanelNotifications.visible = false;
			addChild(navPanelNotifications);
			
			navPanelExerciseLists = new NavPanelExerciseLists(maxWidth, maxHeight);
			navPanelExerciseLists.visible = false;
			addChild(navPanelExerciseLists);
			
			navPanelFriends = new NavPanelFriends(maxWidth, maxHeight);
			navPanelFriends.visible = false;
			addChild(navPanelFriends);
			
			navPanelRooms = new NavPanelRooms(maxWidth, maxHeight);
			navPanelRooms.visible = false;
			addChild(navPanelRooms);
			
			navPanelSettings = new NavPanelSettings(maxWidth, maxHeight);
			navPanelSettings.visible = false;
			addChild(navPanelSettings);
			
			navPanelEula = new NavPanelEula(maxWidth, maxHeight);
			navPanelEula.visible = false;
			addChild(navPanelEula);
			
			navPanelHelp = new NavPanelHelp(maxWidth, maxHeight);
			navPanelEula.visible = false;
			addChild(navPanelHelp);
			
			navPanelLoginSignup = new NavPanelLoginSignup(maxWidth, maxHeight);
			navPanelLoginSignup.visible = false;
			addChild(navPanelLoginSignup);
			
			//Initial Resize
			//resize(maxWidth, maxHeight);
		}
		
		private function onTurnOnNavPanel(e:TurnOnNavPanel):void{
			//trace("NavPanelAll.onTurnOnNavPanel()");
			
		}
		
		private function onExerciseAlarm(e:PEvent):void{
			trace("NavPanelAll.as onExerciseAlarm() heard the event");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Exercise"));
		}
		
		//Resize
		public function resize(maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelAll -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;

		}
		
		
		
		


	}
	
}