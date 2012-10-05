package com.pingfit.roomspanel
{
	
	import com.pingfit.events.remote.NewRoomPermissionRequest;
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
	import com.pingfit.data.static.*;
	import com.pingfit.data.objects.ExerciseList;
	import com.pingfit.data.objects.Room;
	import com.pingfit.events.*;
	import com.pingfit.events.remote.*;
	import com.pingfit.scroller.*;
	import com.pingfit.roomspanel.RoomInList;
	import com.pingfit.controls.NewRoomButton;
	import com.pingfit.controls.EnterRoomButton;
	import com.pingfit.alerts.*;
	
	

	public class RoomPanel extends MovieClip {
		
		private var room:Room;
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		
		private var labelName:TextField;
		private var inputName:TextInput;
		private var txtName:TextField;
		
		private var labelDescription:TextField;
		private var inputDescription:TextInput;
		private var txtDescription:TextField;
		
		private var labelExerciseList:TextField;
		private var inputExerciseList:ComboBox;
		private var txtExerciseList:TextField;
		
		private var labelPrivate:TextField;
		private var inputPrivate:CheckBox;
		private var txtPrivate:TextField;
		
		private var labelFriendsallowed:TextField;
		private var inputFriendsallowed:CheckBox;
		private var txtFriendsallowed:TextField;
		
		private var buttonSave:Button;
		private var buttonEnter:EnterRoomButton;
		private var buttonRequest:RequestPermissionToEnterRoomButton;
		private var buttonEdit:Button;
		
		private var txtStatus:TextField;
		
		
		public function RoomPanel(maxWidth:Number, maxHeight:Number, room:Room){
			//trace("ExercisePanel instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.room = room;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		
		
		function initListener (e:Event):void {
			//trace("ExercisePanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			
			var leftX:Number = 50;
			var canEdit:Boolean = false;
			
			if (CurrentUser.getUser().getUserid()==room.getUseridofcreator()){
				canEdit = true;
			}
			
			//Name
			
			if (canEdit) {
				labelName = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), maxWidth-100, "Room Name");
				labelName.filters = Shadow.getDropShadowFilterArray(0x000000);
				labelName.x = leftX;
				labelName.y = 20;
				addChild(labelName);
				inputName = new TextInput();
				inputName.text = room.getName();
				inputName.maxChars = 30;
				inputName.width = 200;
				inputName.x = leftX;
				inputName.y = 45;
				addChild(inputName);
			} else {
				txtName = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, room.getName());
				txtName.filters = Shadow.getDropShadowFilterArray(0x000000);
				txtName.x = leftX;
				txtName.y = 20;
				addChild(txtName);
			}
			
			//Description
			labelDescription = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), maxWidth-100, "Description");
			labelDescription.filters = Shadow.getDropShadowFilterArray(0x000000);
			labelDescription.x = leftX;
			labelDescription.y = 75;
			addChild(labelDescription);
			if (canEdit){
				inputDescription = new TextInput();
				inputDescription.text = room.getDescription();
				inputDescription.maxChars = 300;
				inputDescription.width = 275;
				inputDescription.x = leftX;
				inputDescription.y = 100;
				addChild(inputDescription);
			} else {
				txtDescription = TextUtil.getTextField(TextUtil.getHelveticaRounded(11, 0xE6E6E6, true), maxWidth-100, room.getDescription());
				txtDescription.x = leftX;
				txtDescription.y = 100;
				addChild(txtDescription);
			}
			
			//ExerciseList
			labelExerciseList = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), maxWidth-100, "Exercise List");
			labelExerciseList.filters = Shadow.getDropShadowFilterArray(0x000000);
			labelExerciseList.x = leftX;
			labelExerciseList.y = 125;
			addChild(labelExerciseList);
			if (canEdit){
				inputExerciseList = new ComboBox();
				inputExerciseList.x = leftX;
				inputExerciseList.y = 150;
				inputExerciseList.setSize(250,22);
				var exerciselists:Array  = ExerciseLists.getExerciseLists();
				for each (var exerciselist:ExerciseList in exerciselists) {
					inputExerciseList.addItem( { label: exerciselist.getName(), data:exerciselist.getExerciselistid()} );
					if (exerciselist.getExerciselistid() == room.getExerciselistid()){
						inputExerciseList.selectedIndex=inputExerciseList.length-1;
					}
				}
				addChild(inputExerciseList);
			} else {
				txtExerciseList = TextUtil.getTextField(TextUtil.getHelveticaRounded(11, 0xE6E6E6, true), maxWidth-100, room.getExerciseList().getName());
				txtExerciseList.x = leftX;
				txtExerciseList.y = 150;
				addChild(txtExerciseList);
			}
			
			
			
			//Private
			labelPrivate = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), maxWidth-100, "Room Privacy");
			labelPrivate.filters = Shadow.getDropShadowFilterArray(0x000000);
			labelPrivate.x = leftX;
			labelPrivate.y = 175;
			addChild(labelPrivate);
			if (canEdit){
				inputPrivate = new CheckBox();
				inputPrivate.setStyle("textFormat", TextUtil.getArial(12, 0xE6E6E6, true));
				inputPrivate.label = "Room is Private";
				inputPrivate.width = 300;
				inputPrivate.x = leftX;
				inputPrivate.y = 200;
				if (room.getIsprivate()){
					inputPrivate.selected = true;
				} else {
					inputPrivate.selected = false;
				}
				addChild(inputPrivate);
			} else {
				var prv:String = "Room is Private";
				if (!room.getIsprivate()){ prv="Room is Public"; }
				txtPrivate = TextUtil.getTextField(TextUtil.getArial(11, 0xE6E6E6, true), maxWidth-100, prv);
				txtPrivate.filters = Shadow.getDropShadowFilterArray(0x000000);
				txtPrivate.x = leftX;
				txtPrivate.y = 200;
				addChild(txtPrivate);
			}
			
			//Friend
			labelFriendsallowed = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), maxWidth-100, "Friends Permission");
			labelFriendsallowed.filters = Shadow.getDropShadowFilterArray(0x000000);
			labelFriendsallowed.x = leftX;
			labelFriendsallowed.y = 225;
			addChild(labelFriendsallowed);
			if (canEdit){
				inputFriendsallowed = new CheckBox();
				inputFriendsallowed.setStyle("textFormat", TextUtil.getArial(12, 0xE6E6E6, true));
				inputFriendsallowed.label = "Friends Automatically Permitted (Even if Private Room)";
				inputFriendsallowed.width = 400;
				inputFriendsallowed.x = leftX;
				inputFriendsallowed.y = 250;
				if (room.getIsfriendautopermit()){
					inputFriendsallowed.selected = true;
				} else {
					inputFriendsallowed.selected = false;
				}
				addChild(inputFriendsallowed);
			} else {
				if (room.getIsprivate()){
					var fal:String = "Friends are Automatically Permitted";
					if (!room.getIsfriendautopermit()){ fal="Friends Must Request Permission to Enter"; }
					txtFriendsallowed = TextUtil.getTextField(TextUtil.getHelveticaRounded(11, 0xE6E6E6, true), maxWidth-100, fal);
					txtFriendsallowed.filters = Shadow.getDropShadowFilterArray(0x000000);
					txtFriendsallowed.x = leftX;
					txtFriendsallowed.y = 250;
					addChild(txtFriendsallowed);
				}
			}
			
			//Save/Edit Button (oogly)
			if (canEdit){
				if (room.getRoomid()>0){
					buttonEdit = new Button();
					buttonEdit.x = leftX;
					buttonEdit.y = 275;
					buttonEdit.label = "Save Room";
					buttonEdit.width = 187;
					buttonEdit.height = 25;
					buttonEdit.addEventListener(MouseEvent.CLICK, buttonEditClick);
					addChild(buttonEdit);
				} else {
					buttonSave = new Button();
					buttonSave.x = leftX;
					buttonSave.y = 275;
					buttonSave.label = "Create Room";
					buttonSave.width = 187;
					buttonSave.height = 25;
					buttonSave.addEventListener(MouseEvent.CLICK, buttonSaveClick);
					addChild(buttonSave);
				}
			} 
			
			
			//Enter/RequestPermission Button (perty)
			if (room.getRoomid() > 0) {
				if (!room.getIsprivate()) {
					turnOnEnterButton();
				} else {
					callIsAllowedInRoom(room.getRoomid());
				}
			}
			
			
			txtStatus = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xFFFFFF, true), maxWidth-200-leftX, "");
			txtStatus.filters = Shadow.getDropShadowFilterArray(0x000000);
			txtStatus.x = leftX;
			txtStatus.y = maxHeight - 100;
			addChild(txtStatus);
			
			
			resize(maxWidth, maxHeight);
		}


		

		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ExercisePanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			//trace("ExercisePanel -- stageWidth: " + parent.stage.stageWidth + " stageHeight: " + parent.stage.stageHeight);
		
		}
		
		private function turnOnEnterButton():void {
			if (buttonEnter != null) { removeChild(buttonEnter); buttonEnter = null; }
			if (buttonRequest != null) { removeChild(buttonRequest); buttonRequest = null; }
			buttonEnter = new EnterRoomButton();
			buttonEnter.x = maxWidth - 200;
			buttonEnter.y = maxHeight - 75;
			buttonEnter.addEventListener(MouseEvent.CLICK, buttonEnterClick);
			addChild(buttonEnter);
		}
		
		private function turnOnRequestButton():void {
			if (buttonEnter != null) { removeChild(buttonEnter); buttonEnter = null; }
			if (buttonRequest != null) { removeChild(buttonRequest); buttonRequest = null; }
			buttonRequest = new RequestPermissionToEnterRoomButton();
			buttonRequest.x = maxWidth - 200;
			buttonRequest.y = maxHeight - 75;
			buttonRequest.addEventListener(MouseEvent.CLICK, buttonRequestClick);
			addChild(buttonRequest);
		}
		
		
		
		private function buttonSaveClick(e:MouseEvent):void {
            trace("NavPanelRoom.buttonSaveClick()");   
			callCreateRoom(inputName.text, inputDescription.text, int(inputExerciseList.selectedItem.data), inputPrivate.selected, inputFriendsallowed.selected);
        }
		
		private function buttonEditClick(e:MouseEvent):void {
            trace("NavPanelRoom.buttonEditClick()");   
			callEditRoom(room.getRoomid(), inputName.text, inputDescription.text, int(inputExerciseList.selectedItem.data), inputPrivate.selected, inputFriendsallowed.selected);
        }
		
		private function buttonEnterClick(e:MouseEvent):void {
            trace("NavPanelRoom.buttonEnterClick()");
			Broadcaster.dispatchEvent(new LeaveRoom(CurrentRoom.getCurrentRoom()));
			callJoinRoom(room.getRoomid());
        }
		
		private function buttonRequestClick(e:MouseEvent):void {
            trace("NavPanelRoom.buttonRequestClick()");
			callJoinRoomRequest(room.getRoomid());
        }
		
		
		
		
		
		public function callJoinRoom(roomid:int):void{
			trace("RoomPanel.callJoinRoom()");
			var apiCaller:CallJoinRoom = new CallJoinRoom(roomid);
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("RoomPanel.onApiCallSuccess()");
			if(e.xmlData.result.attribute("success") == "true"){
				Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, onBigRefreshDone);
				BigRefresh.refreshViaAPI();
			} else {
				txtStatus.text = "Error: "+e.xmlData.result.apimessage;
			}
		}
		private function onApiCallFail(e:ApiCallFail):void{
			trace("RoomPanel.onApiCallFail() - e.error="+e.error);
			txtStatus.text = e.error;
		}
		private function onBigRefreshDone(e:PEvent):void{
			trace("RoomPanel.onBigRefreshDone()");
			Broadcaster.removeEventListener(PEvent.BIGREFRESHDONE, onBigRefreshDone);
			PingFit.setJustStartedNeedToShowExerciseImmediately(true);
			Broadcaster.dispatchEvent(new PEvent(PEvent.SWITCHTOWORKOUTGROUP));
			Broadcaster.dispatchEvent(new EnterRoom(CurrentRoom.getCurrentRoom()));
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Exercise"));
			AlertCoordinator.newAlert("You're now exercising in group mode in room '"+CurrentRoom.getCurrentRoom().getName()+"'.", "", null);
		}
		
		private function onLoadRoomsFromServer(e:ApiCallSuccess):void {
			trace("RoomPanel.onLoadRoomsFromServer() called, doing nothing about it");
		}
		
		
		
		public function callCreateRoom(name:String, description:String, exerciselistid:int, isprivate:Boolean, isfriendautopermit:Boolean):void{
			trace("RoomPanel.callCreateRoom()");
			var apiCaller:CallCreateRoom = new CallCreateRoom(name, description, exerciselistid, isprivate, isfriendautopermit);
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccessCreate);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFailCreate);
		}
		private function onApiCallSuccessCreate(e:ApiCallSuccess):void{
			trace("RoomPanel.onApiCallSuccessCreate()");
			if(e.xmlData.result.attribute("success") == "true"){
				Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, onBigRefreshDoneCreate);
				BigRefresh.refreshViaAPI();
			} else {
				txtStatus.text = "Error: "+e.xmlData.result.apimessage;
			}
		}
		private function onApiCallFailCreate(e:ApiCallFail):void{
			trace("RoomPanel.onApiCallFailCreate() - e.error="+e.error);
			txtStatus.text = e.error;
		}
		private function onBigRefreshDoneCreate(e:PEvent):void{
			trace("RoomPanel.onBigRefreshDoneCreate()");
			Broadcaster.removeEventListener(PEvent.BIGREFRESHDONE, onBigRefreshDoneCreate);
			this.visible = false;
			Broadcaster.dispatchEvent(new RoomsInListChangeCriteria(2));
			var caller3:CallGetRoomsIModerate = new CallGetRoomsIModerate();
			caller3.addEventListener(ApiCallSuccess.TYPE, onLoadRoomsFromServer);
		}
		
		
		
		public function callEditRoom(roomid:int, name:String, description:String, exerciselistid:int, isprivate:Boolean, isfriendautopermit:Boolean):void{
			trace("RoomPanel.callCreateRoom()");
			var apiCaller:CallEditRoom = new CallEditRoom(roomid, name, description, exerciselistid, isprivate, isfriendautopermit);
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccessEdit);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFailEdit);
		}
		private function onApiCallSuccessEdit(e:ApiCallSuccess):void{
			trace("RoomPanel.onApiCallSuccessEdit()");
			if(e.xmlData.result.attribute("success") == "true"){
				Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, onBigRefreshDoneEdit);
				BigRefresh.refreshViaAPI();
			} else {
				txtStatus.text = "Error: "+e.xmlData.result.apimessage;
			}
		}
		private function onApiCallFailEdit(e:ApiCallFail):void{
			trace("RoomPanel.onApiCallFailEdit() - e.error="+e.error);
			txtStatus.text = e.error;
		}
		private function onBigRefreshDoneEdit(e:PEvent):void{
			trace("RoomPanel.onBigRefreshDoneEdit()");
			Broadcaster.removeEventListener(PEvent.BIGREFRESHDONE, onBigRefreshDoneEdit);
			this.visible = false;
			Broadcaster.dispatchEvent(new RoomsInListChangeCriteria(2));
			var caller3:CallGetRoomsIModerate = new CallGetRoomsIModerate();
			caller3.addEventListener(ApiCallSuccess.TYPE, onLoadRoomsFromServer);
		}
		
		
		
		public function callIsAllowedInRoom(roomid:int):void{
			trace("RoomPanel.callIsAllowedInRoom()");
			var apiCaller:CallIsAllowedInRoom = new CallIsAllowedInRoom(CurrentUser.getUser().getUserid(), roomid);
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccessIsAllowed);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFailIsAllowed);
		}
		private function onApiCallSuccessIsAllowed(e:ApiCallSuccess):void{
			trace("RoomPanel.onApiCallSuccessIsAllowed()");
			if (e.xmlData.isallowedinroom!=null && e.xmlData.isallowedinroom=="true") {
				turnOnEnterButton();
			} else {
				turnOnRequestButton();
			}
		}
		private function onApiCallFailIsAllowed(e:ApiCallFail):void{
			trace("RoomPanel.onApiCallFailIsAllowed() - e.error="+e.error);
			txtStatus.text = e.error;
		}

		
		
		public function callJoinRoomRequest(roomid:int):void{
			trace("RoomPanel.callJoinRoomRequest()");
			var apiCaller:CallJoinRoom = new CallJoinRoom(roomid);
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccessRequest);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFailRequest);
		}
		private function onApiCallSuccessRequest(e:ApiCallSuccess):void{
			trace("RoomPanel.onApiCallSuccessRequest()");
			if(e.xmlData.result.attribute("success") == "true"){
				Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, onBigRefreshDone);
				BigRefresh.refreshViaAPI();
			} else {
				var remoteEvent:NewRoomPermissionRequest = new NewRoomPermissionRequest();
				remoteEvent.setArgsLocal(room.getRoomid(), CurrentUser.getUser().getUserid(), CurrentUser.getUser().getNickname());
				RemoteBroadcaster.dispatchEventToUser(room.getUseridofcreator(), remoteEvent);
				txtStatus.text = "Permission has been requested.  You'll receive a notification if the room owner approves your request.";
			}
		}
		private function onApiCallFailRequest(e:ApiCallFail):void{
			trace("RoomPanel.onApiCallFailRequest() - e.error=" + e.error);
			var remoteEvent:NewRoomPermissionRequest = new NewRoomPermissionRequest();
			remoteEvent.setArgsLocal(room.getRoomid(), CurrentUser.getUser().getUserid(), CurrentUser.getUser().getNickname());
			RemoteBroadcaster.dispatchEventToUser(room.getUseridofcreator(), remoteEvent);
			txtStatus.text = "Permission has been requested.  You'll receive a notification if the room owner approves your request.";
		}
		
		
	}

	
	
}