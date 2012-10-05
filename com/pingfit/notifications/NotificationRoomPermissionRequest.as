package com.pingfit.notifications {
	
	import com.pingfit.events.remote.RoomPermissionGranted;
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.events.*;
	import com.pingfit.xml.*;
	import com.pingfit.controls.PlainButton;
	import com.pingfit.events.*;
	import com.pingfit.events.remote.*;
	
	public class NotificationRoomPermissionRequest extends MovieClip {
		
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var square:MovieClip;
		private var description:TextField;
		private var roomPermissionRequest:RoomPermissionRequest;
		private var buttonConfirm:PlainButton;
		private var buttonIgnore:PlainButton;

		

		public function NotificationRoomPermissionRequest(maxWidth:Number, maxHeight:Number, roomPermissionRequest:RoomPermissionRequest) { 
			trace("NotificationRoomPermissionRequest instanciated -- maxWidth="+maxWidth+" maxHeight="+maxHeight+" this.height="+this.height);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.roomPermissionRequest = roomPermissionRequest;

			square = new MovieClip();
			addChild(square);
			
			description = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), maxWidth - 40, roomPermissionRequest.getNicknameofrequestor() + " wants your permission to enter the room '"+roomPermissionRequest.getRoomname()+".'");	
			addChild(description);
			
			buttonConfirm = new PlainButton(90, 25, "Let Them In");
			buttonConfirm.addEventListener(MouseEvent.CLICK, buttonConfirmClick);
			addChild(buttonConfirm);
	
			buttonIgnore = new PlainButton(90, 25, "Ignore");
			buttonIgnore.addEventListener(MouseEvent.CLICK, buttonIgnoreClick);
			addChild(buttonIgnore);
		
			resize(maxWidth, maxHeight);
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("NotificationRoomPermissionRequest -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			description.x = 5;
			description.y = 5;
			description.width = maxWidth;
			
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
				grantPermission();
        }
		public function grantPermission():void{
			trace("NotificationRoomPermissionRequest.grantPermission()");
			var apiCaller:CallGrantRoomPermission = new CallGrantRoomPermission(roomPermissionRequest.getUseridofrequestor(), roomPermissionRequest.getRoomid());
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onGrantSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onGrantFail);
		}
		private function onGrantSuccess(e:ApiCallSuccess):void{
			trace("onGrantSuccess()");
			var remoteEvent:RoomPermissionGranted = new RoomPermissionGranted();
			remoteEvent.setArgsLocal(roomPermissionRequest.getRoomid(), roomPermissionRequest.getRoomname());
			RemoteBroadcaster.dispatchEventToUser(roomPermissionRequest.getUseridofrequestor(), remoteEvent);
			dispatchEvent(new RemoveMeFromScroller(this));
		}
		private function onGrantFail(e:ApiCallFail):void{
			trace("onGrantFail() - e.error="+e.error);
		}
		
		
		
		private function buttonIgnoreClick(e:MouseEvent):void {   
			revokePermission();
        }
		public function revokePermission():void{
			trace("NotificationRoomPermissionRequest.revokePermission()");
			var apiCaller:CallRevokeRoomPermission = new CallRevokeRoomPermission(roomPermissionRequest.getUseridofrequestor(), roomPermissionRequest.getRoomid());
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onRevokeSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onRevokeFail);
		}
		private function onRevokeSuccess(e:ApiCallSuccess):void{
			trace("onRevokeSuccess()");
			dispatchEvent(new RemoveMeFromScroller(this));
		}
		private function onRevokeFail(e:ApiCallFail):void{
			trace("onRevokeFail() - e.error="+e.error);
		}
		
	

	}
	
}