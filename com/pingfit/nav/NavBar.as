package com.pingfit.nav {
	
	
	import com.pingfit.controls.NotificationsButton;
	import flash.display.MovieClip;
	import com.pingfit.controls.Background;
	import com.pingfit.controls.MinimizeButton;
	import com.pingfit.controls.SettingsButton;
	import com.pingfit.controls.HelpButton;
	import com.pingfit.events.*;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.text.*;
	import flash.events.MouseEvent;
	import flash.events.Event;

	
	
	public class NavBar extends MovieClip {
		
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var exerciseButton:NavButton;
		private var roomsButton:NavButton;
		private var exerciseListsButton:NavButton;
		private var friendsButton:NavButton;
		private var notificationsButton:NotificationsButton;
		private var minimizeButton:MinimizeButton;
		private var settingsButton:SettingsButton;
		private var helpButton:HelpButton;
		private var topRightButtonsText:TextField;
		
		
		public function NavBar(maxWidth:Number, maxHeight:Number){
			//trace("NavBar instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		function initListener(e:Event):void {
			//trace("NavBar.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			//Listen
			Broadcaster.addEventListener(PEvent.TURNONNAVBAR, onTurnOnNavBar);
			Broadcaster.addEventListener(PEvent.TURNOFFNAVBAR, onTurnOffNavBar);
			Broadcaster.addEventListener(PEvent.TOGGLENAVBAR, onToggleNavBar);
			
			exerciseButton = new NavButton(100, 32, "Exercise", "Exercise");
			exerciseButton.x = 250;
			exerciseButton.y = 2;
			exerciseButton.addEventListener(MouseEvent.CLICK, onExerciseButtonClicked);
			addChild(exerciseButton);
			
			roomsButton = new NavButton(100, 32, "Rooms", "Rooms");
			roomsButton.x = 350;
			roomsButton.y = 2;
			roomsButton.addEventListener(MouseEvent.CLICK, onRoomsButtonClicked);
			addChild(roomsButton);
			
			exerciseListsButton = new NavButton(100, 32, "ExerciseLists", "Exercises & Lists");
			exerciseListsButton.x = 450;
			exerciseListsButton.y = 2;
			exerciseListsButton.addEventListener(MouseEvent.CLICK, onExerciseListsButtonClicked);
			addChild(exerciseListsButton);
			
			friendsButton = new NavButton(100, 32, "Friends", "Friends");
			friendsButton.x = 550;
			friendsButton.y = 2;
			friendsButton.addEventListener(MouseEvent.CLICK, onFriendsButtonClicked);
			addChild(friendsButton);
			
			notificationsButton = new NotificationsButton();
			notificationsButton.addEventListener(MouseEvent.CLICK, onClickNotifications);
			notificationsButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverNotifications);
			notificationsButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutNotifications);
			notificationsButton.x = stage.stageWidth - 43 - 32 - 32 - 32;
			notificationsButton.y = 2;
			notificationsButton.alpha = 1;
			addChild(notificationsButton);
			
			settingsButton = new SettingsButton();
			settingsButton.addEventListener(MouseEvent.CLICK, onClickSettings);
			settingsButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverSettings);
			settingsButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutSettings);
			settingsButton.x = stage.stageWidth - 43 - 32 - 32;
			settingsButton.y = 2;
			settingsButton.alpha = 1;
			addChild(settingsButton);
			
			helpButton = new HelpButton();
			helpButton.addEventListener(MouseEvent.CLICK, onClickHelp);
			helpButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHelp);
			helpButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHelp);
			helpButton.x = stage.stageWidth - 43 - 32;
			helpButton.y = 2;
			helpButton.alpha = 1;
			addChild(helpButton);
			
			minimizeButton = new MinimizeButton();
			minimizeButton.addEventListener(MouseEvent.CLICK, onClickMinimize);
			minimizeButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverMinimize);
			minimizeButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutMinimize);
			minimizeButton.x = stage.stageWidth - 43;
			minimizeButton.y = 2;
			minimizeButton.alpha = 1;
			addChild(minimizeButton);
			
			var topFormat = TextUtil.getHelveticaRounded(16, 0xFFFFFF, true);
			topFormat.align = "right";
			var topRightButtonsTextWidth:Number = stage.stageWidth - (notificationsButton.x - 30);
			topRightButtonsText = TextUtil.getTextField(topFormat, topRightButtonsTextWidth, "");
			topRightButtonsText.filters = Shadow.getDropShadowFilterArray(0x000000);
			topRightButtonsText.x = notificationsButton.x - 30 - 11;
			topRightButtonsText.y = 34;
			addChild(topRightButtonsText);
			
			
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		
		
		//Resize
		public function resize(maxWidth:Number, maxHeight:Number):void {
			//trace("NavBar -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
		}
		
		function onExerciseButtonClicked(e:MouseEvent):void {
			//trace("NavBar.onExerciseButtonClicked()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Exercise"));
		}
		
		function onRoomsButtonClicked(e:MouseEvent):void {
			//trace("NavBar.onRoomsButtonClicked()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Rooms"));
		}
		
		function onExerciseListsButtonClicked(e:MouseEvent):void {
			//trace("NavBar.onExerciseListsButtonClicked()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("ExerciseLists"));
		}
		
		function onFriendsButtonClicked(e:MouseEvent):void {
			//trace("NavBar.onFriendsButtonClicked()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Friends"));
		}
		
		function onClickNotifications(e:MouseEvent):void {
			//trace ("NavBar.onClickNotifications()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Notifications"));
		}
		
		function onClickSettings(e:MouseEvent):void {
			//trace ("NavBar.onClickSettings()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Settings"));
		}
		
		function onClickHelp(e:MouseEvent):void {
			//trace ("NavBar.onClickHelp()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Help"));
		}
		
		function onClickMinimize(e:MouseEvent):void {
			//trace ("NavBar.onClickMinimize()");
			Broadcaster.dispatchEvent(new PEvent(PEvent.DOCKAPP));
		}
		
		
		
		//Top Right Buttons
		function onMouseOverNotifications(e:MouseEvent):void {
			topRightButtonsText.htmlText = "Notifications";
		}
		function onMouseOutNotifications(e:MouseEvent):void {
			topRightButtonsText.htmlText = "";
		}
		function onMouseOverSettings(e:MouseEvent):void {
			topRightButtonsText.htmlText = "Settings";
		}
		function onMouseOutSettings(e:MouseEvent):void {
			topRightButtonsText.htmlText = "";
		}
		function onMouseOverHelp(e:MouseEvent):void {
			topRightButtonsText.htmlText = "Help/Feedback";
		}
		function onMouseOutHelp(e:MouseEvent):void {
			topRightButtonsText.htmlText = "";
		}
		function onMouseOverMinimize(e:MouseEvent):void {
			topRightButtonsText.htmlText = "Hide to Tray";
		}
		function onMouseOutMinimize(e:MouseEvent):void {
			topRightButtonsText.htmlText = "";
		}
		
		

		
		//Turn On/Off
		private function onTurnOnNavBar(e:PEvent):void{
			//trace("NavBar.onTurnOnNavBar()");
			this.visible = true;
		}
		private function onTurnOffNavBar(e:PEvent):void{
			//trace("NavBar.onTurnOffNavBar()");
			this.visible = false;
		}
		private function onToggleNavBar(e:PEvent):void{
			//trace("NavBar.onToggleNavBar()");
			if (this.visible){
				this.visible = false;
			} else {
				this.visible = true;
			}
		}
		
		
		
		
		


	}
	
}