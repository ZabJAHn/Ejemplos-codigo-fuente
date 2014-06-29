package EditableBoard
{
	import starling.display.DisplayObjectContainer;
	
	public class EditableBoard extends DisplayObjectContainer
	{
		private var _squares:Array;
		
		public function get Squares():Array
		{
			return _squares;
		}
		
		public function EditableBoard()
		{
			super();
			Initialize();
		}
		
		private function Initialize():void
		{
			_squares = new Array();
			for (var i:int = 0; i < 8; i++)
			{
				for (var j:int = 0; j < 8; j++) 
				{
					_squares.push(new EditableSquare(this, j, i));
				}
			}
		}
	}
}