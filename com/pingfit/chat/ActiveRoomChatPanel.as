package com.pingfit.chat {
	
	
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.display.Stage;
	import flash.text.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import com.pingfit.xml.*;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.text.TextField;
	import flash.errors.IOError;
	import flash.system.Security;
	import flash.net.*;
	import fl.controls.TextInput;
	import fl.controls.Button;
	import com.pingfit.format.TextUtil;
	import flash.text.*;
	import com.pingfit.controls.ScrollMenu;
	import com.pingfit.controls.ScrollMenuItem;
	import flash.events.KeyboardEvent; 
	import flash.ui.Keyboard;
	import com.pingfit.scroller.Scroller;
	import com.pingfit.chat.ChatBubble;
	import com.pingfit.data.objects.Room;
	import com.pingfit.data.objects.User;
	import com.pingfit.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.data.static.*;
	
	
	public class ActiveRoomChatPanel extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		
		private var _so = null;
		private var chatText:String = "";
		private var sayInput:TextInput;
		private var chatTextFormat:TextFormat;
		private var chatAreaWidth:Number;
		private var chatAreaHeight:Number;
		private var sayButton:Button;
		private var room:Room;
		private var chatScrollTwo:Scroller;
		private var peopleInRoom:Scroller;
		
		public function ActiveRoomChatPanel(maxWidth:Number, maxHeight:Number, room:Room){
			//trace("ActiveRoomChatPanel instanciated . roomurl="+roomurl+" roomname="+roomname);
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.room = room;
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		function initListener (e:Event):void {
			//trace("ActiveRoomChatPanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			//Listen
			Broadcaster.addEventListener(DoExercise.TYPE, onDoExercise);
			Broadcaster.addEventListener(SkipExercise.TYPE, onSkipExercise);
			Broadcaster.addEventListener(MessageToRoom.TYPE, onMessageToRoom);
			Broadcaster.addEventListener(PersonEntersRoom.TYPE, onPersonEntersRoom);
			Broadcaster.addEventListener(PersonLeavesRoom.TYPE, onPersonLeavesRoom);
			
			//Main chat text variable
			chatText = "";
			
			//Set formatting
			chatTextFormat = TextUtil.getHelveticaRounded(13, 0xE6E6E6, true);
			
			chatAreaWidth = maxWidth - 100;
			chatAreaHeight = maxHeight - 28;
			chatScrollTwo = new Scroller(chatAreaWidth, chatAreaHeight);
			chatScrollTwo.x = 0;
			chatScrollTwo.y = 0;
			chatScrollTwo.setAutoScrollToBottomAfterItemAdd(true);
			addChild(chatScrollTwo);
			
			sayInput = new TextInput();
			sayInput.text = "";
			sayInput.width = maxWidth - 225;
			sayInput.x = 5;
			sayInput.y = maxHeight - 25;
			addChild(sayInput);
			
			
			sayButton = new Button();
			sayButton.x = maxWidth - 210;
			sayButton.y = maxHeight - 25;
			sayButton.label = "Say";
			sayButton.width = 100;
			sayButton.addEventListener(MouseEvent.CLICK, sayButtonClicked);
			addChild(sayButton);

			
			
			peopleInRoom = new Scroller(100, maxHeight);
			peopleInRoom.x = maxWidth - 100;
			peopleInRoom.y = 0;
			peopleInRoom.setAutoScrollToBottomAfterItemAdd(false);
			addChild(peopleInRoom);
			addPersonToList(CurrentUser.getUser());
			

			
			//Get status of said friends
			NetConn.sendMeStatusOfAllFriends(null);
			
			//listen for return key
			this.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}
		
		
		

		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ActiveRoomChatPanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
		}
		
		
		//onDoExercise
		public function onDoExercise(e:DoExercise){
			trace("ActiveRoomChatPanel.onDoExercise() e.target="+e.target);
			sayToRoom("Did " + e.exercise.getName() + " x " + e.exercise.getReps()+"!", "exercisecompleted");
		}
		
		//onSkipExercise
		public function onSkipExercise(e:SkipExercise){
			trace("ActiveRoomChatPanel.onSkipExercise()");
			sayToRoom("Skipped " + e.exercise.getName() + " x " + e.exercise.getReps() +".", "exerciseskipped");
		}
		
		//onMessageToRoom
		public function onMessageToRoom(e:MessageToRoom){
			trace("ActiveRoomChatPanel.onMessageToRoom()");
			addMessageToScroller(e.msg, e.nickname, e.messagetype);
		}
		
		//onPersonEntersRoom
		public function onPersonEntersRoom(e:PersonEntersRoom){
			trace("ActiveRoomChatPanel.onPersonEntersRoom()");
			var user:User = new User();
			user.setNickname(e.nickname);
			user.setFacebookuid(e.facebookuid);
			user.setUserid(int(e.userid));
			addPersonToList(user);
			addMessageToScroller("Entered the room.", e.nickname, "enterroom");
			peopleInRoom.sort();
		}
		
		//onPersonLeavesRoom
		public function onPersonLeavesRoom(e:PersonLeavesRoom){
			trace("ActiveRoomChatPanel.onPersonLeavesRoom()");
			var user:User = new User();
			user.setFacebookuid(e.facebookuid);
			user.setUserid(int(e.userid));
			removePersonFromList(user);
			addMessageToScroller("Left the room.", e.nickname, "leaveroom");
			peopleInRoom.sort();
		}
		
		
		
		private function removedFromStage(e:Event) {
            trace("ActiveRoomChatPanel.removedFromStage()");
			NetConn.killConn();
        }
		
		
		
		private function keyHandler(e:KeyboardEvent){
			//trace("keyHandler() e.target="+e.target);
			if(e.keyCode==Keyboard.ENTER && (!(e.altKey || e.ctrlKey))){
				sayButtonClicked(null);
			}
		}
		
		private function sayButtonClicked(e:MouseEvent) {
            trace("sayButtonClicked");
			//_so.setProperty("chatText", chatText + "\n" + "<b>First Last:</b> " +sayInput.text);
			sayToRoom(sayInput.text, "");
        }
		
		public function sayToRoom(msg:String, type:String):void{
			if (msg!=null && msg.length>0){
				//var nr:Responder = new Responder(onCallDone, null);
				NetConn.sayToRoom(msg, type, null);
				sayInput.text = "";
			}
		}
		
		
		
		private function addMessageToScroller(msg:String, from:String, type:String){
			//trace("addMessageToScroller()");
			if (msg!=null && msg.length>0){
				var chatBubble:ChatBubble = new ChatBubble(chatAreaWidth-13, 0, from, msg, type);
				chatScrollTwo.addItem(chatBubble);
			}
		}
		
		
		
		
		private function addPersonToList(user:User){
			//trace("addPersonToList()");
			if (user!=null && user.getNickname()!=null && user.getNickname().length>0){
				var personInRoom:PersonInRoomListItem = new PersonInRoomListItem(88, 0, user);
				peopleInRoom.addItem(personInRoom);
			}
		}
		
		
		
		private function removePersonFromList(user:User){
			//trace("removePersonFromList() userid()="+userid);
			if (user!=null){
				var itemsInScroller:Array = peopleInRoom.getItemsInScroller();
				for(var i=0; i<itemsInScroller.length; i++) {
					var itemInScroller:Object = itemsInScroller[i];
					//trace("found an item in list");
				    if (itemInScroller is PersonInRoomListItem){
						//trace("itemInScroller instanceof PersonInRoomListItem");
						var pirli:PersonInRoomListItem = PersonInRoomListItem(itemInScroller);
						if (pirli.getUserid()==user.getUserid() || pirli.getFacebookuid()==user.getFacebookuid()){
							//trace("removing userid="+userid);
							peopleInRoom.removeItem(DisplayObject(itemInScroller));
						}
					} else {
						//trace("itemInScroller not instanceof PersonInRoomListItem");
					}
			   }
			}
		}

		
		
	}
	
}