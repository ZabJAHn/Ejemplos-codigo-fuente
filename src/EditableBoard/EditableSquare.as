package EditableBoard
{	
	import Assets.AssetsManager;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class EditableSquare extends DisplayObjectContainer
	{
		private const ATLAS:String = "SquareAtlas";
		private const SELECTED_TEXTURE:String = "000";
		private const UNSELECTED_TEXTURE:String = "001";
		private const PADDING_OFFSET:Number = 2;
		
		private var _parent:EditableBoard;
		private var _xPosition:Number;
		private var _yPosition:Number;
		private var _selected:Boolean;
		private var _squareImage:Image;
		private var _squareMask:Image;
		
		public function get XPosition():Number
		{
			return _xPosition;
		}
		
		public function set XPosition(value:Number):void
		{
			_xPosition = value;
		}
		
		public function get YPosition():Number
		{
			return _yPosition;
		}
		
		public function set YPosition(value:Number):void
		{
			_yPosition = value;
		}
		
		public function get Selected():Boolean
		{
			return _selected;
		}
		
		public function set Selected(value:Boolean):void
		{
			_selected = value;
			
			if(_squareMask)
				_squareMask.alpha = _selected ? 1 : 0;
		}
		
		public function EditableSquare(parent:EditableBoard, xPosition:Number, yPosition:Number, selected:Boolean = false)
		{
			super();
			_parent = parent;
			_xPosition = xPosition;
			_yPosition = yPosition;
			_selected = selected;
			Initialize();
		}
		
		private function Initialize():void
		{
			_squareImage = new Image(AssetsManager.getAtlas(ATLAS).getTexture(UNSELECTED_TEXTURE));
			_squareMask = new Image(AssetsManager.getAtlas(ATLAS).getTexture(SELECTED_TEXTURE));
			_squareImage.width = 64;
			_squareImage.height = 64;
			_squareMask.width = 64;
			_squareMask.height = 64;
			
			
			if(_selected) _squareMask.alpha = 1;
			else _squareMask.alpha = 0;
			
			_parent.addChild(this);
			this.addChild(_squareImage);
			this.addChild(_squareMask);
			this.x = _squareImage.width * _xPosition + PADDING_OFFSET * (_xPosition - 1);
			this.y = _squareImage.height * _yPosition + PADDING_OFFSET * (_yPosition - 1);
			
			this.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
				Selected = !Selected;
			}
		}
	}
}