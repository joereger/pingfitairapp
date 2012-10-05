package com.pingfit.format {
	
	import flash.text.*; 
	
	public class TextUtil {
		
		
		public function TextUtil() { }
		
		public static function getHelveticaRounded(size:Number, color:Object, bold:Boolean):TextFormat{
			var myFont:Font = new HelveticaRoundedLTStd();
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = myFont.fontName;
			myFormat.size = size;
			myFormat.color = color; 
			myFormat.bold = bold;
			myFormat.underline = false;
			return myFormat;
		}
		
		public static function getArial(size:Number, color:Object, bold:Boolean):TextFormat{
			var myFont:Font = new Arial();
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = myFont.fontName;
			myFormat.size = size;
			myFormat.color = color; 
			myFormat.bold = bold;
			myFormat.underline = false;
			return myFormat;
		}
		
		public static function getTextField(txtFormat:TextFormat, txtWidth:Number, htmlText:String, autoSize:String=""):TextField{
			if (autoSize==""){
				autoSize = TextFieldAutoSize.LEFT;
			}
			if (htmlText==null){ htmlText = "";}
			var outTxt:TextField = new TextField();
			outTxt.embedFonts = true;
			outTxt.antiAliasType = AntiAliasType.ADVANCED;
			outTxt.selectable = false;
			outTxt.defaultTextFormat = txtFormat;
			outTxt.width = txtWidth;
			outTxt.htmlText = htmlText;
			outTxt.wordWrap = true;
			outTxt.autoSize = autoSize;
			return outTxt;
		}
		
	
	}
	
}