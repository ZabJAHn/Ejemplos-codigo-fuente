package MainMenu
{
	import Assets.AssetsManager;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class MainMenuLevelSlider extends DisplayObjectContainer
	{
		private const SCORE_CHILD:String = "score";
		private const LEVEL_WIDTH:Number = 500;
		private const LEVEL_PADDING:Number = 100;
		private const X_PADDING:Number = 350;
		private const Y_PADDING:Number = 275;
		
		private const ATLAS:String = "ButtonAtlas";
		private const LEFT_TEXTURE:String = "Left";
		private const RIGHT_TEXTURE:String = "Right";
		
		private var _levels:Array;
		private var _onButtonStartDown:Function;
		
		private var _backBtn:Button;
		private var _nextBtn:Button;
		
		private var _index:Number = 0;
		
		public function MainMenuLevelSlider(onButtonStartDown:Function)
		{
			super();
			_onButtonStartDown = onButtonStartDown;
			_levels = new Array();
			initialize();
		}
		
		private function initialize():void
		{
			var index:Number = 0; 
			for each (var level:XML in MainMenuXMLManager.getInstance().BoardChilds) 
			{
				addLevel(level);
				if(_levels.length > index)
				{
					_levels[index].x = LEVEL_PADDING + (index * (LEVEL_PADDING + Starling.current.stage.stageWidth));
				}
				index++;
			}
			
			addButtons();
			
			this.x = Starling.current.stage.stageWidth / 2 - X_PADDING;
			this.y = Starling.current.stage.stageHeight / 2 - Y_PADDING;
		}
		
		private function addLevel(level:XML):void
		{
			var id:String = level.@id;
			var name:String = level.@name;
			var scores:Array = new Array();
			
			for each (var score:XML in level.child(SCORE_CHILD))
			{
				scores.push(score.@value);
			}
			
			var mainMenuLevel:MainMenuLevel = new MainMenuLevel(id, name, scores, _onButtonStartDown);
			
			_levels.push(mainMenuLevel);
			this.addChild(mainMenuLevel);
		}
		
		private function addButtons():void
		{
			_backBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(LEFT_TEXTURE), "");
			_nextBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(RIGHT_TEXTURE), "");
			
			_backBtn.addEventListener(Event.TRIGGERED, onBackButtonDown);
			_nextBtn.addEventListener(Event.TRIGGERED, onNextButtonDown);
			
			_backBtn.y = this.height / 2 - _backBtn.height;
			_nextBtn.y = this.height / 2 - _nextBtn.height;
			_backBtn.x = 25;
			_nextBtn.x = X_PADDING * 2 - _nextBtn.width - 25;
			
			_backBtn.enabled = false;
			
			this.addChild(_backBtn);
			this.addChild(_nextBtn);
		}
		
		private function onBackButtonDown(event:Event):void
		{
			_index -= 1;
			if(_index < 1) _backBtn.enabled = false;
			if(_levels.length > _index) _nextBtn.enabled = true;
			moveToIndex(_index);
		}
		
		private function onNextButtonDown(event:Event):void
		{
			_index += 1;
			if(_levels.length - 2 < _index) _nextBtn.enabled = false;
			if(_index > 0) _backBtn.enabled = true;
			moveToIndex(_index);
		}
		
		private function moveToIndex(index:Number):void
		{
			for each (var level:MainMenuLevel in _levels) 
			{
				level.x = LEVEL_PADDING + (-index * (LEVEL_PADDING + Starling.current.stage.stageWidth));
				index--;
			}
		}
	}
}