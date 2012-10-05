package com.pingfit.controls
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
	import flash.events.MouseEvent;
	import com.pingfit.prefs.CPreferencesManager;


	public class Congrats extends Sprite {
		
		private var congratsText:TextField;
		private var factsText:TextField;
		private var mainText:TextField;
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var bg:MovieClip;
		private var roundDone48:RoundDone48;
		
		private static var congratsIndex:int = 0;
		private static var factsIndex:int = 0;
		private static var congrats:Array = new Array();
		private static var facts:Array = new Array();
		

		public function Congrats(maxWidth:Number, maxHeight:Number):void{
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			addEventListener(MouseEvent.MOUSE_OVER, onCongratsMouseOver); 
			addEventListener(MouseEvent.MOUSE_OUT, onCongratsMouseOut);
			
			congratsIndex = CPreferencesManager.getInt("pingFit.congratsIndex");
			factsIndex = CPreferencesManager.getInt("pingFit.factsIndex");
			
			
			bg = new MovieClip();
			bg.x = 50;
			addChild(bg);
			
			roundDone48 = new RoundDone48();
			roundDone48.x = 25;
			roundDone48.y = -15;
			addChild(roundDone48);
			
			congratsText = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), 160, "");
			congratsText.filters = Shadow.getDropShadowFilterArray(0x000000);
			congratsText.x = 70;
			congratsText.y = 5;
			congratsText.alpha = 1;
			addChild(congratsText);
			
			factsText = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), 310, "");
			factsText.filters = Shadow.getDropShadowFilterArray(0x000000);
			factsText.x = 230;
			factsText.y = 5;
			factsText.alpha = 1;
			addChild(factsText);
			
			nextCongrat();
			nextFact();
			
			
			resize(maxWidth, maxHeight);
		}
		

		public function nextCongrat():void{
			if (congrats==null || congrats.length==0){
				congrats = new Array();
				congrats.push("Good Job!");
				congrats.push("Excellent!");
				congrats.push("Great Job!");
				congrats.push("Yay!");
				congrats.push("You Rock!");
				congrats.push("Sweet!");
				congrats.push("UR GR8!");
				congrats.push("Gettin' Fit!");
				congrats.push("Rock On!");
			}
			congratsIndex = congratsIndex + 1;
			CPreferencesManager.setInt("pingFit.congratsIndex", congratsIndex);
			if (congratsIndex>(congrats.length-1)){ congratsIndex = 0; }
			congratsText.text = congrats[congratsIndex];
			resize(maxWidth, maxHeight);
		}
		
		public function nextFact():void{
			if (facts==null || facts.length==0){
				facts = new Array();
				facts.push("Not only does exercise improve your body, it helps your mental function.");
				facts.push("People who exercise experience less stress in every part of their life.");
				facts.push("When endorphins are released into your bloodstream during exercise you feel much more energized for the rest of the day.");
				facts.push("Recent U.S. government guidelines say that to lose weight and keep it weight off, you should accumulate at least 60 minutes of exercise a day.");
				facts.push("Research has shown that exercise can slow or help prevent heart disease, stroke, high blood pressure, high cholesterol, type 2 diabetes, arthritis, osteoporosis, and loss of muscle mass.");
				facts.push("Not only does exercise help fight disease, it creates a stronger heart -- the most important muscle in your body.");
				facts.push("Exercising helps your reaction time and balance.");
				facts.push("More than 60% of adults don't get the recommended amount of regular physical activity. Worse yet, 25% of all adults are not active at all!");
				facts.push("Did you know that for every 1 lb. Of muscle you gain, your body burns an extra 50 calories/day? If your burn off 5 lbs. of fat and 5 lbs. of muscle instead, you'd burn an extra 250 calories/day.");
				facts.push("Muscles are comprised of muscle fibres. Each fibre is thinner than a human hair and can support up to 1,000 times its weight.");
				facts.push("Use it or lose it. By age 65, people who haven't engaged in regular exercise may incur a decrease in their muscular strength level by as much as 80%!");
				facts.push("A muscle moves by contracting and by its motion, you move.  As a machine for moving, a muscle is pretty efficient, using about 35-50% of its potential energy.");
				facts.push("The human body has more than 650 muscles. ");
				facts.push("Your body has approximately 60,000 miles of blood vessels that not only oxygenate the tissues of the body and unburden them of waste, but also exact as stringent regulators of the body's environment.");
				facts.push("If you are 25 lbs. overweight, you have nearly 5,000 extra miles of blood vessels through which your heart must pump blood. ");
				facts.push("Your heart rests between each beat. Over a normal lifespan, your heart stands still for about 20 years.");
				facts.push("Your blood rushes through your arteries with enough pressure to lift a column of blood 5 feet into the air.");
				facts.push("71% of men admit that they should exercise more.");
				facts.push("Adults 18 and older need 30 minutes of physical activity on five or more days a week to be healthy; children and teens need 60 minutes of activity a day for their health.");
				facts.push("Heart disease is the leading cause of death among men and women in the United States. Physically inactive people are twice as likely to develop coronary heart disease as regularly active people.");
				facts.push("37% of adults report they are not physically active. Only 3 in 10 adults get the recommended amount of physical activity.");
				facts.push("Obesity continues to climb among American adults. Nearly 60 million Americans are obese. More than 108 million adults are either obese or overweight. That means roughly 3 out of 5 Americans carry an unhealthy amount of excess weight.");
				facts.push("Young people are at particular risk for becoming sedentary as they grow older. Encouraging moderate and vigorous physical activity among youth is important.");
				facts.push("The average child gets less than 15 minutes of vigorous activity a day.");
			}
			factsIndex = factsIndex + 1;
			CPreferencesManager.setInt("pingFit.factsIndex", factsIndex);
			if (factsIndex>(facts.length-1)){ factsIndex = 0; }
			factsText.text = facts[factsIndex];
			resize(maxWidth, maxHeight);
		}
		
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			trace("Congrats -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			var bgHeight:int = maxHeight;
			if ((congratsText.textHeight+10) > bgHeight){ bgHeight = (congratsText.textHeight+10);}
			if ((factsText.textHeight+10) > bgHeight){ bgHeight = (factsText.textHeight+10);}
			
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0, maxWidth-50, bgHeight, 30);
			bg.graphics.endFill();
			bg.alpha = .20;
		}
		
		
		private function onCongratsMouseOver(e:MouseEvent):void{
			bg.alpha = .35;
		}
		private function onCongratsMouseOut(e:MouseEvent):void{
			bg.alpha = .2;
		}
	}
}