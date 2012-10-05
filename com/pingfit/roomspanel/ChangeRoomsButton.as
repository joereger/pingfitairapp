package com.pingfit.roomspanel
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.text.*;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.display.MovieClip;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.events.*;


	public class ChangeRoomsButton extends Sprite {
		
		private var mainText:TextField;
		private var maxWidth:Number = 40;
		private var maxHeight:Number = 20;
		private var bg:MovieClip;

		public function ChangeRoomsButton(maxWidth:Number, maxHeight:Number):void{
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			
			bg = new MovieClip();
			addChild(bg);
			
			mainText = TextUtil.getTextField(TextUtil.getHelveticaRounded(10, 0xE6E6E6, true), 100, "Change Rooms");
			mainText.filters = Shadow.getDropShadowFilterArray(0x000000);
			mainText.x = 2;
			mainText.y = 0;
			mainText.alpha = 1;
			addChild(mainText);
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, onClick);
			
			resize(maxWidth, maxHeight);
		}
		
		private function onClick(event:MouseEvent):void{
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Rooms"));
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			trace("ChangeRoomsButton -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0, mainText.textWidth+8, mainText.textHeight+3, 10);
			bg.graphics.endFill();
			bg.alpha = .10;
		}
	}
}