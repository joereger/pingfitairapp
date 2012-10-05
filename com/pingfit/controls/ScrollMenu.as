package com.pingfit.controls {
	
	import gs.*;
	import gs.plugins.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	

	
	public class ScrollMenu extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var myMask:MovieClip;
		private var menuHolder:MovieClip;
		private var oldY:Number;
		private var mouseIsOver:Boolean;
		private var HOLDER_HEIGHT:Number;
		private var menuItems:Array;

		
		public function ScrollMenu(maxWidth:Number, maxHeight:Number) { 
			//trace("ScrollMenu instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			//Init the TweenPlugins
			TweenPlugin.activate([AutoAlphaPlugin,TintPlugin]);
			//Set up array for menuItems
			menuItems = new Array();
			//Create the mask
			myMask = new MovieClip();
			myMask.graphics.clear();
			myMask.graphics.beginFill(0x000000);
			myMask.graphics.drawRoundRect(0,0, maxWidth, maxHeight, 30);
			myMask.graphics.endFill();
			addChild(myMask);
			//Add the menuHolder to the stage
			menuHolder = new MovieClip();
			menuHolder.mask = myMask;
			addChild(menuHolder);
			//We want to know when the mouse is over the menuHolder
			mouseIsOver = false;
			//Add a listener when the mouse is over and out of the menuHolder
			menuHolder.addEventListener(MouseEvent.MOUSE_OVER, mouseOverMenu);
			menuHolder.addEventListener(MouseEvent.MOUSE_OUT, mouseOutMenu);
			//Add ENTER_FRAME for the menu animation
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ExercisePanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			menuHolder.y = 0;
			//Create the MenuItems for the menu.
			var currentY:Number = 0;
			var spacing:Number = 3;
			for (var i=0; i < menuItems.length; i++) {
				//Create a new MenuItem
				var menuItem:ScrollMenuItem = menuItems[i];
				//Position the item.
				//We will position the items from top to dowm.
				menuItem.x = 0;
				menuItem.y = currentY;
				//trace("menuItem["+i+"].x="+menuItem.x);
				//trace("menuItem["+i+"].y="+menuItem.y);
				currentY = menuItem.y + menuItem.height + spacing;
				//trace("currentY="+currentY);
			}
			//Save the menuHolder's height now that all the items have been added to it
			HOLDER_HEIGHT = menuHolder.height;
			//trace("menuHolder.height="+menuHolder.height);
		}
		
		public function addMenuItem(title:String, description:String, uniqueid:String):void{
			var menuItem:ScrollMenuItem = new ScrollMenuItem(maxWidth, 35, title, description, uniqueid);
			menuItem.addEventListener(MouseEvent.MOUSE_OVER, mouseOverItem);
			menuItem.addEventListener(MouseEvent.MOUSE_OUT, mouseOutItem);
			menuItem.addEventListener(MouseEvent.MOUSE_UP, mouseClickItem);
			menuItem.mouseChildren = false; //We don't want the text field to catch mouse events
			menuItem.buttonMode = true;
			menuHolder.addChild(menuItem);
			menuItems.push(menuItem);
			resize(maxWidth, maxHeight);
		}
		
		
		//This function is called when the mouse is over the menu
		function mouseOverMenu(e:Event):void {
			mouseIsOver = true;
		}
		 
		//This function is called when the mouse is out of the menu
		function mouseOutMenu(e:Event):void {
			mouseIsOver = false;
		}
		 
		//This function is called when the mouse is over an item
		function mouseOverItem(e:Event):void {
			//Save the item to a local variable
			var item:ScrollMenuItem = e.target as ScrollMenuItem;
			//Tween the item's fill color.
			//TweenMax.to(item.itemFill, 0.01, {tint: 0xff8800});
		}
		
		//This function is called when the mouse is over an item
		function mouseClickItem(e:Event):void {
			//Save the item to a local variable
			var item:ScrollMenuItem = e.target as ScrollMenuItem;
			trace("click on "+item.getTitle());
			dispatchEvent(e);
		}
		 
		//This function is called when mouse moves out of the item
		function mouseOutItem(e:Event):void {
			//Save the item to a local variable
			var item:ScrollMenuItem = e.target as ScrollMenuItem;
			//Tween the fill color to original state
			//TweenMax.to(item.itemFill, 0.5, {tint: 0x16222E});
		}
		 
		//This function is called in each frame
		function enterFrameHandler(e:Event):void {
			//Check if the mouse is over the menu
			if (mouseIsOver) {
				//Calculate the vertical distance of how far the mouse is from the top of the mask.
				var distance:Number = mouseY - myMask.y;
				//Calculate the distance in percentages
				var percentage:Number = distance / maxHeight;
				//Save the holder's old y coordinate
				oldY = menuHolder.y;
				//Calculate a new y target coordinate for the menuHolder.
				//We subtract the mask's height from the menuHolder.
				//Otherwise the menuHolder would move too far up when the mouse is at bottom.
				//Remove the subraction to see for yourself!
				var targetY:Number = -((HOLDER_HEIGHT - maxHeight) * percentage) + myMask.y;
				//trace("sending the menuHolder.y (targetY) -> "+targetY);
				//Tween the menuHolder to the target coordinate
				TweenMax.to(menuHolder, 0.4, {y: Math.round(targetY)});
			}
		}
	

	}
	
}