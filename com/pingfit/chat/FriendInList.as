package com.pingfit.chat {
	
	import com.pingfit.controls.User16Icon;
	import com.pingfit.scroller.ScrollerSortable;
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import flash.events.*;
	import com.pingfit.data.objects.User;
	import com.pingfit.events.*;
	
	
	public class FriendInList extends MovieClip implements ScrollerSortable {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var bg:MovieClip;
		private var _name:TextField;
		private var _status:TextField;
		private var user:User;
		private var userIcon:User16Icon;
		private var order:int = 0;
		
		public function getOrder():int { return order; }
		public function setOrder(order:int):void { this.order = order; };

		
		public function FriendInList(maxWidth:Number, maxHeight:Number, user:User) { 
			//trace("ScrollMenuItem instanciated -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.user = user;
			
			//Listen
			Broadcaster.addEventListener(PresenceChange.TYPE, onPresenceChange);
			addEventListener(MouseEvent.CLICK, onClick);
			
			userIcon = new User16Icon();
			userIcon.alpha = .5;
			addChild(userIcon);

			bg = new MovieClip();
			bg.alpha = .05;
			bg.buttonMode = true;
			addChild(bg);
			
			_name = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), maxWidth - 4 - 16 - 2, user.getNickname());
			_name.alpha = .2;
			_name.mouseEnabled = false;
			addChild(_name);
			
			_status = TextUtil.getTextField(TextUtil.getHelveticaRounded(9, 0xE6E6E6, true), maxWidth - 4 - 16 - 2, "Offline");
			_status.alpha = .2;
			_status.mouseEnabled = false;
			addChild(_status);
			
			resize(maxWidth, maxHeight);
		}
		
		private function onPresenceChange(e:PresenceChange):void{
			if (int(e.userid)==user.getUserid() || e.facebookuid==user.getFacebookuid()){
				trace("FriendInList.onPresenceChange() user.getUserid()="+user.getUserid()+" e.userid="+e.userid+" e.nickname="+e.nickname+" e.roomname="+e.roomname +" e.userstatus="+e.userstatus+" (change for me)");
				if (e.userstatus == "Online") {
					trace("FriendInList.onPresenceChange() making online name="+user.getNickname()+" userid="+user.getUserid()) ;
					_status.htmlText = "In Room: " + e.roomname;
					userIcon.alpha = 1;
					_name.alpha = 1;
					_status.alpha = 1;
					bg.alpha = .15;
					//For now just make positive which'll bump to top, in theory
					order = 1;
				} else {
					trace("FriendInList.onPresenceChange() making offline name="+user.getNickname()+" userid="+user.getUserid()) ;
					_status.htmlText = e.userstatus;
					userIcon.alpha = .5;
					_name.alpha = .4;
					_status.alpha = .4;
					bg.alpha = .05;
					//For now just make negative which'll bump to bottom, in theory
					order = -1;
				}
				resize(maxWidth, maxHeight);
			} else {
				//trace("FriendInList.onPresenceChange() user.getUserid()="+user.getUserid()+" e.userid="+e.userid+" e.nickname="+e.nickname+" e.roomname="+e.roomname+" (ignoring)");
			}
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ScrollMenuItem -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			userIcon.x = 2;
			userIcon.y = 2;
			
			_name.x = 20;
			_name.y = 2;
			//_name.width = maxWidth;
			
			_status.x = 20;
			_status.y = _name.y + _name.textHeight + 1
			
			
			var bgHeight:Number = _status.y + _status.textHeight + 7;
			if (bgHeight<maxHeight){ bgHeight = maxHeight; }
			if (bgHeight<20){ bgHeight = 20; }
			
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0, maxWidth, bgHeight, 10);
			bg.graphics.endFill();
			bg.x = 0;
			bg.y = 0;
		}
		
		private function onClick(e:MouseEvent):void {
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Friends"));
			Broadcaster.dispatchEvent(new DisplayUserProfile(user));
		}
		
		public function getUser():User{
			return user;
		}
		

	}
	
}