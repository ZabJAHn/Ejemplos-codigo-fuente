package States
{
	import Assets.AssetsManager;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import utils.ResolutionController;
	
	public class WinState extends State
	{
		private const FONT_NAME:String = "PixelSplitter";
		private const TITTLE_TEXT:String = "You Win!!!";
		private const ATLAS:String = "ButtonAtlas";
		private const BACK_TEXTURE:String = "Apply";
		
		private var _continue:Boolean = false;
		
		private var _titleTextField:TextField;
		private var _continueBtn:Button;
		
		public function WinState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			_titleTextField = new TextField(500, 200, "", FONT_NAME, 30, 0xdfdfdf);
			_titleTextField.batchable = true;
			_titleTextField.vAlign = VAlign.TOP;
			_titleTextField.hAlign = HAlign.CENTER;
		}		
		
		public override function onEnter():void
		{
			_continueBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(BACK_TEXTURE), "");
			_continueBtn.addEventListener(Event.TRIGGERED, onContinueButtonDown);
			
			_scene.addChild(_titleTextField);
			_scene.addChild(_continueBtn);
			_titleTextField.text = TITTLE_TEXT;
			
			ResolutionController.dockObject(_continueBtn, ResolutionController.CENTER, 0, ResolutionController.CENTER, 200);
			ResolutionController.dockObject(_titleTextField, ResolutionController.CENTER, 0, ResolutionController.CENTER, -100);
		}
		
		public override function onExit():void
		{
			_scene.removeChild(_titleTextField);
			_scene.removeChild(_continueBtn);
			
			_continue = false;
		}
		
		private function onContinueButtonDown(event:Event):void
		{
			_continue = true;
			_continueBtn.removeEventListener(Event.TRIGGERED, onContinueButtonDown);
		}
		
		public function continueToMain():Boolean
		{
			return _continue;
		}
	}
}