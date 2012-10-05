package com.pingfit.notifications {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.events.*;
	import com.pingfit.events.remote.*;
	import com.pingfit.xml.*;
	import fl.controls.Button;
	import com.pingfit.controls.PlainButton;
	import com.pingfit.data.static.Friends;
	import com.pingfit.data.static.CurrentUser;
	
	public class NotificationFriendRequest extends MovieClip {
		
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var square:MovieClip;
		private var description:TextField;
		private var user:User;
		private var buttonConfirm:PlainButton;
		private var buttonIgnore:PlainButton;

		

		public function NotificationFriendRequest(maxWidth:Number, maxHeight:Number, user:User) { 
			trace("NotificationFriendRequest instanciated -- maxWidth="+maxWidth+" maxHeight="+maxHeight+" this.height="+this.height);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.user = user;

			square = new MovieClip();
			addChild(square);
			
			description = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), maxWidth - 40, user.getNickname() + " wants to be your friend.");	
			addChild(description);
			
			buttonConfirm = new PlainButton(90, 25, "Confirm");
			buttonConfirm.addEventListener(MouseEvent.CLICK, buttonConfirmClick);
			addChild(buttonConfirm);
	
			buttonIgnore = new PlainButton(90, 25, "Ignore");
			buttonIgnore.addEventListener(MouseEvent.CLICK, buttonIgnoreClick);
			addChild(buttonIgnore);
		
			resize(maxWidth, maxHeight);
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NotificationFriendRequest -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight+" this.height="+this.height);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			description.x = 5;
			description.y = 5;
			description.width = maxWidth - 10;
			
			
			buttonConfirm.x = maxWidth - 200 - 10;
			buttonConfirm.y = description.y + description.textHeight + 10;
		
			buttonIgnore.x = maxWidth - 100 - 10;
			buttonIgnore.y = description.y + description.textHeight + 10;
		
			
			var squareHeight:Number = description.y + description.textHeight + 10 + 25 + 7;
			if (squareHeight<maxHeight){
				squareHeight = maxHeight;
			}
			if (squareHeight<20){
				squareHeight = 20;
			}
			
			square.graphics.clear();
			square.graphics.beginFill(0xFFFFFF);
			square.graphics.drawRoundRect(0,0, maxWidth, squareHeight, 10);
			square.graphics.endFill();
			square.x = 0;
			square.alpha = .10;
		}
		
		
		private function buttonConfirmClick(e:MouseEvent):void {   
				addFriend();
        }
		public function addFriend():void{
			trace("NotificationFriendRequest.addFriend()");
			var apiCaller:CallAddFriend = new CallAddFriend(user.getUserid());
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onAddFriendSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onAddFriendFail);
		}
		private function onAddFriendSuccess(e:ApiCallSuccess):void{
			trace("onAddFriendSuccess()");
			var remoteEvent:FriendAccepted = new FriendAccepted();
			remoteEvent.setArgsLocal(CurrentUser.getUser().getUserid(), CurrentUser.getUser().getNickname());
			RemoteBroadcaster.dispatchEventToUser(user.getUserid(), remoteEvent);
			dispatchEvent(new RemoveMeFromScroller(this));
			Friends.refreshViaAPI();
		}
		private function onAddFriendFail(e:ApiCallFail):void{
			trace("onAddFriendFail() - e.error="+e.error);
		}
		
		
		
		private function buttonIgnoreClick(e:MouseEvent):void {   
			breakFriendship();
        }
		public function breakFriendship():void{
			trace("NotificationFriendRequest.breakFriendship()");
			var apiCaller:CallBreakFriendship = new CallBreakFriendship(user.getUserid());
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onBreakFriendshipSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onBreakFriendshipFail);
		}
		private function onBreakFriendshipSuccess(e:ApiCallSuccess):void{
			trace("onBreakFriendshipSuccess()");
			dispatchEvent(new RemoveMeFromScroller(this));
			Friends.refreshViaAPI();
		}
		private function onBreakFriendshipFail(e:ApiCallFail):void{
			trace("onBreakFriendshipFail() - e.error="+e.error);
		}
		
	

	}
	
}