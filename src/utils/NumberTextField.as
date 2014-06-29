package utils
{
	import starling.text.TextField;
	
	public class NumberTextField extends TextField
	{
		private var _startText:String;
		private var _endText:String;
		
		public function set Text(value:Number):void
		{
			text = _startText + Math.floor(value).toString() + _endText;
		}
		
		public function NumberTextField(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0, endText:String = "", bold:Boolean=false)
		{
			super(width, height, text, fontName, fontSize, color, bold);
			_startText = text;
			_endText = endText;
		}
	}
}