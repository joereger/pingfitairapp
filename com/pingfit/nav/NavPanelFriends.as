package com.pingfit.nav {
	

	import com.pingfit.chat.FriendInList;
	import com.pingfit.friends.InvitePanel;
	import com.pingfit.friends.ProfilePanel;
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.text.*;
	import flash.events.*;
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import com.pingfit.xml.*;
	import flash.display.*;
	import flash.display.SimpleButton;
	import fl.controls.Slider;
	import fl.controls.SliderDirection;
	import fl.controls.ComboBox;
	import fl.controls.CheckBox;
	import fl.events.SliderEvent;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.controls.*;
	import com.pingfit.data.static.*;
	import fl.controls.TextInput;
	import fl.controls.Button;
	import com.pingfit.data.static.ExerciseLists;
	import com.pingfit.data.static.BigRefresh;
	import com.pingfit.data.static.Friends;
	import com.pingfit.data.static.FriendsCombined;
	import com.pingfit.data.static.FriendsFacebook;
	import com.pingfit.data.objects.ExerciseList;
	import com.pingfit.data.objects.User;
	import com.pingfit.events.*;
	import com.pingfit.scroller.*;
	import com.pingfit.chat.FriendInList;
	import com.pingfit.friends.*;
	import com.pingfit.controls.InviteFriendsButton;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class NavPanelFriends extends NavPanelBase {
		
		private var bg:MovieClip;
		
		private var friendsTitle:TextField;
		private var inviteFriendsButton:InviteFriendsButton;
		private var friendsScroller:Scroller;
		private var invitePanel:InvitePanel;
		private var profilePanel:ProfilePanel;
		private var usersToAddToScroller:Array;
		private var userAdderTimerEveryXSeconds:int = 1;
		private var userAdderTimerAddEachCycle:int = 50;
		private var userAdderTimer:Timer = new Timer(userAdderTimerEveryXSeconds*1000);
		

		
		public function NavPanelFriends(maxWidth:Number, maxHeight:Number, navPanelType:String="Friends", navPanelName:String="Friends"){
			trace("NavPanelFriends instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
			
		}
		
		public override function initListener (e:Event):void {
			trace("NavPanelFriends.initListener() called");
			super.initListener(e);
			
			//Listen
			Broadcaster.addEventListener(PEvent.FRIENDSREFRESHED, onFriendsRefreshed);
			Broadcaster.addEventListener(DisplayUserProfile.TYPE, onDisplayUserProfile);
			Broadcaster.addEventListener(PEvent.STARTINVITEFRIEND, onStartInviteFriend);
			Broadcaster.addEventListener(PEvent.DONEGETTINGALLFRIENDSSTATUSFROMRED5, onDoneGettingAllFriendsStatusFromRed5);
			Broadcaster.addEventListener(PresenceChange.TYPE, onPresenceChange);
			
			bg = new MovieClip();
			addChild(bg);
			
			
			friendsTitle = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "Friends");
			friendsTitle.filters = Shadow.getDropShadowFilterArray(0x000000);
			friendsTitle.x = 30;
			friendsTitle.y = 20;
			addChild(friendsTitle);
			
			inviteFriendsButton = new InviteFriendsButton();
			inviteFriendsButton.x = 30;
			inviteFriendsButton.y = maxHeight - 75;
			inviteFriendsButton.addEventListener(MouseEvent.CLICK, buttonInviteFriendClick);
			addChild(inviteFriendsButton);
			
			userAdderTimer.addEventListener(TimerEvent.TIMER, onUserAdderTick);


			//Load friends
			refreshFriendsScroller();
			
			//Get status of said friends
			NetConn.sendMeStatusOfAllFriends(null);
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelFriends -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRoundRect(0,0, 220, maxHeight-85, 30);
			bg.graphics.endFill();
			bg.alpha = .15;
			bg.x = 20;
			bg.y = 65;
		}

		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void {   }
		
		
		
		public function onStartInviteFriend(e:PEvent){
			trace("NavPanelFriends.onStartInviteFriend()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Friends"));
			showInvitePanel();
		}
		
		public function onFriendsRefreshed(e:PEvent){
			trace("NavPanelFriends.onFriendsRefreshed()");
			refreshFriendsScroller();
			if (friendsScroller != null) {
				friendsScroller.sort();
			}
			//NetConn.sendMeStatusOfAllFriends(null);
		}
		
		private function onPresenceChange(e:PresenceChange):void {
			trace("NavPanelFriends.onPresenceChange()");
			if (friendsScroller != null) {
				friendsScroller.sort();
			}
		}
		
		private function onDoneGettingAllFriendsStatusFromRed5(e:PEvent):void {
			trace("NavPanelFriends.onDoneGettingAllFriendsStatusFromRed5()");
			if (friendsScroller != null) {
				friendsScroller.sort();
			}
		}
		
		//Go get user
		private function onDisplayUserProfile(e:DisplayUserProfile):void {
			trace("NavPanelFriends.onDisplayUserProfile()");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Friends"));
			if (e.user!=null && e.user.getUserid()>0){
				getUserViaApi(e.user);
			} else {
				//It's a facebook user, no userid or server-side account, go directly to the user profile
				showProfile(e.user);
			}
		}
		private function getUserViaApi(user:User):void{
			trace("NavPanelFriends.getUserViaApi()");
			var apiCaller:CallGetUser = new CallGetUser(user.getUserid());
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onGetUserSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onGetUserFail);
		}
		private function onGetUserSuccess(e:ApiCallSuccess):void{
			trace("NavPanelFriends.onGetUserSuccess()");
			var user:User = new User();
			user.load(e.xmlData.user[0]);
			showProfile(user);
		}
		private function onGetUserFail(e:ApiCallFail):void{
			trace("NavPanelFriends.onGetUserFail() - e.error="+e.error);
		}
		
		
		
		
		
		
		
		private function showProfile(user:User) {
			trace("NavPanelFriends.showProfile()");
			if (invitePanel != null && invitePanel.visible) { invitePanel.visible = false; }
			if (profilePanel != null) { removeChild(profilePanel); profilePanel = null; }
			inviteFriendsButton.visible = true;
			profilePanel = new ProfilePanel(maxWidth-250, maxHeight, user);
			profilePanel.x = 250;
			profilePanel.y = 0;
			addChild(profilePanel);
		}
		
		private function showInvitePanel() {
			if (profilePanel != null && profilePanel.visible) { profilePanel.visible = false; }
			if (invitePanel != null) { removeChild(invitePanel); invitePanel = null; }
			inviteFriendsButton.visible = false;
			invitePanel = new InvitePanel(maxWidth-250, maxHeight);
			invitePanel.x = 250;
			invitePanel.y = 0;
			addChild(invitePanel);
		}
		
		private function removeProfileAndInvite() {
			if (profilePanel != null) { removeChild(profilePanel); profilePanel = null; }
			if (invitePanel != null) { removeChild(invitePanel); invitePanel = null; }
			inviteFriendsButton.visible = true;
		}
		
		
		private function refreshFriendsScroller():void {
			userAdderTimer.stop();
			usersToAddToScroller = new Array();
			var friends:Array = FriendsCombined.getUsers();
			if (friendsScroller!=null){removeChild(friendsScroller); friendsScroller=null;}
			friendsScroller = new Scroller(200, maxHeight - 100 - 75);
			friendsScroller.x = 30;
			friendsScroller.y = 75;
			friendsScroller.setAutoScrollToBottomAfterItemAdd(false);
			addChild(friendsScroller);
			for each (var user:User in friends) {
				//addFriendToScroller(user);
				usersToAddToScroller.push(user);
			}
			userAdderTimer.start();
		}
		
		private function onUserAdderTick(e:TimerEvent):void{
			trace("ChatPanel.onUserAdderTick()");
			//Add some users
			for (var i:Number = 0; i < userAdderTimerAddEachCycle; i++){
				if (usersToAddToScroller!=null && usersToAddToScroller.length>0) {
					addFriendToScroller(User(usersToAddToScroller.shift()));
				}
			}
			//If this is the end of the stack
			if (usersToAddToScroller != null && usersToAddToScroller.length <= 0) {
				trace("ChatPanel.onUserAdderTick() done adding users");
				userAdderTimer.stop();
				NetConn.sendMeStatusOfAllFriends(null);
				if (friendsScroller != null) {
					friendsScroller.sort();
				}
			}
		}
		
		private function buttonInviteFriendClick(e:MouseEvent):void {
            trace("NavPanelFriends.buttonInviteFriendClick()");
			Broadcaster.dispatchEvent(new PEvent(PEvent.STARTINVITEFRIEND));
        }
		
		
		private function addFriendToScroller(user:User){
			//trace("addFriendToScroller()");
			var friendInList:FriendInList = new FriendInList(200 - 13, 0, user);
			friendsScroller.addItem(friendInList);
		}
	
		
		private function removeFriendFromScroller(userid:int){
			//trace("removeFriendFromScroller() userid()="+userid);
			if (userid>0){
				var itemsInScroller:Array = friendsScroller.getItemsInScroller();
				for(var i=0; i<itemsInScroller.length; i++) {
					var itemInScroller:Object = itemsInScroller[i];
					//trace("found an item in list");
				    if (itemInScroller is FriendInList){
						//trace("itemInScroller instanceof PersonInRoomListItem");
						var pirli:FriendInList = FriendInList(itemInScroller);
						if (pirli.getUser().getUserid()==userid){
							//trace("removing userid="+userid);
							friendsScroller.removeItem(DisplayObject(itemInScroller));
						}
					} else {
						//trace("itemInScroller not instanceof PersonInRoomListItem");
					}
			   }
			}
		}
		
		
		
		


	}
	
}