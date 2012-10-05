package com.pingfit.roomspanel {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import flash.events.*;
	import com.pingfit.data.objects.Room;
	import com.pingfit.data.static.CurrentRoom;
	import com.pingfit.data.static.BigRefresh;
	import com.pingfit.events.*;
	import com.pingfit.xml.*;
	import com.pingfit.controls.RoomIcon24;
	
	public class RoomInList extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var square:MovieClip;
		private var _name:TextField;
		private var description:TextField;
		private var room:Room;
		private var roomIcon24:RoomIcon24;

		

		public function RoomInList(maxWidth:Number, maxHeight:Number, room:Room) { 
			//trace("ScrollMenuItem instanciated -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.room = room;

			square = new MovieClip();
			addChild(square);
			
			roomIcon24 = new RoomIcon24();
			addChild(roomIcon24);
			
			_name = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), maxWidth - 28, room.getName());
			addChild(_name);
			
			description = TextUtil.getTextField(TextUtil.getHelveticaRounded(10, 0xE6E6E6, true), maxWidth - 28, room.getDescription());	
			addChild(description);
			
			resize(maxWidth, maxHeight);
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ScrollMenuItem -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			roomIcon24.x = 2;
			roomIcon24.y = 2;
			
			_name.x = 28;
			_name.y = 2;
			
			description.x = 28;
			description.y = _name.textHeight + 5;
			
			var squareHeight:Number = description.y + description.textHeight + 7;
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
			
			//For now just trap any click
			addEventListener(MouseEvent.CLICK, mouseClickItem);
		}
		
		function mouseClickItem(e:Event):void {
			trace("RoomInList Clicked! -> room.getRoomid()=" + room.getRoomid());
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Rooms"));
			Broadcaster.dispatchEvent(new DisplayRoomInPanel(room));
		}
		
		
		
		public function getRoom():Room{
			return room;
		}

	}
	
}