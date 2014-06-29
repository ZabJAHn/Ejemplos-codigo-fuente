package States
{	
	import Assets.AssetsManager;
	
	import MainMenu.MainMenuLevelSlider;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.ResolutionController;
	
	public class MainMenuState extends State
	{		
		private const ATLAS:String = "ButtonAtlas";
		private const BACK_TEXTURE:String = "Backward";
		
		private var _play:Boolean = false;
		private var _back:Boolean = false;
		
		private var _levelSlider:MainMenuLevelSlider;
		private var _backBtn:Button;

		public function MainMenuState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
		}
		
		public override function onEnter():void
		{
			_levelSlider = new MainMenuLevelSlider(onButtonStartDown);
			_backBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(BACK_TEXTURE), "");
			_backBtn.addEventListener(Event.TRIGGERED, onBackButtonDown);
			
			ResolutionController.dockObject(_backBtn, ResolutionController.RIGHT, -50, ResolutionController.BOTTOM, -50);
			
			_scene.addChild(_levelSlider);
			_scene.addChild(_backBtn);
		}
		
		public override function onExit():void
		{
			_scene.removeChild(_levelSlider);
			_scene.removeChild(_backBtn);
			_play = false;
			_back = false;
		}
		
		private function onButtonStartDown():void
		{
			_play = true;
		}
		
		private function onBackButtonDown(event:Event):void
		{
			_back = true;
			_backBtn.removeEventListener(Event.TRIGGERED, onBackButtonDown);
		}
		
		public function play():Boolean
		{
			return _play;
		}
		
		public function back():Boolean
		{
			return _back;
		}
	}
}