package com.pingfit.nav {
	
	import flash.text.*;
	import com.pingfit.format.*;
	import com.pingfit.events.*;
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
	import noponies.events.NpTextScrollBarEvent;
	import noponies.ui.NpTextScroller;
	import fl.controls.Button;
	import com.pingfit.data.static.CurrentUser;
	import com.pingfit.data.static.Eula;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class NavPanelEula extends NavPanelBase {
		
		private var eula_title:TextField;
		private var eulaScroll:NpTextScroller;
		private var iAgreeButton:Button;
		private var iDeclineButton:Button;
		
		public function NavPanelEula(maxWidth:Number, maxHeight:Number, navPanelType:String="Eula", navPanelName:String="Eula"){
			trace("NavPanelEula instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		public override function initListener (e:Event):void {
			trace("NavPanelEula.initListener() called");
			super.initListener(e);
			
			
			
			
			eula_title = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "End User License Agreement");
			eula_title.filters = Shadow.getDropShadowFilterArray(0x000000);
			eula_title.x = 30;
			eula_title.y = 20;
			addChild(eula_title);

		
			var instrX:Number = (maxWidth-(maxWidth-200))/2;
			var instrY:Number = (maxHeight-(maxHeight-200))/2;
			var instrWidth:Number = maxWidth-200;
			var instrHeight:Number = maxHeight-200;
			var instrFormat:TextFormat = TextUtil.getArial(14, 0xE6E6E6, true);
			eulaScroll = new NpTextScroller();
			eulaScroll.dragHandleColour = 0xFFCCFF;
			eulaScroll.sliderBarWidth = 10;
			eulaScroll.sliderBarHeight = instrHeight;
			eulaScroll.scrollWidth = instrWidth;
			eulaScroll.scrollHeight = instrHeight;
			eulaScroll.useEmbeddedFont = true;
			eulaScroll.sliderXPos = instrWidth-10;
			eulaScroll.sliderYPos = 0;
			eulaScroll.textScrollBlur = false;
			eulaScroll.mouseWheelScrolling = true;
			var eulaTxt:String = Eula.getEula();
			if (eulaTxt == null) { eulaTxt = " "; }
			eulaScroll.addScrollText(eulaTxt, instrFormat);
			eulaScroll.x = instrX;
			eulaScroll.y = instrY;
			addChild(eulaScroll);
			
			iAgreeButton = new Button();
			iAgreeButton.x = ((maxWidth/2)-150)/2;
			iAgreeButton.y = maxHeight - 50;
			iAgreeButton.label = "I Agree";
			iAgreeButton.width = 150;
			iAgreeButton.addEventListener(MouseEvent.CLICK, iAgreeButtonClick);
			addChild(iAgreeButton);
			
			iDeclineButton = new Button();
			iDeclineButton.x = (((maxWidth/2)-150)/2)+(maxWidth/2);
			iDeclineButton.y = maxHeight - 50;
			iDeclineButton.label = "I Decline";
			iDeclineButton.width = 150;
			iDeclineButton.addEventListener(MouseEvent.CLICK, iDeclineButtonClick);
			addChild(iDeclineButton);
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void {  
			
			if (CurrentUser != null && CurrentUser.getUser() != null && CurrentUser.getUser().getIsusereulauptodate()) {
				trace("NavPanelEula - CurrentUser.getUser().getNickname()="+CurrentUser.getUser().getNickname()+" CurrentUser.getUser().getIsusereulauptodate()="+CurrentUser.getUser().getIsusereulauptodate());
				callAgreeToEulaDone(null);
				return;
			}	
			
		}
		
		//Override to hide NavBar for a specific panel
		public override function isNavBarVisibleForThisPanel():Boolean { return false; }
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelEula -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
		}
		
		private function iAgreeButtonClick(e:MouseEvent) {
            trace("iAgree clicked");
			callAgreeToEula();
        }
		
		private function iDeclineButtonClick(e:MouseEvent) {
            trace("iDecline clicked");
			Broadcaster.dispatchEvent(new PEvent(PEvent.EXITAPP));
        }
		

		private function callAgreeToEula():void{
			trace("callAgreeToEula called");
			var callAgreeToEulaAPI:CallAgreeToEula = new CallAgreeToEula(int(Eula.getEulaid()));
			callAgreeToEulaAPI.addEventListener(ApiCallSuccess.TYPE, callAgreeToEulaDone);
			callAgreeToEulaAPI.addEventListener(ApiCallFail.TYPE, callAgreeToEulaFail);
		}
		private function callAgreeToEulaDone(e:Event):void{
			trace("callAgreeToEulaDone");
			PingFit.setJustStartedNeedToShowExerciseImmediately(true);
			Broadcaster.dispatchEvent(new PEvent(PEvent.EULAOK));
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Exercise"));
		}
		private function callAgreeToEulaFail(e:Event):void{
			trace("callAgreeToEulaDoneFail");
		}
		


	}
	
}