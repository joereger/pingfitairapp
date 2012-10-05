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
	import com.pingfit.alerts.*;
	import com.pingfit.xml.CallSetExerciseChooser;
	import com.pingfit.xml.ApiParams;
	import com.pingfit.data.static.BigRefresh;


	public class ExerciseAloneButton extends Sprite {
		
		private var mainText:TextField;
		private var maxWidth:Number = 40;
		private var maxHeight:Number = 20;
		private var bg:MovieClip;

		public function ExerciseAloneButton(maxWidth:Number, maxHeight:Number):void{
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			
			bg = new MovieClip();
			addChild(bg);
			
			mainText = TextUtil.getTextField(TextUtil.getHelveticaRounded(10, 0xE6E6E6, true), 100, "Exercise Alone");
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
			//This value comes from a constant on the server side
			callSetExerciseChooser(1);
			//Take slider off screen
			AlertCoordinator.newAlert("You've been switched to solo mode.", "", null);
		}
		private function callSetExerciseChooser(exercisechooserid:int):void{
			var callSetExerciseChooserAPI:CallSetExerciseChooser = new CallSetExerciseChooser(exercisechooserid);
			callSetExerciseChooserAPI.addEventListener(ApiCallSuccess.TYPE, callSetExerciseChooserDone);
		}
		private function callSetExerciseChooserDone(e:ApiCallSuccess):void{
			BigRefresh.load(e.xmlData.bigrefresh[0]);
			Broadcaster.dispatchEvent(new PEvent(PEvent.SWITCHTOWORKOUTALONE));
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			trace("ExerciseAloneButton -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
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