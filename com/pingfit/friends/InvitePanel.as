package com.pingfit.friends
{
	
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.display.*;
	import flash.events.*;
	import com.pingfit.xml.*;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import com.pingfit.data.objects.*;
	import com.pingfit.data.static.*;
	import com.pingfit.events.*;
	import com.pingfit.controls.*;
	import flash.events.*;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.Button;
	import flash.events.KeyboardEvent; 
	import flash.ui.Keyboard;
	

	public class InvitePanel extends MovieClip {
	
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var panelTitle:TextField;
		
		
		private var emailLabel:TextField;
		private var email_1:TextInput;
		private var email_2:TextInput;
		private var email_3:TextInput;
		private var email_4:TextInput;
		private var email_5:TextInput;
		private var customMsgLabel:TextField;
		private var customMsg:TextArea;
		private var inviteButton:Button;
		private var inviteStatus:TextField;
		
		private var betterWithFriendsIcon:BetterWithFriendsIcon;
		private var betterWithFriends:TextField;
		private var betterWithFriendsDetails:TextField;
		private var noSpamIcon:NoSpamIcon;
		private var noSpam:TextField;
		private var noSpamDetails:TextField;
		
		private var emailDefault:String = "Friend's Email Address";
		
		
		
		
		public function InvitePanel(maxWidth:Number, maxHeight:Number){
			//trace("InvitePanel instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		
		
		function initListener (e:Event):void {
			//trace("InvitePanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			panelTitle = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-100, "Invite Friends to Better Fitness!");
			panelTitle.filters = Shadow.getDropShadowFilterArray(0x000000);
			panelTitle.x = 30;
			panelTitle.y = 20;
			addChild(panelTitle);
			
			
			
			//emailLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 230, "Invite up to five friends at a time:");
			//emailLabel.x = 30;
			//emailLabel.y = 75;
			//addChild(emailLabel);
			
			email_1 = new TextInput();
			email_1.addEventListener(FocusEvent.FOCUS_IN, emailOnFocusIn);
			email_1.addEventListener(FocusEvent.FOCUS_OUT, emailOnFocusOut);
			email_1.width = 200;
			email_1.text = emailDefault;
			email_1.x = 30;
			email_1.y = 75;
			addChild(email_1);
			
			
			email_2 = new TextInput();
			email_2.addEventListener(FocusEvent.FOCUS_IN, emailOnFocusIn);
			email_2.addEventListener(FocusEvent.FOCUS_OUT, emailOnFocusOut);
			email_2.width = 200;
			email_2.text = emailDefault;
			email_2.x = 30;
			email_2.y = 100;
			addChild(email_2);
			
			email_3 = new TextInput();
			email_3.addEventListener(FocusEvent.FOCUS_IN, emailOnFocusIn);
			email_3.addEventListener(FocusEvent.FOCUS_OUT, emailOnFocusOut);
			email_3.width = 200;
			email_3.text = emailDefault;
			email_3.x = 30;
			email_3.y = 125;
			addChild(email_3);
			
			email_4 = new TextInput();
			email_4.addEventListener(FocusEvent.FOCUS_IN, emailOnFocusIn);
			email_4.addEventListener(FocusEvent.FOCUS_OUT, emailOnFocusOut);
			email_4.width = 200;
			email_4.text = emailDefault;
			email_4.x = 30;
			email_4.y = 150;
			addChild(email_4);
			
			email_5 = new TextInput();
			email_5.addEventListener(FocusEvent.FOCUS_IN, emailOnFocusIn);
			email_5.addEventListener(FocusEvent.FOCUS_OUT, emailOnFocusOut);
			email_5.width = 200;
			email_5.text = emailDefault;
			email_5.x = 30;
			email_5.y = 175;
			addChild(email_5);
			
			customMsgLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 200, "Custom Message from You (Optional):");
			customMsgLabel.x = 30;
			customMsgLabel.y = 225;
			addChild(customMsgLabel);
			
			customMsg = new TextArea();
			customMsg.text = "";
			customMsg.x = 30;
			customMsg.y = 250;
			customMsg.width = 200;
			customMsg.height = 90;
			addChild(customMsg);
			
			
			inviteButton = new Button();
			inviteButton.x = 30;
			inviteButton.y = 350;
			inviteButton.label = "Send Invitations";
			inviteButton.width = 150;
			inviteButton.addEventListener(MouseEvent.CLICK, inviteButtonClick);
			addChild(inviteButton);

			inviteStatus = TextUtil.getTextField(TextUtil.getHelveticaRounded(15, 0xE6E6E6, true), 150, "");
			inviteStatus.x = 30;
			inviteStatus.y = 375;
			addChild(inviteStatus);
			
			betterWithFriendsIcon = new BetterWithFriendsIcon();
			betterWithFriendsIcon.x = maxWidth - 138;
			betterWithFriendsIcon.y = 75;
			addChild(betterWithFriendsIcon);
			
			betterWithFriends = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), 150, "It's Better with Friends");
			betterWithFriends.filters = Shadow.getDropShadowFilterArray(0x000000);
			betterWithFriends.x = 290;
			betterWithFriends.y = 75;
			addChild(betterWithFriends);
			
			betterWithFriendsDetails = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 130, "Keep each other on track.  Chat together in private rooms.  Compare exercise lists.");
			betterWithFriendsDetails.filters = Shadow.getDropShadowFilterArray(0x000000);
			betterWithFriendsDetails.x = 290;
			betterWithFriendsDetails.y = betterWithFriends.y + betterWithFriends.textHeight + 5;
			addChild(betterWithFriendsDetails);
			
			noSpamIcon = new NoSpamIcon();
			noSpamIcon.x = maxWidth - 138;
			noSpamIcon.y = 200;
			addChild(noSpamIcon);
			
			noSpam = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), 150, "We Don't Spam");
			noSpam.filters = Shadow.getDropShadowFilterArray(0x000000);
			noSpam.x = 290;
			noSpam.y = 200;
			addChild(noSpam);
			
			noSpamDetails = TextUtil.getTextField(TextUtil.getHelveticaRounded(12, 0xE6E6E6, true), 130, "We won't spam your friend.  We send a single invitation email.  It's a very simple email with a link to the site.");
			noSpamDetails.filters = Shadow.getDropShadowFilterArray(0x000000);
			noSpamDetails.x = 290;
			noSpamDetails.y = noSpam.y + noSpam.textHeight + 5;
			addChild(noSpamDetails);
		
			
			resize(maxWidth, maxHeight);
		}


		

		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("InvitePanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;

		}
		
		
		private function emailOnFocusIn(e:FocusEvent){
			if (e.target.text == emailDefault) {
				e.target.text = "";
			}
		}
		
		private function emailOnFocusOut(e:FocusEvent){
			if (e.target.text.length==0) {
				e.target.text = emailDefault;
			}
		}
		
		
		private function inviteButtonClick(e:MouseEvent) {
            trace("InvitePanel.inviteButtonClick()");
			disableFormElements();
			if (email_1.text != "" && email_1.text != emailDefault) { var caller_1:CallInviteByEmail = new CallInviteByEmail(email_1.text, customMsg.text); email_1.text = ""; }
			if (email_2.text != "" && email_2.text != emailDefault) { var caller_2:CallInviteByEmail = new CallInviteByEmail(email_2.text, customMsg.text); email_2.text = ""; }
			if (email_3.text != "" && email_3.text != emailDefault) { var caller_3:CallInviteByEmail = new CallInviteByEmail(email_3.text, customMsg.text); email_3.text = ""; }
			if (email_4.text != "" && email_4.text != emailDefault) { var caller_4:CallInviteByEmail = new CallInviteByEmail(email_4.text, customMsg.text); email_4.text = ""; }
			if (email_5.text != "" && email_5.text != emailDefault) { var caller_5:CallInviteByEmail = new CallInviteByEmail(email_5.text, customMsg.text); email_5.text = ""; }
			inviteStatus.text = "Your invitations are being sent!  Now you can invite more friends... or get back to exercising!";
			enableFormElements();
		}
		
		private function disableFormElements():void {
			email_1.enabled = false;
			email_2.enabled = false;
			email_3.enabled = false;
			email_4.enabled = false;
			email_5.enabled = false;
			customMsg.enabled = false;
			inviteButton.enabled = false;
		}
		
		private function enableFormElements():void {
			email_1.enabled = true;
			email_2.enabled = true;
			email_3.enabled = true;
			email_4.enabled = true;
			email_5.enabled = true;
			customMsg.enabled = true;
			inviteButton.enabled = true;
		}
		
		
		
		
		
	}

	
	
}