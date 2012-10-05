package com.pingfit.nav {
	
	import flash.net.URLRequest;
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
	import flash.html.HTMLLoader;
	import flash.net.navigateToURL;
	
	
	public class NavPanelHelp extends NavPanelBase {
		
		var htmlLoader:HTMLLoader;
		private var launchHelpButton:LaunchHelpButton;
		private var panelTitle:TextField;
		private var helperText:TextField;
		
		public function NavPanelHelp(maxWidth:Number, maxHeight:Number, navPanelType:String="Help", navPanelName:String="Help"){
			trace("NavPanelHelp instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		public override function initListener (e:Event):void {
			trace("NavPanelHelp.initListener() called");
			super.initListener(e);
			

			
			panelTitle = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "Help/Feedback");
			panelTitle.filters = Shadow.getDropShadowFilterArray(0x000000);
			panelTitle.x = 30;
			panelTitle.y = 20;
			addChild(panelTitle);
			
			
			launchHelpButton = new LaunchHelpButton();
			launchHelpButton.addEventListener(MouseEvent.CLICK, onClickHelp);
			launchHelpButton.x = maxWidth + 10;
			launchHelpButton.y = (maxHeight - launchHelpButton.height)/2;
			launchHelpButton.alpha = 1;
			launchHelpButton.buttonMode = true;
			addChild(launchHelpButton);
			
			helperText = TextUtil.getTextField(TextUtil.getHelveticaRounded(16, 0xFFFFFF, true), 200, "Our support community is powered by Get Satisfaction.  It allows you to request help, share ideas and give us general feedback.  We want as much input as we can get so tell us what works and what doesn't!");
			helperText.filters = Shadow.getDropShadowFilterArray(0x000000);
			helperText.x = -10;
			helperText.y = ((maxHeight - launchHelpButton.height)/2) + 50;
			addChild(helperText);
			
			
			
			
			//htmlLoader = new HTMLLoader();
			//htmlLoader.x = 10;
			//htmlLoader.y = 10;
			//htmlLoader.width = maxWidth - 28;
			//htmlLoader.height = maxHeight - 28;
			//htmlLoader.load(new URLRequest("http://getsatisfaction.com/pingfit"));
			//addChild(htmlLoader);
			
			//var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
            //var window:NativeWindow = new NativeWindow(initOptions);
            //window.visible = true;
            //var htmlLoader2:HTMLLoader = new HTMLLoader();
			//htmlLoader.load(new URLRequest("http://getsatisfaction.com/pingfit"));
            //htmlLoader2.width = maxWidth - 28;
            //htmlLoader2.height = maxHeight - 28;
            //window.stage.scaleMode = StageScaleMode.NO_SCALE;
            //window.stage.addChild(htmlLoader2);


			
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void {  
			launchHelpButton.x = maxWidth + 10;
			TweenLite.to(launchHelpButton, 1.75, {x:((maxWidth - launchHelpButton.width)/2), ease:Elastic.easeOut})
			helperText.x = -10;
			TweenLite.to(helperText, 1.75, {x:((maxWidth - helperText.textWidth)/2), ease:Elastic.easeOut})
		}
		
		//Override to hide NavBar for a specific panel
		public override function isNavBarVisibleForThisPanel():Boolean { return true; }
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelHelp -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
		}
		
		public function onClickHelp(e:MouseEvent):void {
			try {
				var request:URLRequest = new URLRequest("http://getsatisfaction.com/pingfit");
                navigateToURL(request, "_blank");
            } catch (e:Error) {
                trace(e);
            }
		}
		


	}
	
}