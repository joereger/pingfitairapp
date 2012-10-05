package com.pingfit.chat {
	
	
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.text.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.net.*;
	import com.pingfit.xml.*;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import com.pingfit.data.objects.Room;
	import com.pingfit.data.static.NetConn;
	import com.pingfit.data.static.CurrentUser;
	import com.pingfit.data.static.CurrentRoom;
	import com.pingfit.data.static.Friends;
	import com.pingfit.data.static.FriendsCombined;
	import com.pingfit.data.static.FriendsFacebook;
	import com.pingfit.events.EnterRoom;
	import com.pingfit.events.LeaveRoom;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.roomspanel.ChangeRoomsButton;
	import com.pingfit.roomspanel.ExerciseAloneButton;
	import com.pingfit.scroller.Scroller;
	import com.pingfit.data.objects.User;
	import com.pingfit.controls.InviteFriendsButton;
	import com.pingfit.events.PresenceChange;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	
	public class ChatPanel extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var bg:MovieClip;
		private var activeRoomChatPanel:ActiveRoomChatPanel;
		private var roomsLabel:TextField;
		private var currentRoomLabel:TextField;
		private var changeRoomsButton:ChangeRoomsButton;
		private var exerciseAloneButton:ExerciseAloneButton;
		private var friendsScroller:Scroller;
		private var inviteFriendsButton:InviteFriendsButton;
		private var usersToAddToScroller:Array;
		private var userAdderTimerEveryXSeconds:int = 1;
		private var userAdderTimerAddEachCycle:int = 25;
		private var userAdderTimer:Timer = new Timer(userAdderTimerEveryXSeconds*1000);
		
		public function ChatPanel(maxWidth:Number, maxHeight:Number){
			//trace("ChatPanel instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
			//addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		function initListener (e:Event):void {
			//trace("ChatPanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			//Listeners
			Broadcaster.addEventListener(EnterRoom.TYPE, onEnterRoom);
			Broadcaster.addEventListener(LeaveRoom.TYPE, onLeaveRoom);
			Broadcaster.addEventListener(PEvent.FRIENDSREFRESHED, onFriendsRefreshed);
			Broadcaster.addEventListener(PEvent.DONEGETTINGALLFRIENDSSTATUSFROMRED5, onDoneGettingAllFriendsStatusFromRed5);
			Broadcaster.addEventListener(PresenceChange.TYPE, onPresenceChange);
			
			bg = new MovieClip();
			addChild(bg);
			
		
			
			roomsLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(25, 0xE6E6E6, true), maxWidth-100, "Friends");
			roomsLabel.filters = Shadow.getDropShadowFilterArray(0x000000);
			roomsLabel.x = 10;
			roomsLabel.y = 23;
			roomsLabel.alpha = .5;
			addChild(roomsLabel);
			
			exerciseAloneButton = new ExerciseAloneButton(10,10);
			exerciseAloneButton.x = roomsLabel.x + roomsLabel.textWidth + 10;
			exerciseAloneButton.y = 28;
			exerciseAloneButton.buttonMode = true;
			addChild(exerciseAloneButton);
			
			
			currentRoomLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(25, 0xE6E6E6, true), maxWidth-100, "");
			currentRoomLabel.filters = Shadow.getDropShadowFilterArray(0x000000);
			currentRoomLabel.x = 210;
			currentRoomLabel.y = 23;
			currentRoomLabel.alpha = .5;
			addChild(currentRoomLabel);
			
			changeRoomsButton = new ChangeRoomsButton(10,10);
			changeRoomsButton.x = currentRoomLabel.x + currentRoomLabel.textWidth + 10;
			if (changeRoomsButton.x>(maxWidth-75)){
				changeRoomsButton.x = maxWidth-75;
			}
			changeRoomsButton.y = 28;
			changeRoomsButton.buttonMode = true;
			addChild(changeRoomsButton);
			
			inviteFriendsButton = new InviteFriendsButton();
			inviteFriendsButton.buttonMode = true;
			inviteFriendsButton.addEventListener(MouseEvent.CLICK, onClickInviteFriends);
			inviteFriendsButton.x = 12;
			inviteFriendsButton.y = maxHeight - 50;
			addChild(inviteFriendsButton);
		
			
			//Load initial room
			//var roomid:int = CurrentUser.getUser().getRoom().getRoomid();
			//var roomname:String = CurrentUser.getUser().getRoom().getName();
			//var roomurl:String = "room"+roomid;
			//trace("ChatPanel -- roomid="+roomid+" roomname="+roomname+" roomurl="+roomurl);
			//addActiveRoomChatPanel(CurrentUser.getUser().getRoom());
			
			userAdderTimer.addEventListener(TimerEvent.TIMER, onUserAdderTick);
			
			
			//Dispatch the enter room 
			Broadcaster.dispatchEvent(new EnterRoom(CurrentRoom.getCurrentRoom()));
			
			//Friends scroller
			//refreshFriendsListFromStatic();	
		
			
			
			
			//Resize
			resize(maxWidth, maxHeight);
		}
		
		
		//onEnterRoom
		public function onEnterRoom(e:EnterRoom){
			trace("ChatPanel.onEnterRoom()");
			var room:Room = e.room;
			addActiveRoomChatPanel( CurrentRoom.getCurrentRoom() );
			NetConn.setUrl("roomid"+room.getRoomid());
			NetConn.setRoom(room.getRoomid(), room.getName(), new Responder(onSetRoomDone));
			//Only need to refresh all friends if this is a first load... otherwise, not
			if (friendsScroller==null){
				refreshFriendsListFromStatic();	
			}
		}
		private function onSetRoomDone(rs:Object):void {
			trace("ChatPanel.onSetRoomDone()");
			NetConn.sendMeStatusOfAllFriends(null);
		}

		
		//onLeaveRoom
		public function onLeaveRoom(e:LeaveRoom){
			trace("ChatPanel.onLeaveRoom()");
			removeActiveRoomChatPanel();
		}
		
		//onClickInviteFriends
		public function onClickInviteFriends(e:MouseEvent){
			trace("ChatPanel.onClickInviteFriends()");
			Broadcaster.dispatchEvent(new PEvent(PEvent.STARTINVITEFRIEND));
		}
		
		//onFriendsRefreshed
		public function onFriendsRefreshed(e:PEvent) {
			trace("ChatPanel.onFriendsRefreshed()");
			refreshFriendsListFromStatic();
		}
		
		private function onPresenceChange(e:PresenceChange):void {
			trace("ChatPanel.onPresenceChange()");
			if (friendsScroller != null) {
				friendsScroller.sort();
			}
		}
		
		private function onDoneGettingAllFriendsStatusFromRed5(e:PEvent):void {
			trace("ChatPanel.onDoneGettingAllFriendsStatusFromRed5()");
			if (friendsScroller != null) {
				friendsScroller.sort();
			}
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ChatPanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRoundRect(0,0, maxWidth, maxHeight-50, 30);
			bg.graphics.endFill();
			bg.alpha = .15;
			bg.y = 50;
		}
		
		private function refreshFriendsListFromStatic():void {
			userAdderTimer.stop();
			var timeStart:Number = getTimer();
			trace("ChatPanel.refreshFriendsListFromStatic() time=" + timeStart);
			usersToAddToScroller = new Array();
			var friends:Array = FriendsCombined.getUsers();
			//trace("ChatPanel.refreshFriendsListFromStatic() done FriendsFacebook.getFacebookFriendsAsUsers() time="+(getTimer()-timeStart));
			if (friendsScroller!=null){ removeChild(friendsScroller); friendsScroller = null; }
			//Put onto screen
			friendsScroller = new Scroller(200, maxHeight-75-15);
			friendsScroller.x = 10;
			friendsScroller.y = 55;
			friendsScroller.setAutoScrollToBottomAfterItemAdd(false);
			addChild(friendsScroller);
			//var numberAdded:int = 0;
			//var totalmillis:Number = 0;
			for each (var user:User in friends) {
				//var addStart:Number = getTimer();
				//addFriendToScroller(user);
				usersToAddToScroller.push(user);
				//totalmillis = totalmillis + (getTimer()-addStart)
				//numberAdded = numberAdded + 1;
			}
			//if (numberAdded>0){ trace("ChatPanel.refreshFriendsListFromStatic() numberAdded="+numberAdded+" avgtimetoadd="+(totalmillis/numberAdded));}
			//trace("ChatPanel.refreshFriendsListFromStatic() done adding friends time="+(getTimer()-timeStart));
			//NetConn.sendMeStatusOfAllFriends(null);
			//trace("ChatPanel.refreshFriendsListFromStatic() done calling sendmestatusofallfriends time="+(getTimer()-timeStart));
			//if (friendsScroller != null) {
			//	friendsScroller.sort();
			//}
			//trace("ChatPanel.refreshFriendsListFromStatic() done sorting="+(getTimer()-timeStart));
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
		
		
		
		public function sayToRoom(txt:String, type:String):void{
			if (activeRoomChatPanel!=null){
				activeRoomChatPanel.sayToRoom(txt, type);
			}
		}
		
		public function addActiveRoomChatPanel(room:Room){
			removeActiveRoomChatPanel();
			activeRoomChatPanel = new ActiveRoomChatPanel(maxWidth - 200 - 10, maxHeight-50, room);
			activeRoomChatPanel.x = 200 + 10;
			activeRoomChatPanel.y = 50;
			addChild(activeRoomChatPanel);
			//Set room title in ui
			currentRoomLabel.text = "Room: "+room.getName();
			changeRoomsButton.x = currentRoomLabel.x + currentRoomLabel.textWidth + 10;
			if (changeRoomsButton.x>(maxWidth-75)){
				changeRoomsButton.x = maxWidth-75;
			}
		}
		
		public function removeActiveRoomChatPanel():void{
			if (activeRoomChatPanel!=null){
				//activeRoomChatPanel.killConn();
				removeChild(activeRoomChatPanel);
				activeRoomChatPanel = null;
			}
		}
		
		
		
		
		
		private function addFriendToScroller(friend:User){
			//trace("ChatPanel.addMessageToScroller() -- create FriendInList");
			var friendInList:FriendInList = new FriendInList(friendsScroller.width - 13, 0, friend);
			//trace("ChatPanel.addMessageToScroller() -- addItem");
			friendsScroller.addItem(friendInList);
		}
		
		private function removeFriendFromList(userid:int){
			//trace("removePersonFromList() userid()="+userid);
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