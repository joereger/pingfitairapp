package com.pingfit.nav {
	

	import com.pingfit.events.*;
	import com.pingfit.events.remote.*;
	import com.pingfit.notifications.*;
	import flash.events.Event;
	import flash.text.*;
	import flash.display.DisplayObject;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import com.pingfit.data.static.*;
	import com.pingfit.scroller.*;
	import com.pingfit.data.objects.*;
	
	
	public class NavPanelNotifications extends NavPanelBase {
		
		private var notificationsTitle:TextField;
		private var notificationsScroller:Scroller;
		
		public function NavPanelNotifications(maxWidth:Number, maxHeight:Number, navPanelType:String="Notifications", navPanelName:String="Notifications"){
			//trace("NavPanelNotifications instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		public override function initListener (e:Event):void {
			//trace("NavPanelNotifications.initListener() called");
			super.initListener(e);
			
			//Listen
			Broadcaster.addEventListener(PEvent.NOTIFICATIONSLOADED, onNotificationsLoaded);
			
			notificationsTitle = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "Notifications");
			notificationsTitle.filters = Shadow.getDropShadowFilterArray(0x000000);
			notificationsTitle.x = 30;
			notificationsTitle.y = 20;
			addChild(notificationsTitle);
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void {  
			trace("NavPanelNotifications.onSwitchFromHiddenToVisible()");
			Notifications.refreshViaAPI();
		}
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("NavPanelNotifications -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
		}
		
		private function onNotificationsLoaded(e:PEvent):void {
				refreshNotificationsScroller();
		}
		
		
		private function refreshNotificationsScroller():void{
			if (notificationsScroller!=null){removeChild(notificationsScroller); notificationsScroller=null;}
			
			notificationsScroller = new Scroller(maxWidth-50, maxHeight - 100);
			notificationsScroller.x = 25;
			notificationsScroller.y = 75;
			addChild(notificationsScroller);
			
			//Add friend requests
			for each (var possibleFriend:User in FriendRequests.getUsers()) {
				var notificationFriendRequest:NotificationFriendRequest = new NotificationFriendRequest(maxWidth-50-13, 45, possibleFriend);
				notificationFriendRequest.addEventListener(RemoveMeFromScroller.TYPE, onRemoveMeFromScroller);
				addNotificationToScroller(notificationFriendRequest);
			}
			
			//Add room permission requests
			for each (var possibleRoomEntrant:RoomPermissionRequest in RoomPermissionRequests.getRoomPermissionRequests()) {
				var notificationRoomPermissionRequest:NotificationRoomPermissionRequest = new NotificationRoomPermissionRequest(maxWidth-50-13, 45, possibleRoomEntrant);
				notificationRoomPermissionRequest.addEventListener(RemoveMeFromScroller.TYPE, onRemoveMeFromScroller);
				addNotificationToScroller(notificationRoomPermissionRequest);
			}
		}
		
		private function addNotificationToScroller(notification:Object){
			//trace("addNotificationToScroller()");
			notificationsScroller.addItem(DisplayObject(notification));
		}
		
		private function onRemoveMeFromScroller(e:RemoveMeFromScroller):void {
			removeNotificationFromScroller(e.objectToRemove);
		}
		
		//@todo listener so that objects inside scroller can remove themselves
		private function removeNotificationFromScroller(notification:Object){
			//trace("removeNotificationFromScroller()");
			if (notification!=null){
				var itemsInScroller:Array = notificationsScroller.getItemsInScroller();
				for(var i=0; i<itemsInScroller.length; i++) {
					var itemInScroller:Object = itemsInScroller[i];
					//trace("found an item in list");
					if (itemInScroller==notification){
						//trace("removing itemInScroller");
						notificationsScroller.removeItem(DisplayObject(itemInScroller));
					}
			   }
			}
		}
		
		
		


	}
	
}