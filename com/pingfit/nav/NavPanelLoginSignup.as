package com.pingfit.nav {
	

	import com.pingfit.controls.FacebookConnectButton;
	import lt.uza.utils.*;
	import flash.events.Event;
	import flash.text.*;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.text.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import fl.controls.TextInput;
	import fl.controls.Button;
	import com.pingfit.xml.*;
	import com.pingfit.format.TextUtil;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.prefs.CPreferencesManager;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.data.static.BigRefresh;
	import com.pingfit.data.static.NetConn;
	import com.pingfit.data.static.FriendsFacebook;
	import com.pingfit.data.static.CurrentPl;
	import com.pingfit.events.*;
	import com.pingfit.facebook.FbSession;
	
	
	
	
	
	public class NavPanelLoginSignup extends NavPanelBase {
		
		private var login_title:TextField;
		private var signup_title:TextField;
		
		private var login_fb_title:TextField;
		private var with_facebook_label:TextField;
		private var facebookConnectButton:FacebookConnectButton;
		
		private var login_email:TextInput;
		private var login_email_label:TextField;
		private var login_password:TextInput;
		private var login_password_label:TextField;
		private var signup_first:TextInput;
		private var signup_first_label:TextField;
		private var signup_last:TextInput;
		private var signup_last_label:TextField;
		private var signup_nick:TextInput;
		private var signup_nick_label:TextField;
		private var signup_email:TextInput;
		private var signup_email_label:TextField;
		private var signup_password:TextInput;
		private var signup_password_label:TextField;
		private var signup_passwordverify:TextInput;
		private var signup_passwordverify_label:TextField;
		private var advanced_toggle:TextField;
		private var advanced_baseurl_label:TextField;
		private var advanced_baseurl:TextInput;
		private var advanced_baseurlred5_label:TextField;
		private var advanced_baseurlred5:TextInput;
		private var advanced_ishot:Boolean = false;
		
		
		private var global:Global = Global.getInstance();
		private var flashVarsDebug:TextField;
		
		private var login_error:TextField;
		private var signup_error:TextField;
		
		private var login_button:Button;
		private var signup_button:Button;
		
		
		
		
		public function NavPanelLoginSignup(maxWidth:Number, maxHeight:Number, navPanelType:String="LoginSignup", navPanelName:String="LoginSignup"){
			trace("NavPanelLoginSignup instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
	
		
		
		public override function initListener (e:Event):void {
			trace("NavPanelLoginSignup.initListener() called");
			super.initListener(e);
			Broadcaster.addEventListener(PEvent.FACEBOOKCONNECTSUCCESS, onFacebookConnect);
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void { 
			//Make sure the conn is dead
			NetConn.killConn();
			//Auto-trigger login if email/pass are present
			if (ApiParams.getEmail()!=null && ApiParams.getEmail().length>0 && ApiParams.getPassword()!=null && ApiParams.getPassword().length>0){
				autoLoginAttempt();
			} else {
				putFormsOnStage();
			}
			enableLoginForm();
			enableSignupForm();
		}
		
		//Override to hide NavBar for a specific panel
		public override function isNavBarVisibleForThisPanel():Boolean { return false; }
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			trace("NavPanelLoginSignup -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
		}
		
		private function removeEverythingFromStage():void {
			if (login_title != null) { removeChild(login_title); login_title = null; }
			if (login_email_label != null) { removeChild(login_email_label); login_email_label = null; }
			if (login_email != null) { removeChild(login_email); login_email = null; }
			if (login_password_label != null) { removeChild(login_password_label); login_password_label = null; }
			if (login_password != null) { removeChild(login_password); login_password = null; }
			if (login_button != null) { removeChild(login_button); login_button = null; }
			if (login_error != null) { removeChild(login_error); login_error = null; }
			if (advanced_baseurl_label != null) { removeChild(advanced_baseurl_label); advanced_baseurl_label = null; }
			if (advanced_baseurl != null) { removeChild(advanced_baseurl); advanced_baseurl = null; }
			if (advanced_baseurlred5_label != null) { removeChild(advanced_baseurlred5_label); advanced_baseurlred5_label = null; }
			if (advanced_baseurlred5 != null) { removeChild(advanced_baseurlred5); advanced_baseurlred5 = null; }
			if (advanced_toggle != null) { removeChild(advanced_toggle); advanced_toggle = null; }
			if (signup_title != null) { removeChild(signup_title); signup_title = null; }
			if (signup_first_label != null) { removeChild(signup_first_label); signup_first_label = null; }
			if (signup_first != null) { removeChild(signup_first); signup_first = null; }
			if (signup_last_label != null) { removeChild(signup_last_label); signup_last_label = null; }
			if (signup_last != null) { removeChild(signup_last); signup_last = null; }
			if (signup_nick_label != null) { removeChild(signup_nick_label); signup_nick_label = null; }
			if (signup_nick != null) { removeChild(signup_nick); signup_nick = null; }
			if (signup_email_label != null) { removeChild(signup_email_label); signup_email_label = null; }
			if (signup_email != null) { removeChild(signup_email); signup_email = null; }
			if (signup_password_label != null) { removeChild(signup_password_label); signup_password_label = null; }
			if (signup_password != null) { removeChild(signup_password); signup_password = null; }
			if (signup_passwordverify_label != null) { removeChild(signup_passwordverify_label); signup_passwordverify_label = null; }
			if (signup_passwordverify != null) { removeChild(signup_passwordverify); signup_passwordverify = null; }
			if (signup_button != null) { removeChild(signup_button); signup_button = null; }
			if (signup_error != null) { removeChild(signup_error); signup_error = null; }
			if (login_fb_title != null) { removeChild(login_fb_title); login_fb_title = null; }
			if (with_facebook_label != null) { removeChild(with_facebook_label); with_facebook_label = null; }
		}
		
		public function putFormsOnStage():void{
			removeEverythingFromStage();
			
			var leftColX:Number = (((maxWidth / 2) - 150) / 2) - 50;
			var centerColX:Number = (maxWidth / 2) - 100;
			var rightColX:Number = (maxWidth / 2) + ( ((maxWidth / 2) - 225) / 2 ) + 40;
			
			var flashVarsDebugTxt:String = "global.debug="+ global.debug + " :: global.allKeyValuePairs=" + global.allKeyValuePairs + " :: ";
			try {
				flashVarsDebugTxt = flashVarsDebugTxt + " global.argumentsBrowserInvoke=" + global.argumentsBrowserInvoke;
				flashVarsDebugTxt = flashVarsDebugTxt + " CurrentPl.getPl().getPlid()=" + CurrentPl.getPl().getPlid();
				//flashVarsDebugTxt = flashVarsDebugTxt + " global.plid=" + global.plid;
				//flashVarsDebugTxt = flashVarsDebugTxt + " global.refid=" + global.refid;
			} catch (error:Error) {
				 flashVarsDebugTxt = flashVarsDebugTxt + " error=" + error.toString() + " " + error.getStackTrace(); 
			}
			flashVarsDebug = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 600, flashVarsDebugTxt);
			flashVarsDebug.x = 50;
			flashVarsDebug.y = 20;
			//addChild(flashVarsDebug);
		

			login_title = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), 200, "Log In");
			login_title.x = leftColX;
			login_title.y = 75;
			addChild(login_title);
			
			login_email_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "Email Address");
			login_email_label.x = leftColX;
			login_email_label.y = 130;
			addChild(login_email_label);
			login_email = new TextInput();
			login_email.text = ApiParams.getEmail();
			login_email.x = leftColX;
			login_email.y = 150;
			login_email.width = 150;
			addChild(login_email);

			login_password_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "Password");
			login_password_label.x = leftColX;
			login_password_label.y = 180;
			addChild(login_password_label);
			login_password = new TextInput();
			login_password.displayAsPassword = true;
			login_password.text = ApiParams.getPassword();
			login_password.x = leftColX;
			login_password.y = 200;
			login_password.width = 150;
			addChild(login_password);
			
			login_button = new Button();
			login_button.x = leftColX;
			login_button.y = 250;
			login_button.label = "Log In";
			login_button.width = 150;
			login_button.addEventListener(MouseEvent.CLICK, loginButtonClick);
			addChild(login_button);
			

			login_error = TextUtil.getTextField(TextUtil.getArial(13, 0xE6E6E6, true), 250, "");
			login_error.x = leftColX;
			login_error.y = 280;
			addChild(login_error);
			
			
			advanced_baseurl_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 250, "Server API URL");
			advanced_baseurl_label.x = leftColX;
			advanced_baseurl_label.y = 280;
			advanced_baseurl_label.alpha = 0;
			addChild(advanced_baseurl_label);
			advanced_baseurl = new TextInput();
			advanced_baseurl.text = ApiParams.getBaseurl();
			advanced_baseurl.x = leftColX;
			advanced_baseurl.y = 300;
			advanced_baseurl.alpha = 0;
			addChild(advanced_baseurl);
			
			advanced_baseurlred5_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 250, "Chat Server API URL");
			advanced_baseurlred5_label.x = leftColX;
			advanced_baseurlred5_label.y = 330;
			advanced_baseurlred5_label.alpha = 0;
			addChild(advanced_baseurlred5_label);
			advanced_baseurlred5 = new TextInput();
			advanced_baseurlred5.text = ApiParams.getBaseurlred5();
			advanced_baseurlred5.x = leftColX;
			advanced_baseurlred5.y = 350;
			advanced_baseurlred5.alpha = 0;
			addChild(advanced_baseurlred5);
			
			advanced_toggle = TextUtil.getTextField(TextUtil.getHelveticaRounded(8, 0x666666, true), 100, "Advanced");
			advanced_toggle.x = leftColX;
			advanced_toggle.y = 375;
			advanced_toggle.addEventListener(MouseEvent.CLICK, advancedToggleClick);
			addChild(advanced_toggle);
			
			
			
			login_fb_title = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), 200, "Log In");
			login_fb_title.x = centerColX;
			login_fb_title.y = 75;
			addChild(login_fb_title);
			
			with_facebook_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 200, "with Facebook");
			with_facebook_label.x = centerColX;
			with_facebook_label.y = 120;
			addChild(with_facebook_label);
			
			facebookConnectButton = new FacebookConnectButton();
			facebookConnectButton.x = centerColX;
			facebookConnectButton.y = 149;
			facebookConnectButton.addEventListener(MouseEvent.CLICK, onClickFacebookConnect);
			addChild(facebookConnectButton);
			
			

			signup_title = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), 200, "Sign Up");
			signup_title.x = rightColX;
			signup_title.y = 75;
			addChild(signup_title);
			

			signup_first_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "First Name");
			signup_first_label.x = rightColX;
			signup_first_label.y = 130;
			addChild(signup_first_label);
			signup_first = new TextInput();
			signup_first.text = "";
			signup_first.x = rightColX;
			signup_first.y = 150;
			addChild(signup_first);
			

			signup_last_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "Last Name");
			signup_last_label.x = rightColX + 125;
			signup_last_label.y = 130;
			addChild(signup_last_label);
			signup_last = new TextInput();
			signup_last.text = "";
			signup_last.x = rightColX + 125;
			signup_last.y = 150;
			addChild(signup_last);
			
			
			signup_nick_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 250, "Nickname (as others will know you)");
			signup_nick_label.x = rightColX;
			signup_nick_label.y = 180;
			addChild(signup_nick_label);
			signup_nick = new TextInput();
			signup_nick.text = "";
			signup_nick.x = rightColX;
			signup_nick.y = 200;
			signup_nick.maxChars = 15;
			signup_nick.width = 225;
			addChild(signup_nick);
			

			signup_email_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "Email Address");
			signup_email_label.x = rightColX;
			signup_email_label.y = 230;
			addChild(signup_email_label);
			signup_email = new TextInput();
			signup_email.text = "";
			signup_email.x = rightColX;
			signup_email.y = 250;
			signup_email.width = 225;
			addChild(signup_email);
			

			signup_password_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "Password");
			signup_password_label.x = rightColX;
			signup_password_label.y = 280;
			addChild(signup_password_label);
			signup_password = new TextInput();
			signup_password.displayAsPassword = true;
			signup_password.text = "";
			signup_password.x = rightColX;
			signup_password.y = 300;
			addChild(signup_password);
			

			signup_passwordverify_label = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 100, "Verify Password");
			signup_passwordverify_label.x = rightColX + 125;
			signup_passwordverify_label.y = 280;
			addChild(signup_passwordverify_label);
			signup_passwordverify = new TextInput();
			signup_passwordverify.displayAsPassword = true;
			signup_passwordverify.text = "";
			signup_passwordverify.x = rightColX + 125;
			signup_passwordverify.y = 300;
			addChild(signup_passwordverify);
			
			signup_button = new Button();
			signup_button.x = rightColX;
			signup_button.y = 350;
			signup_button.label = "Sign Up";
			signup_button.width = 150;
			signup_button.addEventListener(MouseEvent.CLICK, signupButtonClick);
			addChild(signup_button);

			signup_error = TextUtil.getTextField(TextUtil.getArial(12, 0xE6E6E6, true), 250, "");
			signup_error.x = rightColX;
			signup_error.y = 380;
			addChild(signup_error);
		
		}
		
		
		
		private function advancedToggleClick(e:MouseEvent) {
            trace("Advanced clicked");
			var myGroup:TweenGroup = new TweenGroup();
			if (!advanced_ishot){
				advanced_ishot = true;
				myGroup.align = TweenGroup.ALIGN_START;
				myGroup.push(TweenLite.to(advanced_baseurl_label, 3, {alpha:1}));
				myGroup.push(TweenLite.to(advanced_baseurl, 3, {alpha:1}));
				myGroup.push(TweenLite.to(advanced_baseurlred5_label, 3, {alpha:1}));
				myGroup.push(TweenLite.to(advanced_baseurlred5, 3, {alpha:1}));
			} else {
				advanced_ishot = false;
				myGroup.align = TweenGroup.ALIGN_START;
				myGroup.push(TweenLite.to(advanced_baseurl_label, 3, {alpha:0}));
				myGroup.push(TweenLite.to(advanced_baseurl, 3, {alpha:0}));
				myGroup.push(TweenLite.to(advanced_baseurlred5_label, 3, {alpha:0}));
				myGroup.push(TweenLite.to(advanced_baseurlred5, 3, {alpha:0}));
			}
        }
		
		private function autoLoginAttempt(){
			var apiParams:ApiParams = new ApiParams();
			apiParams.addEventListener(ApiParams.PASS, autoLoginSuccess);
			apiParams.addEventListener(ApiParams.FAIL, autoLoginFail);
			apiParams.testApiParams();
			//Facebook autologin test
			
		}
		
		private function autoLoginSuccess(e:Event):void{
			trace("autoLoginPass()");
			Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, loginBigRefreshDone);
			BigRefresh.refreshViaAPI();
		}
		
		private function autoLoginFail(e:Event):void{
			trace("autoLoginFail()");
			putFormsOnStage();
		}
		
		private function loginButtonClick(e:MouseEvent) {
            trace("Log In clicked");
			login_email_label.alpha = .5;
			login_password_label.alpha = .5;
			login_email.enabled = false;
			login_password.enabled = false;
			login_button.enabled = false;
			login_error.text = "";
			
			ApiParams.setEmail(login_email.text);
			ApiParams.setPassword(login_password.text);
			ApiParams.setBaseurl(advanced_baseurl.text);
			ApiParams.setBaseurlred5(advanced_baseurlred5.text);
			
			CPreferencesManager.setPreference("pingfit.email", login_email.text);
			CPreferencesManager.setPreference("pingfit.password", login_password.text);
			CPreferencesManager.setPreference("pingfit.baseurl", advanced_baseurl.text);
			CPreferencesManager.setPreference("pingfit.baseurlred5", advanced_baseurlred5.text);
			
			var apiParams:ApiParams = new ApiParams();
			apiParams.addEventListener(ApiParams.PASS, loginSuccess);
			apiParams.addEventListener(ApiParams.FAIL, loginFail);
			apiParams.testApiParams();
			
        }
		
		private function loginSuccess(e:Event):void{
			trace("loginPass()");
			Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, loginBigRefreshDone);
			BigRefresh.refreshViaAPI();
		}
		
		private function loginFail(e:Event):void{
			trace("loginFail()");
			enableLoginForm();
			login_error.text = "Sorry, we weren't able to log you on.  Are you connected to the internet?";
		}
		
		private function enableLoginForm():void {
			if (login_email_label == null) { return; }
			login_email_label.alpha = 1;
			login_password_label.alpha = 1;
			login_email.enabled = true;
			login_password.enabled = true;
			login_button.enabled = true;
		}
		
		
		private function loginBigRefreshDone(e:PEvent):void{
			trace("loginBigRefreshDone()");
			NetConn.killConn();
			Broadcaster.removeEventListener(PEvent.BIGREFRESHDONE, loginBigRefreshDone);
			Broadcaster.dispatchEvent(new PEvent(PEvent.LOGIN));
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Eula"));
		}
		
		
		
		//-------------------facebook start
		
		//User clicked to connect with facebook connect
		private function onClickFacebookConnect(e:MouseEvent):void {
            trace("NavPanelRoom.onClickFacebookConnect()");  
			FbSession.init();
        }
		
		//Yay... it worked... we're connected with facebookconnect
		private function onFacebookConnect(e:PEvent):void{
			trace("onFacebookConnect()");
			var callGetLoggedInUser:CallGetLoggedInUser = new CallGetLoggedInUser();
			callGetLoggedInUser.addEventListener(ApiCallSuccess.TYPE, onFbConnGetUserSuccess);
			callGetLoggedInUser.addEventListener(ApiCallFail.TYPE, onFbConnGetUserFail);
		}
		
		//The user already existed on the server
		private function onFbConnGetUserSuccess(e:ApiCallSuccess):void{
			trace("NavPanelLoginSignup.onFbConnGetUserSuccess()");
			//trace("CallGetLoggedInUser was successful... e.xmlData=" + e.xmlData);
			var callAddFriendsByFacebookuid:CallAddFriendsByFacebookuid = new CallAddFriendsByFacebookuid(FriendsFacebook.getFriendsAsCommaSepString());
			callAddFriendsByFacebookuid.addEventListener(ApiCallSuccess.TYPE, callAddFriendsByFacebookuidFromLoginSuccess);
			callAddFriendsByFacebookuid.addEventListener(ApiCallFail.TYPE, callAddFriendsByFacebookuidFromLoginError);
		}
		private function callAddFriendsByFacebookuidFromLoginError(e:ApiCallFail):void{
			trace("callAddFriendsByFacebookuidFromLoginError() "+e.xmlData.result.apimessage);
			//signupFail("Sorry, a problem occurred: "+e.xmlData.result.apimessage);
			fbLoginStuffDone();
		}
		private function callAddFriendsByFacebookuidFromLoginSuccess(e:ApiCallSuccess):void{
			trace("callAddFriendsByFacebookuidFromLoginSuccess()");
			fbLoginStuffDone();		
		}
		private function fbLoginStuffDone():void {
			Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, loginBigRefreshDone);
			BigRefresh.refreshViaAPI();
		}
		
		//The user did not already exist on the server or login failed
		private function onFbConnGetUserFail(e:ApiCallFail):void{
			trace("NavPanelLoginSignup.onFbConnGetUserFail() - ");
			trace("NavPanelLoginSignup.onFbConnGetUserFail() - CallGetLoggedInUser was FAIL... e.xmlData=" + e.xmlData);
			if (e.errorcode=="FACEBOOKAUTHFAILSESSIONKEYINVALID") {
				trace("NavPanelLoginSignup.onFbConnGetUserFail() - errorcode says session_key not valid so will FbSession.logout()");
				FbSession.logout();
			} else if (e.errorcode=="FACEBOOKAUTHFAILFACEBOOKUIDNOTFOUND") {
				trace("NavPanelLoginSignup.onFbConnGetUserFail() - errorcode says facebookuid not found");
				createUserFromFacebookuid();
			} else {
				trace("NavPanelLoginSignup.onFbConnGetUserFail() - unknown errorcode="+e.errorcode);
			}
		}
		private function createUserFromFacebookuid():void {
			trace("NavPanelLoginSignup.createUserFromFacebookuid() - will create user, FbSession.getFacebookUser().name: "+FbSession.getFacebookUser().name);
			var callSignUp:CallSignUp = new CallSignUp("", "", "", FbSession.getFacebookUser().first_name, FbSession.getFacebookUser().last_name, FbSession.getFacebookUser().name, com.pingfit.data.static.CurrentPl.getPl().getPlid());
			callSignUp.addEventListener(ApiCallSuccess.TYPE, signupFbApiCallDone);
			callSignUp.addEventListener(ApiCallFail.TYPE, signupFbApiCallError);
		}
		private function signupFbApiCallError(e:ApiCallFail):void{
			trace("signupFbApiCallError()");
			signupFail("Sorry, a problem occurred: "+e.xmlData.result.apimessage);
		}
		private function signupFbApiCallDone(e:ApiCallSuccess):void{
			trace("signupFbApiCallDone()");
			//trace(e.xmlData);
			var callAddFriendsByFacebookuid:CallAddFriendsByFacebookuid = new CallAddFriendsByFacebookuid(FriendsFacebook.getFriendsAsCommaSepString());
			callAddFriendsByFacebookuid.addEventListener(ApiCallSuccess.TYPE, callAddFriendsByFacebookuidFromSignupSuccess);
			callAddFriendsByFacebookuid.addEventListener(ApiCallFail.TYPE, callAddFriendsByFacebookuidFromSignupError);
		}
		private function callAddFriendsByFacebookuidFromSignupError(e:ApiCallFail):void{
			trace("callAddFriendsByFacebookuidFromSignupError() "+e.xmlData.result.apimessage);
			//signupFail("Sorry, a problem occurred: "+e.xmlData.result.apimessage);
			fbSignupStuffDone();
		}
		private function callAddFriendsByFacebookuidFromSignupSuccess(e:ApiCallSuccess):void{
			trace("callAddFriendsByFacebookuidFromSignupSuccess()");
			fbSignupStuffDone();		
		}
		private function fbSignupStuffDone():void {
			Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, signupBigRefreshDone);
			BigRefresh.refreshViaAPI();
		}
		//----------------------facebook end

		
		
		
		
		
		
		private function signupButtonClick(e:MouseEvent) {
            trace("Sign Up clicked");
			signup_error.text = "";
			signup_first.enabled = false;
			signup_first_label.alpha = .5;
			signup_last.enabled = false;
			signup_last_label.alpha = .5;
			signup_email.enabled = false;
			signup_email_label.alpha = .5;
			signup_password.enabled = false;
			signup_password_label.alpha = .5;
			signup_passwordverify.enabled = false;
			signup_passwordverify_label.alpha = .5;
			signup_button.enabled = false;
			signup_nick.enabled = false;
			signup_nick_label.alpha = .5;

			ApiParams.setBaseurl(advanced_baseurl.text);
			ApiParams.setBaseurlred5(advanced_baseurlred5.text);
			
			CPreferencesManager.setPreference("pingfit.baseurl", advanced_baseurl.text);
			CPreferencesManager.setPreference("pingfit.baseurlred5", advanced_baseurlred5.text);

			var callSignUp:CallSignUp = new CallSignUp(signup_email.text, signup_password.text, signup_passwordverify.text, signup_first.text, signup_last.text, signup_nick.text, com.pingfit.data.static.CurrentPl.getPl().getPlid());
			callSignUp.addEventListener(ApiCallSuccess.TYPE, signupApiCallDone);
			callSignUp.addEventListener(ApiCallFail.TYPE, signupApiCallError);
        }
		
		private function signupApiCallDone(e:ApiCallSuccess):void{
			trace("signupApiCallDone()");
			trace(e.xmlData);
			signupSuccess();
		}
		
		private function signupApiCallError(e:ApiCallFail):void{
			trace("signupApiCallError()");
			signupFail("Sorry, a problem occurred: "+e.xmlData.result.apimessage);
		}
		
		private function signupFail(errorTxt:String):void{
			trace("signupFail()");
			signup_error.text = errorTxt;
			enableSignupForm();
		}
		
		private function enableSignupForm():void {
			if (signup_first == null) { return; }
			signup_first.enabled = true;
			signup_first_label.alpha = 1;
			signup_last.enabled = true;
			signup_last_label.alpha = 1;
			signup_email.enabled = true;
			signup_email_label.alpha = 1;
			signup_password.enabled = true;
			signup_password_label.alpha = 1;
			signup_passwordverify.enabled = true;
			signup_passwordverify_label.alpha = 1;
			signup_button.enabled = true;
			signup_nick.enabled = true;
			signup_nick_label.alpha = 1;
		}
		
		private function signupSuccess():void{
			trace("signupSuccess()");
			ApiParams.setEmail(signup_email.text);
			ApiParams.setPassword(signup_password.text);
			CPreferencesManager.setPreference("pingfit.email", signup_email.text);
			CPreferencesManager.setPreference("pingfit.password", signup_password.text);
			CPreferencesManager.setPreference("pingfit.baseurl", advanced_baseurl.text);
			var apiParams:ApiParams = new ApiParams();
			apiParams.addEventListener(ApiParams.PASS, signupApiParamsSuccess);
			apiParams.addEventListener(ApiParams.FAIL, signupApiParamsFail);
			apiParams.testApiParams();
		}
		
		
		private function signupApiParamsSuccess(e:Event):void{
			trace("signupApiParamsSuccess()");
			Broadcaster.addEventListener(PEvent.BIGREFRESHDONE, signupBigRefreshDone);
			BigRefresh.refreshViaAPI();
		}
		
		private function signupApiParamsFail(e:Event):void{
			trace("signupApiParamsFail()");
			signupFail("Sorry, a problem occurred.  Please try to log in.  If that fails please close the application and try to sign up again.");
		}
		
	
		private function signupBigRefreshDone(e:PEvent):void{
			trace("signupBigRefreshDone()");
			NetConn.killConn();
			Broadcaster.removeEventListener(PEvent.BIGREFRESHDONE, signupBigRefreshDone);
			Broadcaster.dispatchEvent(new PEvent(PEvent.SIGNUP)); 
			Broadcaster.dispatchEvent(new PEvent(PEvent.LOGIN));
			Broadcaster.dispatchEvent(new TurnOnNavPanel("Eula"));
		}
		
		
		
		
		
		
		


	}
	
}