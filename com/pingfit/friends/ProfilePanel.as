package com.pingfit.friends
{
	
	import com.pingfit.data.objects.User;
	import com.pingfit.events.remote.NewFriendRequest;
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.text.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import com.pingfit.xml.*;
	import noponies.events.NpTextScrollBarEvent;
	import noponies.ui.NpTextScroller;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import com.pingfit.controls.DoneButton;
	import com.pingfit.controls.SkipIt;
	import com.pingfit.data.objects.Exercise;
	import com.pingfit.data.static.*;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.DoExercise;
	import com.pingfit.events.SkipExercise;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.events.TurnOnNavPanel;
	import com.pingfit.events.remote.*;
	import com.pingfit.controls.PlainButton;
	import com.pingfit.data.static.Friends;
	import com.pingfit.data.static.FriendsFacebook;
	import com.pingfit.data.static.FriendsCombined;
	import com.facebook.data.users.*;
	import com.pingfit.exercisepanel.*;
	import com.pingfit.facebook.*;
	import com.pingfit.roomspanel.RoomInList;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	

	public class ProfilePanel extends MovieClip {
	
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var panelTitle:TextField;
		private var user:User;
		private var buttonAddFriend:PlainButton;
		private var buttonBreakFriendship:PlainButton;
		private var roomInList:RoomInList;
		private var status:TextField;
		private var summaryAppStatus:TextField;
		private var facebookInvitesComingSoon:TextField;
		private var buttonGoFacebook:PlainButton;
		private var facebookUser:FacebookUser;
		private var img;
		private var exImgLoader:Loader;
		
		public function ProfilePanel(maxWidth:Number, maxHeight:Number, user:User){
			//trace("ProfilePanel instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.user = FriendsCombined.getUser(user.getUserid(), user.getFacebookuid());
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		
		
		function initListener (e:Event):void {
			//trace("ProfilePanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			
			
			
			//See if there's a facebookuser
			facebookUser = FriendsFacebook.getFacebookUserFromUserObject(user);
			if (facebookUser != null) {
				user.setProfileimageurl(facebookUser.pic_big);
				trace("ProfilePanel - facebookUser not null... facebookUser.pic_big="+facebookUser.pic_big);
			} else {
				trace("ProfilePanel - facebookUser is null");
			}
			
			//See if there's a pic to load
			trace("ProfilePanel - user.getProfileimageurl()="+user.getProfileimageurl());
			if (user.getProfileimageurl()!=null && user.getProfileimageurl().length>0) {
				loadImg(user.getProfileimageurl());
			}
			
			panelTitle = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, user.getNickname());
			panelTitle.filters = Shadow.getDropShadowFilterArray(0x000000);
			panelTitle.x = 30;
			panelTitle.y = 20;
			addChild(panelTitle);
			
			//Debug/test
			var pingbacksDebug:String = "";
			//if (user.getPingbacks()!=null && user.getPingbacks()[0]!=null) {
			//	pingbacksDebug = pingbacksDebug + " user.getPingbacks()!=null length="+user.getPingbacks().length;
			//	pingbacksDebug = pingbacksDebug + " date[0]=" + user.getPingbacks()[0].date;
			//} else {
			//	pingbacksDebug = pingbacksDebug + " it's null";
			//}
			
			var summaryStatusTxt:String = "";
			if (user.getUserid()>0) {
				summaryStatusTxt = "Uses this application.";
			} else {
				summaryStatusTxt = "Not a user... yet!  Invite them!";
			}
			
			if (user.getIsonline()) {
				summaryStatusTxt = summaryStatusTxt + " Is online now in room: " + user.getRoom().getName();
			}
			
			summaryAppStatus = TextUtil.getTextField(TextUtil.getHelveticaRounded(11, 0xE6E6E6, true), maxWidth-100, summaryStatusTxt);
			summaryAppStatus.filters = Shadow.getDropShadowFilterArray(0x000000);
			summaryAppStatus.x = 30;
			summaryAppStatus.y = 75;
			addChild(summaryAppStatus);
			
			if (user.getIsonline()) {
				trace("ProfilePanel - user "+user.getNickname()+" is online");
				if (user.getRoom()!=null && user.getRoom().getRoomid()>0){
					roomInList = new RoomInList(200, 0, user.getRoom());
					roomInList.x = 30;
					roomInList.y = 100;
					addChild(roomInList);
				} else {
					if (user.getRoom() == null) { trace("ProfilePanel - user.getRoom()==null"); }
					if (user.getRoom()!=null){ trace("ProfilePanel - user.getRoom().getName()="+user.getRoom().getName()+" user.getRoom().getRoomid()="+user.getRoom().getRoomid()); }
				}
			} else {
				trace("ProfilePanel - user "+user.getNickname()+" is offline");
				if (user.getUserid()>0) {
					//They're a user, just wait for 'em to get online
				} else {
					//Facebook Friend, Not a pingFit user, invite them
					//facebookInvitesComingSoon = TextUtil.getTextField(TextUtil.getHelveticaRounded(11, 0xE6E6E6, true), 300, "Facebook is rebuilding their invitation architecture.  We'll plug into it soon.  In the meantime you can visit the pingFit Facebook App and invite your friends.");
					//facebookInvitesComingSoon.filters = Shadow.getDropShadowFilterArray(0x000000);
					//facebookInvitesComingSoon.x = 30;
					//facebookInvitesComingSoon.y = 150;
					//addChild(facebookInvitesComingSoon);
					//Button
					buttonGoFacebook = new PlainButton(200, 25, "Invite via Facebook");
					buttonGoFacebook.addEventListener(MouseEvent.CLICK, buttonGoFacebookClick);
					buttonGoFacebook.x = 30;
					buttonGoFacebook.y = 250;
					addChild(buttonGoFacebook);
				}
			}
			
			status = TextUtil.getTextField(TextUtil.getHelveticaRounded(15, 0xE6E6E6, true), 300, "");
			status.filters = Shadow.getDropShadowFilterArray(0x000000);
			status.x = 30;
			status.y = maxHeight - 25;
			addChild(status);
			
			
			if (user.getUserid()!=CurrentUser.getUser().getUserid()){
				if (Friends.isFriend(user.getUserid())) {
					if (user.getFacebookuid()==""){
						buttonBreakFriendship = new PlainButton(120, 25, "Break Friendship");
						buttonBreakFriendship.addEventListener(MouseEvent.CLICK, buttonBreakFriendshipClick);
						buttonBreakFriendship.x = 30;
						buttonBreakFriendship.y = 175;
						addChild(buttonBreakFriendship);
					}
				} else {
					buttonAddFriend = new PlainButton(120, 25, "Add as Friend");
					buttonAddFriend.addEventListener(MouseEvent.CLICK, buttonAddFriendClick);
					buttonAddFriend.x = 30;
					buttonAddFriend.y = 175;
					addChild(buttonAddFriend);
				}
			}
			
			resize(maxWidth, maxHeight);
		}


		
		

		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ProfilePanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;

		}
		
		private function loadImg(imageUrl:String):void {
			trace("ProfilePanel - loadImg() called");
			try{
				var urlRequest:URLRequest = new URLRequest(imageUrl);
				exImgLoader = new Loader();
				exImgLoader.contentLoaderInfo.addEventListener(Event.INIT, imageInitted);
				exImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageIoError);
				exImgLoader.load(urlRequest);
			} catch (error:Error) { trace("Error catch: " + error); }
		}
		
		private function imageInitted(e:Event):void{
			img = exImgLoader.content;

			if (img is AVM1Movie){
				//trace("is AVM1Movie");
				img = exImgLoader;
			} else {
				//trace("not AVM1Movie");
				img = exImgLoader.content;
			}
			img = ExercisePanel.resizeAndKeepAspect(img, 200, 400);
			
			
			addChild(img);
			img.x = maxWidth-225;
			img.y = 100;
			img.alpha = 0.0;
			img.filters = Shadow.getDropShadowFilterArray(0x000000); 
			TweenLite.to(img, 4, {alpha:1});
		}
		
		private function imageIoError(e:Event):void{
			trace("imageIoError happened:"+e);
		}
		
		
		
		private function buttonAddFriendClick(e:MouseEvent):void {   
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
			Friends.refreshViaAPI();
			buttonAddFriend.visible = false;
			var remoteEvent:NewFriendRequest = new NewFriendRequest();
			remoteEvent.setArgsLocal(CurrentUser.getUser().getUserid(), CurrentUser.getUser().getNickname());
			RemoteBroadcaster.dispatchEventToUser(user.getUserid(), remoteEvent);
			status.text = "A friend request has been sent.";
		}
		private function onAddFriendFail(e:ApiCallFail):void{
			trace("onAddFriendFail() - e.error="+e.error);
		}
		
		
		
		private function buttonBreakFriendshipClick(e:MouseEvent):void {   
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
			Friends.refreshViaAPI();
			buttonBreakFriendship.visible = false;
			status.text = "The friendship is dissolved.";
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Friends"));
		}
		private function onBreakFriendshipFail(e:ApiCallFail):void{
			trace("onBreakFriendshipFail() - e.error="+e.error);
		}
		
		
		
		
		private function buttonGoToRoomClick(e:MouseEvent):void {   
			trace("ProfilePanel.buttonGoToRoomClick()");
        }
		
		private function buttonGoFacebookClick(e:MouseEvent):void {   
			trace("ProfilePanel.buttonGoFacebookClick()");
			try {
				var request:URLRequest = new URLRequest("http://www.facebook.com/apps/application.php?id=160194959586");
                navigateToURL(request, "_blank");
            } catch (e:Error) {
                trace(e);
            }
        }
		
	}

	
	
}