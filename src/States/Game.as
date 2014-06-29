package States
{
	
	import StateMachine.FSM;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _splashScene:SplashState;
		private var _mainMenu:MainMenuState;
		private var _createScene:CreateState;
		private var _gameScene:GameState;
		private var _winScene:WinState;
		private var _fSMManager:FSM;
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_fSMManager = new FSM(this);
			
			_splashScene = new SplashState("SplashScene", _fSMManager, this);
			_mainMenu = new MainMenuState("MainMenu", _fSMManager, this);
			_createScene = new CreateState("CreateScene", _fSMManager, this);
			_gameScene = new GameState("GameScene", _fSMManager, this);
			_winScene = new WinState("WinScene", _fSMManager, this);
			
			_fSMManager.addState(_splashScene, true);
			_fSMManager.addState(_mainMenu);
			_fSMManager.addState(_createScene);
			_fSMManager.addState(_gameScene);
			_fSMManager.addState(_winScene);
			
			_fSMManager.addTransition(_splashScene, _mainMenu, _splashScene.play);
			_fSMManager.addTransition(_splashScene, _createScene, _splashScene.create);
			_fSMManager.addTransition(_createScene, _splashScene, _createScene.isSaved);
			_fSMManager.addTransition(_mainMenu, _gameScene, _mainMenu.play);
			_fSMManager.addTransition(_mainMenu, _splashScene, _mainMenu.back);
			_fSMManager.addTransition(_gameScene, _mainMenu, _gameScene.onIsGameBack);
			_fSMManager.addTransition(_gameScene, _winScene, _gameScene.onIsGameEnded);
			_fSMManager.addTransition(_winScene, _mainMenu, _winScene.continueToMain);
		}
	}
}