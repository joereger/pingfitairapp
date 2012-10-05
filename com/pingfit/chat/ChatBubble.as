package com.pingfit.chat {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import flash.events.*;
	
	
	public class ChatBubble extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var square:MovieClip;
		private var triangle:MovieClip;
		private var nameOnScr:TextField;
		private var messageOnScr:TextField;
		private var percentWidthForName:Number = .25;
		private var percentWidthForMsg:Number = .75;
		private var type:String;
		private var chatIcon:MovieClip;
		

		public function ChatBubble(maxWidth:Number, maxHeight:Number, nameTxt:String, messageTxt:String, type:String="") { 
			//trace("ScrollMenuItem instanciated -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.type = type;

			square = new MovieClip();
			addChild(square);
			
			triangle = new MovieClip();
			addChild(triangle);
			
			nameOnScr = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), maxWidth*percentWidthForName, nameTxt);
			addChild(nameOnScr);
			
			messageOnScr = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), maxWidth*percentWidthForMsg, messageTxt);	
			addChild(messageOnScr);
			
			if (type=="exercisecompleted"){
				chatIcon = new IconExerciseCompleted();
				addChild(chatIcon);
			} else if (type=="exerciseskipped"){
				chatIcon = new IconExerciseSkipped();
				addChild(chatIcon);
			} else if (type=="enterroom"){
				chatIcon = new IconUserEnterRoom();
				addChild(chatIcon);
			} else if (type=="leaveroom"){
				chatIcon = new IconUserLeaveRoom();
				addChild(chatIcon);
			} else {
				//Nothing special
			}
			
			resize(maxWidth, maxHeight);
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ScrollMenuItem -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			nameOnScr.x = 2;
			nameOnScr.y = 2;
			nameOnScr.width = maxWidth*percentWidthForName;
			
			messageOnScr.x = maxWidth*percentWidthForName + 8;
			messageOnScr.y = 2;
			messageOnScr.width = maxWidth*percentWidthForMsg - 10;
			
			var squareHeight:Number = messageOnScr.y + messageOnScr.textHeight + 7;
			if (squareHeight<maxHeight){
				squareHeight = maxHeight;
			}
			if (squareHeight<20){
				squareHeight = 20;
			}
			
			square.graphics.clear();
			square.graphics.beginFill(0xFFFFFF);
			square.graphics.drawRoundRect(0,0, maxWidth*percentWidthForMsg, squareHeight, 10);
			square.graphics.endFill();
			square.x = maxWidth*percentWidthForName;
			square.alpha = .10;
			
			triangle.graphics.clear();
			triangle.graphics.lineStyle(0, 0x000000);
			triangle.graphics.beginFill(0xFFFFFF);
			triangle.graphics.moveTo(square.x, 5);
			triangle.graphics.lineTo(square.x-10, 10);
			triangle.graphics.lineTo(square.x, 15);
			triangle.graphics.lineTo(square.x, 5);
			triangle.graphics.endFill();
			triangle.alpha = .10;
			
			if (chatIcon!=null){
				chatIcon.x = maxWidth - 19;
				chatIcon.y = 4;
			}
			
			
		}
		

	}
	
}