package com.pingfit.nav {
	

	import com.pingfit.events.*;
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
	import fl.controls.TextInput;
	import fl.controls.Button;
	import com.pingfit.data.static.CurrentUser;
	import com.pingfit.data.static.ExerciseLists;
	import com.pingfit.data.static.BigRefresh;
	import com.pingfit.data.objects.ExerciseList;
	import com.pingfit.events.*;
	import com.pingfit.alerts.*;
	
	
	public class NavPanelSettings extends NavPanelBase {
		
		private var workoutEverySlider:Slider;
		private var workoutEverySliderLabel:TextField;
		private var exerciseListsComboBox:ComboBox;
		private var withGroup:CheckBox;
		private var settings_title:TextField;
		private var bgColorButtons_label:TextField;
		private var bgColorButtons:BackgroundColorButtons;
		private var nick:TextInput;
		private var nick_label:TextField;
		private var nick_error:TextField;
		private var nick_button:Button;
		private var buttonSave:Button;
		private var startWithUserLogin:CheckBox;
	
		
		public function NavPanelSettings(maxWidth:Number, maxHeight:Number, navPanelType:String="Settings", navPanelName:String="Settings"){
			trace("NavPanelSettings instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		public override function initListener (e:Event):void {
			trace("NavPanelSettings.initListener() called");
			super.initListener(e);
			
			settings_title = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "Settings");
			settings_title.filters = Shadow.getDropShadowFilterArray(0x000000);
			settings_title.x = 30;
			settings_title.y = 20;
			addChild(settings_title);

			var withGroupFormat = TextUtil.getArial(12, 0xE6E6E6, true);
			withGroup = new CheckBox();
			withGroup.setStyle("textFormat", withGroupFormat);
			withGroup.label = "Exercise With Friends";
			withGroup.width = 300;
			withGroup.x = 30;
			withGroup.y = 100;
			withGroup.addEventListener(MouseEvent.CLICK, withGroupClicked);
			addChild(withGroup);
			
			
			try{
				var startWithUserLoginFormat = TextUtil.getArial(12, 0xE6E6E6, true);
				startWithUserLogin = new CheckBox();
				startWithUserLogin.setStyle("textFormat", startWithUserLoginFormat);
				startWithUserLogin.label = "Start Automatically With Computer";
				startWithUserLogin.width = 300;
				startWithUserLogin.x = 30;
				startWithUserLogin.y = 125;
				startWithUserLogin.addEventListener(MouseEvent.CLICK, startWithUserLoginClicked);
				addChild(startWithUserLogin);
			} catch (error:Error){trace("NavPanelSettings: "+error);}
			
			
			nick_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 250, "Nickname (as others will know you)");
			nick_label.x = 30;
			nick_label.y = 150;
			addChild(nick_label);
			nick = new TextInput();
			nick.x = 30;
			nick.y = 175;
			nick.width = 100;
			nick.maxChars = 15;
			addChild(nick);
			nick.addEventListener(Event.CHANGE, nickChanged);
			nick_button = new Button();
			nick_button.x = 140;
			nick_button.y = 175;
			nick_button.label = "Set";
			nick_button.width = 50;
			nick_button.addEventListener(MouseEvent.CLICK, setNick);
			addChild(nick_button);
			nick_error = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "Sorry, nickname already in use or not valid.");
			nick_error.x = 190;
			nick_error.y = 175;
			nick_error.alpha = 0;
			addChild(nick_error);
			
			
			
			bgColorButtons_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 250, "Background Color");
			bgColorButtons_label.x = 30;
			bgColorButtons_label.y = 200;
			addChild(bgColorButtons_label);
			bgColorButtons = new BackgroundColorButtons(200, 10);
			bgColorButtons.x = 30;
			bgColorButtons.y = 225;
			addChild(bgColorButtons);
			
			
			
			
			buttonSave = new Button();
			buttonSave.x = 30;
			buttonSave.y = maxHeight - 100;
			buttonSave.label = "Save Settings";
			buttonSave.width = 187;
			buttonSave.height = 75;
			buttonSave.addEventListener(MouseEvent.CLICK, buttonSaveClick);
			addChild(buttonSave);
		
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void {   
			
			if (CurrentUser.getUser().getExercisechooserid()==2){
				withGroup.selected = true;
			} else {
				withGroup.selected = false;
			}
			
			
			//Only display the slider if the user's not working out with the group
			trace("CurrentUser.getUser().getExercisechooserid()="+CurrentUser.getUser().getExercisechooserid());
			if (CurrentUser.getUser().getExercisechooserid()!=2){
				putNonFriendsStuffOntoScreen();
			} else {
				takeNonFriendsStuffOffScreen();
			}
			
			
			nick.text = CurrentUser.getUser().getNickname();
			
			try{
				if (NativeApplication.nativeApplication.startAtLogin){
					startWithUserLogin.selected = true;
				} else {
					startWithUserLogin.selected = false;
				}
			} catch (error:Error){trace("NavPanelSettings: "+error);}
			
		}
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelSettings -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
		}
		
		private function buttonSaveClick(e:MouseEvent):void {
            trace("NavPanelSettings.buttonSaveClick()");   
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Exercise"));
        }
		
		private function takeNonFriendsStuffOffScreen():void{
			if (workoutEverySlider!=null){ workoutEverySlider.visible = false; }
			if (workoutEverySliderLabel!=null){ workoutEverySliderLabel.visible = false; }
			if (exerciseListsComboBox!=null){ exerciseListsComboBox.visible = false; }
		}
		
		private function putNonFriendsStuffOntoScreen():void{
			var rigthColX:Number = 300;
			
			if (exerciseListsComboBox!=null){
				exerciseListsComboBox.visible = true;
			} else {
				exerciseListsComboBox = new ComboBox();
				exerciseListsComboBox.x = rigthColX;
				exerciseListsComboBox.y = 100;
				exerciseListsComboBox.setSize(250,22);
				var exerciselists:Array  = ExerciseLists.getExerciseLists();
				for each (var exerciselist:ExerciseList in exerciselists) {
					exerciseListsComboBox.addItem( { label: exerciselist.getName(), data:exerciselist.getExerciselistid()} );
					if (exerciselist.getExerciselistid() == CurrentUser.getUser().getExerciselistid()){
						exerciseListsComboBox.selectedIndex=exerciseListsComboBox.length-1;
					}
				}
				exerciseListsComboBox.addEventListener(Event.CHANGE, exerciseListsComboBoxChanged);
				addChild(exerciseListsComboBox);
			}
			if (workoutEverySlider!=null){
				workoutEverySlider.visible = true;
			} else {
				workoutEverySlider = new Slider();
				workoutEverySlider.direction = SliderDirection.HORIZONTAL;
				workoutEverySlider.width = 250;
				workoutEverySlider.minimum = 1;
				workoutEverySlider.maximum = 60;
				workoutEverySlider.value = CurrentUser.getUser().getExerciseeveryxminutes(); 
				workoutEverySlider.addEventListener(SliderEvent.CHANGE, workoutEverySliderChanged);
				workoutEverySlider.addEventListener(SliderEvent.THUMB_DRAG, workoutEverySliderDrag);
				workoutEverySlider.addEventListener(SliderEvent.THUMB_PRESS, workoutEverySliderPress);            
				workoutEverySlider.addEventListener(SliderEvent.THUMB_RELEASE, workoutEverySliderRelease);
				workoutEverySlider.x = rigthColX;
				workoutEverySlider.y = 150;
				addChild(workoutEverySlider);
			}
			if (workoutEverySliderLabel!=null){
				workoutEverySliderLabel.visible = true;
			} else {
				workoutEverySliderLabel = TextUtil.getTextField(TextUtil.getArial(9, 0xE6E6E6, true), 180, "Exercise every "+workoutEverySlider.value+" minutes");
				workoutEverySliderLabel.width = 180;
				workoutEverySliderLabel.height = 20;
				workoutEverySliderLabel.x =rigthColX;
				workoutEverySliderLabel.y = 130;
				addChild(workoutEverySliderLabel);
			}
			
		}
		
		private function exerciseListsComboBoxChanged(e:Event):void {
			trace("ComboBox changed: exerciseListsComboBox.selectedItem.data=" + exerciseListsComboBox.selectedItem.data);
			callSetExerciseList(exerciseListsComboBox.selectedItem.data);
        }
		
		private function withGroupClicked(e:MouseEvent):void {
			trace("SettingsPanel.withGroupClicked()");
			if (withGroup.selected){
				trace("SettingsPanel.withGroupClicked() withGroup.selected==true so setting exercisechooserid=2");
				//This value comes from a constant on the server side
				callSetExerciseChooser(2);
				//Take slider off screen
				takeNonFriendsStuffOffScreen();
				AlertCoordinator.newAlert("You've been switched to group mode.", "", null);
			} else {
				trace("SettingsPanel.withGroupClicked() withGroup.selected!=true so setting exercisechooserid=1");
				//This value comes from a constant on the server side
				callSetExerciseChooser(1);
				//Put slider onto screen
				putNonFriendsStuffOntoScreen();
				AlertCoordinator.newAlert("You've been switched to solo mode.", "", null);
			}
        }
		
		private function startWithUserLoginClicked(e:MouseEvent):void {
			trace("SettingsPanel.startWithUserLoginClicked()");
			if (startWithUserLogin.selected){
				trace("SettingsPanel.startWithUserLoginClicked() NativeApplication.nativeApplication.startAtLogin = true");
				NativeApplication.nativeApplication.startAtLogin = true;
			} else {
				trace("SettingsPanel.startWithUserLoginClicked() NativeApplication.nativeApplication.startAtLogin = false");
				NativeApplication.nativeApplication.startAtLogin = false;
			}
        }
		
		
		private function nickChanged(e:Event):void{
			trace("SettingsPanel.nickChanged()");
			nick_error.alpha = 0;
		}
		private function setNick(e:Event):void{
			trace("SettingsPanel.setNick()");
			nick_error.alpha = 0;
			callSetNickname(nick.text);
		}
		
		
		
		
		
		
		
		private function workoutEverySliderDrag(e:SliderEvent):void {
            trace("Slider dragging: " + e.target.value);
            workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes";     
        }
        private function workoutEverySliderPress(e:SliderEvent):void {
            trace("Slider pressed: " + e.target.value);
			workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes";     
        }
        private function workoutEverySliderRelease(e:SliderEvent):void {
			trace("Slider released: " + e.target.value);
            workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes";   
        }
        private function workoutEverySliderChanged(e:SliderEvent):void {
			trace("Slider changed: " + e.target.value);
            workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes"; 
			callSetExerciseEveryXMinutes();
        }
		

		private function callSetExerciseEveryXMinutes():void{
			trace("SettingsPanel.callSetExerciseEveryXMinutes called");
			var callSetExerciseEveryXMinutesAPI:CallSetExerciseEveryXMinutes = new CallSetExerciseEveryXMinutes(workoutEverySlider.value);
			callSetExerciseEveryXMinutesAPI.addEventListener(ApiCallSuccess.TYPE, callSetExerciseEveryXMinutesDone);
		}
		private function callSetExerciseEveryXMinutesDone(e:ApiCallSuccess):void{
			trace("SettingsPanel.callSetExerciseEveryXMinutesDone");
			BigRefresh.load(e.xmlData.bigrefresh[0]);
			Broadcaster.dispatchEvent(new PEvent(PEvent.CHANGEEXERCISEEVERYXMINUTES));
		}

	
		private function callSetExerciseList(exerciselistid:int):void{
			trace("SettingsPanel.callSetExerciseList called");
			var callSetExerciseListAPI:CallSetExerciseList = new CallSetExerciseList(exerciselistid);
			callSetExerciseListAPI.addEventListener(ApiCallSuccess.TYPE, callSetExerciseListDone);
		}
		private function callSetExerciseListDone(e:ApiCallSuccess):void{
			trace("SettingsPanel.callSetExerciseListDone");
			BigRefresh.load(e.xmlData.bigrefresh[0]);
			Broadcaster.dispatchEvent(new PEvent(PEvent.CHANGEEXERCISELIST));
		}
		
		private function callSetExerciseChooser(exercisechooserid:int):void{
			trace("SettingsPanel.callSetExerciseChooser called exercisechooserid="+exercisechooserid);
			var callSetExerciseChooserAPI:CallSetExerciseChooser = new CallSetExerciseChooser(exercisechooserid);
			callSetExerciseChooserAPI.addEventListener(ApiCallSuccess.TYPE, callSetExerciseChooserDone);
		}
		private function callSetExerciseChooserDone(e:ApiCallSuccess):void{
			trace("SettingsPanel.callSetExerciseChooserDone()");
			trace("SettingsPanel.callSetExerciseChooserDone() e.xmlData=\n"+e.xmlData);
			BigRefresh.load(e.xmlData.bigrefresh[0]);
			trace("SettingsPanel.callSetExerciseChooserDone() CurrentUser.getUser().getExercisechooserid()="+CurrentUser.getUser().getExercisechooserid());
			if (CurrentUser.getUser().getExercisechooserid()==1){
				Broadcaster.dispatchEvent(new PEvent(PEvent.SWITCHTOWORKOUTALONE));
			} else {
				Broadcaster.dispatchEvent(new PEvent(PEvent.SWITCHTOWORKOUTGROUP));
			}
		}
		
		private function callSetNickname(nickname:String):void{
			trace("SettingsPanel.callSetNickname called");
			var callSetNicknameAPI:CallSetNickname = new CallSetNickname(nickname);
			callSetNicknameAPI.addEventListener(ApiCallSuccess.TYPE, callSetNicknameDone);
			callSetNicknameAPI.addEventListener(ApiCallFail.TYPE, callSetNicknameError);
		}
		private function callSetNicknameDone(e:ApiCallSuccess):void{
			trace("SettingsPanel.callSetNicknameDone");
			trace(e.xmlData);
			if(e.xmlData.result.attribute("success") != "false"){
				nick_error.alpha = 1;
				nick_error.text = "Saved!";
				BigRefresh.load(e.xmlData.bigrefresh[0]);
			} else {
				nick_error.alpha = 1;
				nick_error.text = "Error: "+e.xmlData.result.apimessage;
			}
		}
		private function callSetNicknameError(e:ApiCallFail):void{
			trace("SettingsPanel.callSetNicknameError");
			nick_error.alpha = 1;
			nick_error.text = "Sorry, there was an unknown client-side error saving your nickname.";
		}


	}
	
}