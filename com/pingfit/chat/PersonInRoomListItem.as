package com.pingfit.chat {
	
	import com.pingfit.scroller.ScrollerSortable;
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import flash.events.*;
	import com.pingfit.events.*;
	import com.pingfit.controls.User16Icon;
	import com.pingfit.data.objects.User;
	
	
	public class PersonInRoomListItem extends MovieClip implements ScrollerSortable {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var square:MovieClip;
		private var nameOnScr:TextField;
		private var user:User;
		private var userIcon:User16Icon;
		private var order:int = 0;

		
		public function getOrder():int { return order; }
		public function setOrder(order:int):void { this.order = order; };

		public function PersonInRoomListItem(maxWidth:Number, maxHeight:Number, user:User) { 
			//trace("ScrollMenuItem instanciated -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.user = user;
			
			Broadcaster.addEventListener(PresenceChange.TYPE, onPresenceChange);
			addEventListener(MouseEvent.CLICK, onClick);
			
			userIcon = new User16Icon();
			addChild(userIcon);

			square = new MovieClip();
			square.buttonMode = true;
			square.alpha = .15;
			addChild(square);
		
			
			nameOnScr = TextUtil.getTextField(TextUtil.getHelveticaRounded(9, 0xE6E6E6, true), maxWidth - 4 - 16 - 2, user.getNickname());
			nameOnScr.mouseEnabled = false;
			addChild(nameOnScr);

			
			
			resize(maxWidth, maxHeight);
		}
		
		private function onPresenceChange(e:PresenceChange):void{
			if (int(e.userid)==user.getUserid() || e.facebookuid==user.getFacebookuid()){
				trace("PersonInRoomListItem.onPresenceChange() userid="+user.getUserid()+" e.userid="+e.userid+" e.nickname="+e.nickname+" e.roomname="+e.roomname +" e.userstatus="+e.userstatus+" (change for me)");
				if (e.userstatus == "Online") {
					trace("PersonInRoomListItem.onPresenceChange() making online e.nickname="+e.nickname+" userid="+user.getUserid()) ;
					userIcon.alpha = 1;
					square.alpha = .15;
					//For now just make positive which'll bump to top, in theory
					order = 1;
				} else {
					trace("PersonInRoomListItem.onPresenceChange() making offline e.nickname="+e.nickname+" userid="+user.getUserid()) ;
					userIcon.alpha = .5;
					square.alpha = .05;
					//For now just make negative which'll bump to bottom, in theory
					order = -1;
				}
				resize(maxWidth, maxHeight);
			} else {
				//trace("PersonInRoomListItem.onPresenceChange() userid="+userid+" e.userid="+e.userid+" e.nickname="+e.nickname+" e.roomname="+e.roomname+" (ignoring)");
			}
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ScrollMenuItem -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			userIcon.x = 2;
			userIcon.y = 2;
			
			nameOnScr.x = 20;
			nameOnScr.y = 2;
			//nameOnScr.width = maxWidth-4;
			
			
			var squareHeight:Number = nameOnScr.y + nameOnScr.textHeight + 5;
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
			square.alpha = .15;
			
		}
		
		private function onClick(e:MouseEvent):void {
			Broadcaster.dispatchEvent(new DisplayUserProfile(user));
		}
		
		public function getUser():User{
			return user;
		}
		
		public function getUserid():int{
			return user.getUserid();
		}
		
		public function getFacebookuid():String{
			return user.getFacebookuid();
		}
		

	}
	
}