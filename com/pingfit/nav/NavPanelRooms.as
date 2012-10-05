package com.pingfit.nav {
	

	import com.pingfit.roomspanel.RoomPanel;
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
	import com.pingfit.data.static.Rooms;
	import com.pingfit.data.objects.ExerciseList;
	import com.pingfit.data.objects.Room;
	import com.pingfit.events.*;
	import com.pingfit.scroller.*;
	import com.pingfit.roomspanel.RoomInList;
	import com.pingfit.controls.NewRoomButton;
	import com.pingfit.controls.EnterRoomButton;
	
	
	public class NavPanelRooms extends NavPanelBase {
		
		private var bg:MovieClip;
		private var roomsTitle:TextField;
		private var roomsScroller:Scroller;
		private var typesOfRoomsDropdown:ComboBox;
		private var buttonNewRoom:NewRoomButton;
		private var roomPanel:RoomPanel;
		
		public function NavPanelRooms(maxWidth:Number, maxHeight:Number, navPanelType:String="Rooms", navPanelName:String="Rooms"){
			trace("NavPanelRooms instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		public override function initListener (e:Event):void {
			trace("NavPanelRooms.initListener() called");
			super.initListener(e);
			
			//Listen
			Broadcaster.addEventListener(DisplayRoomInPanel.TYPE, onDisplayRoomInPanel);
			Broadcaster.addEventListener(RoomsInListChangeCriteria.TYPE, onRoomsInListChangeCriteria);
			
			bg = new MovieClip();
			addChild(bg);
			
			roomsTitle = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "Rooms");
			roomsTitle.filters = Shadow.getDropShadowFilterArray(0x000000);
			roomsTitle.x = 30;
			roomsTitle.y = 20;
			addChild(roomsTitle);
			
			//Note: The indexes/order of the addItem() calls must be synchronized with RoomsInListChangeCriteria constructor calls and with onRoomsInListChangeCriteria()
			typesOfRoomsDropdown = new ComboBox();
			typesOfRoomsDropdown.x = 30;
			typesOfRoomsDropdown.y = 75;
			typesOfRoomsDropdown.setSize(187,22);
			typesOfRoomsDropdown.addItem( { label: "Default Rooms for Everybody", data:"PublicSystem"} );
			typesOfRoomsDropdown.addItem( { label: "My Rooms & Rooms I've Been To", data:"MyRooms"} );
			typesOfRoomsDropdown.addItem( { label: "Rooms I've Created", data:"RoomsIModerate"} );
			typesOfRoomsDropdown.addItem( { label: "Rooms My Friends Were In Recently", data:"RoomsMyFriendsAreIn"} );
			typesOfRoomsDropdown.addItem( { label: "Rooms My Friends Created", data:"RoomsMyFriendsModerate"} );
			typesOfRoomsDropdown.addEventListener(Event.CHANGE, typesOfRoomsDropdownChanged);
			addChild(typesOfRoomsDropdown);
			
			buttonNewRoom = new NewRoomButton();
			buttonNewRoom.x = 30;
			buttonNewRoom.y = maxHeight - 75;
			buttonNewRoom.addEventListener(MouseEvent.CLICK, buttonNewRoomClick);
			addChild(buttonNewRoom);
			
			//Initial load of rooms
			refreshRoomsScroller(Rooms.getRooms());
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelRooms -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
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
		
		
		private function buttonNewRoomClick(e:MouseEvent):void {
            trace("NavPanelRoom.buttonNewRoomClick()");
			var room:Room = new Room();
			room.setUseridofcreator(CurrentUser.getUser().getUserid());
			room.setRoomid(0);
			room.setIsprivate(true);
			room.setIsfriendautopermit(true);
			room.setName(CurrentUser.getUser().getNickname()+"'s New Room");
			room.setDescription("");
			showRoom(room);
        }
		
		private function refreshRoomsScroller(rooms:Array):void{
			if (roomsScroller!=null){removeChild(roomsScroller); roomsScroller=null;}
			roomsScroller = new Scroller(200, maxHeight - 100 - 110);
			roomsScroller.x = 30;
			roomsScroller.y = 125;
			roomsScroller.setAutoScrollToBottomAfterItemAdd(false);
			addChild(roomsScroller);
			for each (var room:Room in rooms) {
				addRoomToScroller(room);
			}
		}
		
		private function typesOfRoomsDropdownChanged(e:Event):void {
			trace("NavPanelRooms.typesOfRoomsDropdownChanged() e.target.selectedIndex=" + e.target.selectedIndex);
			Broadcaster.dispatchEvent(new RoomsInListChangeCriteria(e.target.selectedIndex));
        }
		
		private function onRoomsInListChangeCriteria(e:RoomsInListChangeCriteria):void {
			var rooms:Array = new Array();
			trace("NavPanelRooms.onRoomsInListChangeCriteria() typesOfRoomsDropdown.selectedItem="+typesOfRoomsDropdown.selectedItem+" e.selectedIndex=" + e.selectedIndex);
			typesOfRoomsDropdown.selectedIndex = e.selectedIndex;
			if (e.selectedIndex==0){
				var caller1:CallGetRooms = new CallGetRooms();
				caller1.addEventListener(ApiCallSuccess.TYPE, onLoadRoomsFromServer);
			} else if (e.selectedIndex==1){
				var caller2:CallGetMyRooms = new CallGetMyRooms();
				caller2.addEventListener(ApiCallSuccess.TYPE, onLoadRoomsFromServer);
			} else if (e.selectedIndex==2){
				var caller3:CallGetRoomsIModerate = new CallGetRoomsIModerate();
				caller3.addEventListener(ApiCallSuccess.TYPE, onLoadRoomsFromServer);
			} else if (e.selectedIndex==3){
				var caller4:CallGetRoomsMyFriendsAreIn = new CallGetRoomsMyFriendsAreIn();
				caller4.addEventListener(ApiCallSuccess.TYPE, onLoadRoomsFromServer);
			} else if (e.selectedIndex==4){
				var caller5:CallGetRoomsMyFriendsModerate = new CallGetRoomsMyFriendsModerate();
				caller5.addEventListener(ApiCallSuccess.TYPE, onLoadRoomsFromServer);
			}
		}
		
		private function onLoadRoomsFromServer(e:ApiCallSuccess):void{
			var rooms:Array = new Array();
			if (e.xmlData!=null){
				var roomsinxml:XMLList = null;
				if (e.xmlData.rooms!=null && e.xmlData.rooms[0]!=null){
					roomsinxml = e.xmlData.rooms[0].room
				} else if (e.xmlData.myrooms!=null && e.xmlData.myrooms[0]!=null){
					roomsinxml = e.xmlData.myrooms[0].room
				} else if (e.xmlData.roomsimoderate!=null && e.xmlData.roomsimoderate[0]!=null){
					roomsinxml = e.xmlData.roomsimoderate[0].room
				} else if (e.xmlData.roomsmyfriendsarein!=null && e.xmlData.roomsmyfriendsarein[0]!=null){
					roomsinxml = e.xmlData.roomsmyfriendsarein[0].room
				} else if (e.xmlData.roomsmyfriendsmoderate!=null && e.xmlData.roomsmyfriendsmoderate[0]!=null){
					roomsinxml = e.xmlData.roomsmyfriendsmoderate[0].room
				}
				//var roomsinxml:XMLList  = e.xmlData.rooms[0].room;
				for each (var rmXml:XML in roomsinxml) {
					var rmObj:Room = new Room();
					rmObj.load(rmXml);
					rooms.push(rmObj);
				}
			}
			refreshRoomsScroller(rooms);
		}
		
		private function showRoom(room:Room):void{
			if (roomPanel != null) { removeChild(roomPanel); roomPanel = null; }
			roomPanel = new RoomPanel(maxWidth - 250, maxHeight, room);
			roomPanel.x = 250;
			addChild(roomPanel);	
		}
		
		private function onDisplayRoomInPanel(e:DisplayRoomInPanel):void {
            trace("NavPanelRoom.onDisplayRoomInPanel()");  
			showRoom(e.room);
        }
		
		private function addRoomToScroller(room:Room){
			//trace("addRoomToScroller()");
			var roomInList:RoomInList = new RoomInList(200-13, 0, room);
			roomsScroller.addItem(roomInList);
		}
		
		private function removeRoomFromScroller(roomid:int){
			//trace("removePersonFromList() userid()="+userid);
			if (roomid>0){
				var itemsInScroller:Array = roomsScroller.getItemsInScroller();
				for(var i=0; i<itemsInScroller.length; i++) {
					var itemInScroller:Object = itemsInScroller[i];
					//trace("found an item in list");
				    if (itemInScroller is RoomInList){
						//trace("itemInScroller instanceof PersonInRoomListItem");
						var pirli:RoomInList = RoomInList(itemInScroller);
						if (pirli.getRoom().getRoomid()==roomid){
							//trace("removing userid="+userid);
							roomsScroller.removeItem(DisplayObject(itemInScroller));
						}
					} else {
						//trace("itemInScroller not instanceof PersonInRoomListItem");
					}
			   }
			}
		}
		
		//private function removeRoomFromStage():void{
			//if (room!=null){room=null;}
			//
			//txtStatus.text = "";
			//
			//if (labelName!=null){removeChild(labelName); labelName=null;}
			//if (inputName!=null){removeChild(inputName); inputName=null;}
			//if (txtName!=null){removeChild(txtName); txtName=null;}
			//
			//if (labelDescription!=null){removeChild(labelDescription); labelDescription=null;}
			//if (inputDescription!=null){removeChild(inputDescription); inputDescription=null;}
			//if (txtDescription!=null){removeChild(txtDescription); txtDescription=null;}
			//
			//if (labelExerciseList!=null){removeChild(labelExerciseList); labelExerciseList=null;}
			//if (inputExerciseList!=null){removeChild(inputExerciseList); inputExerciseList=null;}
			//if (txtExerciseList!=null){removeChild(txtExerciseList); txtExerciseList=null;}
		//
			//
			//if (labelPrivate!=null){removeChild(labelPrivate); labelPrivate=null;}
			//if (inputPrivate!=null){removeChild(inputPrivate); inputPrivate=null;}
			//if (txtPrivate!=null){removeChild(txtPrivate); txtPrivate=null;}
			//
			//if (labelFriendsallowed!=null){removeChild(labelFriendsallowed); labelFriendsallowed=null;}
			//if (inputFriendsallowed!=null){removeChild(inputFriendsallowed); inputFriendsallowed=null;}
			//if (txtFriendsallowed!=null){removeChild(txtFriendsallowed); txtFriendsallowed=null;}
			//
			//if (buttonSave!=null){removeChild(buttonSave); buttonSave=null;}
			//if (buttonEnter!=null){removeChild(buttonEnter); buttonEnter=null;}
			//if (buttonEdit!=null){removeChild(buttonEdit); buttonEdit=null;}
		//}		

	}
	
}