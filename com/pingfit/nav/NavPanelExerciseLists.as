package com.pingfit.nav {
	

	import com.pingfit.events.*;
	import flash.events.Event;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.text.*;
	
	
	public class NavPanelExerciseLists extends NavPanelBase {
		
		private var panelTitle:TextField;
		private var comingSoon:TextField;
		
		public function NavPanelExerciseLists(maxWidth:Number, maxHeight:Number, navPanelType:String="ExerciseLists", navPanelName:String="ExerciseLists"){
			trace("NavPanelExerciseLists instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		public override function initListener (e:Event):void {
			trace("NavPanelExerciseLists.initListener() called");
			super.initListener(e);
			
			panelTitle = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "Exercises & Lists");
			panelTitle.filters = Shadow.getDropShadowFilterArray(0x000000);
			panelTitle.x = 30;
			panelTitle.y = 20;
			addChild(panelTitle);
			
			comingSoon = TextUtil.getTextField(TextUtil.getHelveticaRounded(11, 0xE6E6E6, true), maxWidth-100, "Coming Soon: Details on each exercise and exercise list.");
			comingSoon.filters = Shadow.getDropShadowFilterArray(0x000000);
			comingSoon.x = (maxWidth - comingSoon.textWidth)/2;
			comingSoon.y = maxHeight/2;
			addChild(comingSoon);
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void {   }
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelExerciseLists -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
		}
		
		
		


	}
	
}