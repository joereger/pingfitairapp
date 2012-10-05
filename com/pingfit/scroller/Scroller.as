package com.pingfit.scroller {
	

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import com.pingfit.chat.FriendInList;
	

	
	public class Scroller extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var myMask:MovieClip;
		private var itemContainer:MovieClip;
		private var mouseIsOver:Boolean;
		private var itemsInScroller:Array;
		private var spacing:int = 3;
		private var vertScrollerBar:ScrollerBar;
		private var horizScrollerBar:ScrollerBar;
		private var currentHeightOfStuff:Number = 0;
		private var currentWidthOfStuff:Number = 0;
		private var heightAndWidthOfScrollbars:Number = 10;
		private var autoScrollToBottomAfterItemAdd:Boolean = false;
	

		
		public function Scroller(maxWidth:Number, maxHeight:Number) { 
			//trace("Scroller instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			//Create the mask
			myMask = new MovieClip();
			myMask.graphics.clear();
			myMask.graphics.beginFill(0x000000);
			myMask.graphics.drawRect(0,0, maxWidth-heightAndWidthOfScrollbars, maxHeight-heightAndWidthOfScrollbars);
			myMask.graphics.endFill();
			addChild(myMask);
			//Add the container to the stage
			itemContainer = new MovieClip();
			itemContainer.mask = myMask;
			addChild(itemContainer);
			//Array to hold items
			itemsInScroller = new Array();
			//Vert scrollerbar
		 	vertScrollerBar = new ScrollerBar("vertical");
		 	vertScrollerBar.dragHandleColour = 0x333333;
	 	 	vertScrollerBar.sliderBarHeight = maxHeight;
		 	vertScrollerBar.sliderBarWidth = heightAndWidthOfScrollbars;
		 	vertScrollerBar.dragBarHeight = heightAndWidthOfScrollbars;
		 	vertScrollerBar.dragBarButtonMode = true;
		 	vertScrollerBar.x = maxWidth-heightAndWidthOfScrollbars;
		 	vertScrollerBar.y = 0;
			vertScrollerBar.visible = false;
		 	addChild(vertScrollerBar);
		 	vertScrollerBar.addEventListener(ScrollerBarEvent.SCROLL_CHANGE, vertScroll);
			//Horiz scrollerbar
		 	horizScrollerBar = new ScrollerBar("horizontal");
		 	horizScrollerBar.dragHandleColour = 0x333333;
	 	 	horizScrollerBar.sliderBarHeight = heightAndWidthOfScrollbars;
		 	horizScrollerBar.sliderBarWidth = maxWidth-heightAndWidthOfScrollbars;
		 	horizScrollerBar.dragBarHeight = heightAndWidthOfScrollbars;
		 	horizScrollerBar.dragBarButtonMode = true;
		 	horizScrollerBar.x = 0;
		 	horizScrollerBar.y = maxHeight-heightAndWidthOfScrollbars;
			horizScrollerBar.visible = false;
		 	addChild(horizScrollerBar);
		 	horizScrollerBar.addEventListener(ScrollerBarEvent.SCROLL_CHANGE, horizScroll);
		}
		
		
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("Scroller -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			//itemContainer.y = 0;
			currentHeightOfStuff = 0;
			currentWidthOfStuff = 0;
			for (var i=0; i < itemsInScroller.length; i++) {
				var itemInScroller:DisplayObject = itemsInScroller[i];
				//Position the items from top to dowm.
				itemInScroller.x = 0;
				itemInScroller.y = currentHeightOfStuff + spacing;
				//trace("itemInScroller["+i+"].x="+itemInScroller.x);
				//trace("itemInScroller["+i+"].y="+itemInScroller.y);
				currentHeightOfStuff = itemInScroller.y + itemInScroller.height;
				//trace("currentY="+currentY);
				if (itemInScroller.width>currentWidthOfStuff){
					currentWidthOfStuff = itemInScroller.width;
				}
			}
			if(currentHeightOfStuff > maxHeight-heightAndWidthOfScrollbars) {
				vertScrollerBar.visible = true;
			} else {
				vertScrollerBar.visible = false;
			}
			if(currentWidthOfStuff > maxWidth-heightAndWidthOfScrollbars) {
				horizScrollerBar.visible = true;
			} else {
				horizScrollerBar.visible = false;
			}
			if (autoScrollToBottomAfterItemAdd){
				vertScrollToPercent(1);
				vertScrollerBar.setScrollPercent(1, false, true);
			}
		}
		
		public function addItem(obj:DisplayObject):void{
			//trace("Scroller.addItem() called");
			itemContainer.addChild(obj);
			itemsInScroller.push(obj);
			//sort();
			resize(maxWidth, maxHeight);
		}
		
		
		
		public function removeItem(obj:DisplayObject):void{
			try{
				itemContainer.removeChild(obj);
			} catch (e:Error){
				trace(e);
			}
			try{
				for(var i=0; i<itemsInScroller.length; i++) {
				  try{	
					if(itemsInScroller[i]==obj) {
						 itemsInScroller.splice(i,1);
					} 
				  } catch (e:Error){
					trace(e);
				  }
				  //else if(itemsInScroller[i].length > 0) {
				  //	 itemsInScroller[i].remove(obj);
				  //}
			   }
			   //sort();
			} catch (e:Error){
				trace(e);
			}
			resize(maxWidth, maxHeight);
		}
		
		
		public function sort():void {
			trace("Scroller.sort() called");
			if (itemsInScroller!=null) {
				itemsInScroller.sort(sortByScrollerSortable);
				resize(maxWidth, maxHeight);
			}
		}
		
		private function sortByScrollerSortable(a, b):int {
			//trace("Scroller.sortByScrollerSortable() called");
			var aOrder:int = 0;
			if (a is ScrollerSortable) { 
				aOrder = ScrollerSortable(a).getOrder(); 
				//trace("Scroller.sortByScrollerSortable() aOrder is ScrollerSortable ScrollerSortable(a).getOrder()=" + ScrollerSortable(a).getOrder()); 
			} else { 
				//trace("Scroller.sortByScrollerSortable() aOrder NOT ScrollerSortable"); 
			}
			var bOrder:int = 0;
			if (b is ScrollerSortable) { bOrder = ScrollerSortable(b).getOrder(); }
			if (aOrder < bOrder) { 
				return 1; 
			} else if (aOrder > bOrder) { 
				return -1; 
			} else { 
				//Compare by name
				if (a is FriendInList && b is FriendInList) {
					var aName:String = FriendInList(a).getUser().getNickname();
					var bName:String = FriendInList(b).getUser().getNickname();
					//trace("aName="+aName+" bName="+bName);
					if (aName < bName) { 
						//trace("aName<bName");
						return -1; 
					} else if (aName > bName) { 
						return 1;
					}
					return 0;
				}
				//If one or the other isn't scroller sortable
				//if (!(a is ScrollerSortable) || !(b is ScrollerSortable)) {
				//	return -1;
				//}
				//Otherwise they're equal
				return 0; 
			} 
		}
		
		
		public function setSpacing(spacing:int):void{
			this.spacing = spacing;
		}
		
		public function setAutoScrollToBottomAfterItemAdd(autoScrollToBottomAfterItemAdd:Boolean):void{
			this.autoScrollToBottomAfterItemAdd = autoScrollToBottomAfterItemAdd;
		}
		
		public function vertScroll(event:ScrollerBarEvent):void {
			vertScrollToPercent(event.scrollPercent);
		}
		
		public function vertScrollToPercent(percent:Number):void {
			if (currentHeightOfStuff<=maxHeight-heightAndWidthOfScrollbars){ return; }
			var targetY:Number = (currentHeightOfStuff - maxHeight + (2*heightAndWidthOfScrollbars)) * percent;
			//trace("vertScroll to "+percent+"% -targetY="+(-targetY));
			itemContainer.y = -targetY;
		}
		
		public function horizScroll(event:ScrollerBarEvent):void {
			horizScrollToPercent(event.scrollPercent);
		}
		
		public function horizScrollToPercent(percent:Number):void {
			if (currentWidthOfStuff<=maxWidth-heightAndWidthOfScrollbars){ return; }
			var targetX:Number = (currentWidthOfStuff - maxWidth + (2*heightAndWidthOfScrollbars)) * percent;
			//trace("horizScroll to "+percent+"% -targetX="+(-targetX));
			itemContainer.x = -targetX;
		}
		
		public function getItemsInScroller():Array{
			return itemsInScroller;
		}
		 
		
	

	}
	
}