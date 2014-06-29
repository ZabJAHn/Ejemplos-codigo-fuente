package States
{	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Assets.AssetsManager;
	
	import Board.Board;
	import Board.BoardConfigurationManager;
	
	import MainMenu.MainMenuXMLManager;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	import utils.NumberTextField;
	import utils.ResolutionController;
	
	public class GameState extends State
	{
		private const ATLAS:String = "ButtonAtlas";
		private const BACK_TEXTURE:String = "Backward";
		private const END_TIMER_TIME:Number = 1000;
		private const TITLE_FONT_NAME:String = "TektonPro_Small";
		private const SCORE_FONT_NAME:String = "Thonburi";
		
		private var _isGameEnded:Boolean = false;
		private var _isGameBack:Boolean = false;
		private var _isTiming:Boolean = false;
		private var _board:Board;
		private var _scoreTxt:NumberTextField;
		private var _percentageTxt:NumberTextField;
		private var _backBtn:Button;
		private var _titleTxt:TextField;
		private var _endTimer:Timer;

		public function GameState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
		}
		
		public override function onEnter():void
		{
			_isTiming = false;
			_endTimer = new Timer(END_TIMER_TIME);
			_endTimer.addEventListener(TimerEvent.TIMER, onTimerEnds);
			
			_board = new Board(onBoardChangeScore);
			
			AssetsManager.registerBitmapFont(TITLE_FONT_NAME);
			AssetsManager.registerBitmapFont(SCORE_FONT_NAME);
			
			_titleTxt = new TextField(700, 60, BoardConfigurationManager.getInstance().getLevel().name, TITLE_FONT_NAME, 36, 0xdfdfdf);
			_scoreTxt = new NumberTextField(1000, 30, "Puntuacion: ", SCORE_FONT_NAME, 20, 0xffffff);
			_percentageTxt = new NumberTextField(1000, 30, "Porcentaje: ", SCORE_FONT_NAME, 20, 0xffffff, "%");
			_scoreTxt.hAlign = HAlign.LEFT;
			_percentageTxt.hAlign = HAlign.LEFT;
			
			_backBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(BACK_TEXTURE), "");
			_backBtn.addEventListener(Event.TRIGGERED, onBackButtonDown);
			
			_scene.addChild(_board);
			_scene.addChild(_backBtn);
			_scene.addChild(_titleTxt);
			_scene.addChild(_scoreTxt);
			_scene.addChild(_percentageTxt);
			
			ResolutionController.dockObject(_board, ResolutionController.CENTER, 0, ResolutionController.CENTER, 50);
			ResolutionController.dockObject(_backBtn, ResolutionController.RIGHT, -50, ResolutionController.BOTTOM, -50);
			ResolutionController.dockObject(_titleTxt, ResolutionController.CENTER, 0, ResolutionController.TOP, 10);
			ResolutionController.dockObject(_scoreTxt, ResolutionController.LEFT, 50, ResolutionController.TOP, 50);
			ResolutionController.dockObject(_percentageTxt, ResolutionController.LEFT, 50, ResolutionController.TOP, 80);
			
			onBoardChangeScore();
		}
		
		public override function onExit():void
		{
			_scene.removeChild(_board);
			_scene.removeChild(_backBtn);
			_scene.removeChild(_titleTxt);
			_scene.removeChild(_scoreTxt);
			_scene.removeChild(_percentageTxt);
			
			_isGameEnded = false;
			_isGameBack = false;
		}
		
		private function saveScore():void
		{
			if(_board == null || _board.Percentage < 100) return;
			var mainMenu:XML = MainMenuXMLManager.getInstance().MainMenuConfig;
			for (var i:int = 0; i < mainMenu.children().length(); i++) 
			{
				if(mainMenu.children()[i].@id == BoardConfigurationManager.getInstance().LevelKey)
				{
					var childLen:Number = mainMenu.children()[i].children().length();
					for (var j:int = 0; j < childLen; j++)
					{
						if(mainMenu.children()[i].children()[j].@value < _board.Score)
						{
							var childIndex:Number = j;
							for(j = childLen - 1; j > childIndex; j--)
								mainMenu.children()[i].children()[j].@value = mainMenu.children()[i].children()[j - 1].@value;
							mainMenu.children()[i].children()[childIndex].@value = _board.Score;
							break;
						}
					}
				}
			}
			
			MainMenuXMLManager.getInstance().MainMenuConfig = mainMenu;
		}
		
		private function onBackButtonDown(event:Event):void
		{
			if(_isTiming) return;
			_isGameBack = true;
		}
		
		public function onIsGameBack():Boolean
		{
			return _isGameBack;
		}
		
		public function onIsGameEnded():Boolean
		{
			return _isGameEnded;
		}
		
		private function onBoardChangeScore():void
		{
			if(_board != null)
			{
				_scoreTxt.Text = _board.Score;
				_percentageTxt.Text = _board.Percentage;
				if(_board.Percentage >= 100)
				{
					_isTiming = true;
					_backBtn.enabled = false;
					_endTimer.start();
					saveScore();
				}
			}
		}
		
		private function onTimerEnds(event:TimerEvent):void
		{
			_endTimer.removeEventListener(TimerEvent.TIMER, onTimerEnds);
			_isGameEnded = true;
		}
	}
}