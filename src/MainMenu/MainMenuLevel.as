package MainMenu
{
	import Assets.AssetsManager;
	
	import Board.BoardConfigurationManager;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainMenuLevel extends DisplayObjectContainer
	{
		private const TITLE_FONT_NAME:String = "TektonPro_Bold";
		private const SCORE_FONT_NAME:String = "Thonburi";
		private const ATLAS:String = "ButtonAtlas";
		private const EDIT_TEXTURE:String = "Maintenance";
		private const PLAY_TEXTURE:String = "Go";
		
		private const SCORES_OFFSET:Number = 30;
		private const SCORES_PADDING:Number = 150;
		
		private const BUTTON_X_OFFSET:Number = 50;
		private const BUTTON_Y_OFFSET:Number = 100;
		
		private var _id:String;
		private var _name:String;
		private var _scores:Array;
		private var _startHandler:Function;
		private var _editHandler:Function;
		private var _editable:Boolean;
		
		private var _nameTextField:TextField;
		private var _scoresTextFields:Array;
		private var _scoresValuesTextFields:Array;
		private var _startButton:Button;
		private var _editButton:Button;
		
		public function MainMenuLevel(id:String, name:String, scores:Array, startHandler:Function, editHandler:Function = null, editable:Boolean = false)
		{
			super();
			_id = id;
			_name = name;
			_scores = scores;
			_startHandler = startHandler;
			_editHandler = editHandler;
			_editable = editable;
			
			initialize();
		}
		
		private function initialize():void
		{
			AssetsManager.registerBitmapFont(TITLE_FONT_NAME);
			AssetsManager.registerBitmapFont(SCORE_FONT_NAME);
			_nameTextField = new TextField(500, 100, _name, TITLE_FONT_NAME, 50, 0xdfdfdf);
			_nameTextField.batchable = true;
			_nameTextField.vAlign = VAlign.TOP;
			_nameTextField.hAlign = HAlign.CENTER;
			this.addChild(_nameTextField);
			
			_scoresTextFields = new Array();
			_scoresValuesTextFields = new Array();
			for (var index:int = 0; index < _scores.length; index++)
			{
				var scoreText:String = (index + 1) + " Lugar: "; 
				_scoresTextFields.push(new TextField(200, 40, scoreText, SCORE_FONT_NAME, 20, 0xffffff));
				_scoresValuesTextFields.push(new TextField(300, 40, _scores[index].toString(), SCORE_FONT_NAME, 20, 0xffffff));
				
				_scoresTextFields[index].batchable = true;
				_scoresTextFields[index].vAlign = VAlign.TOP;
				_scoresTextFields[index].hAlign = HAlign.LEFT;
				_scoresTextFields[index].y = SCORES_PADDING + index * SCORES_OFFSET;
				_scoresTextFields[index].x = SCORES_OFFSET;
				
				_scoresValuesTextFields[index].batchable = true;
				_scoresValuesTextFields[index].vAlign = VAlign.TOP;
				_scoresValuesTextFields[index].hAlign = HAlign.RIGHT;
				_scoresValuesTextFields[index].y = SCORES_PADDING + index * SCORES_OFFSET;
				_scoresValuesTextFields[index].x = width - SCORES_OFFSET - _scoresValuesTextFields[index].width;
				
				this.addChild(_scoresTextFields[index]);
				this.addChild(_scoresValuesTextFields[index]);
			}
			
			_startButton = new Button(AssetsManager.getAtlas(ATLAS).getTexture(PLAY_TEXTURE), "");
			_editButton = new Button(AssetsManager.getAtlas(ATLAS).getTexture(EDIT_TEXTURE), "");
			_editButton.enabled = _editable;
			
			_editButton.x = BUTTON_X_OFFSET;
			_startButton.x = this.width - BUTTON_X_OFFSET - _startButton.width;
			_editButton.y = this.height + BUTTON_Y_OFFSET;
			_startButton.y = this.height + BUTTON_Y_OFFSET;
			
			_startButton.addEventListener(Event.TRIGGERED, onButtonStartDown);
			_editButton.addEventListener(Event.TRIGGERED, onButtonEditDown);
			
			this.addChild(_editButton);
			this.addChild(_startButton);
		}
		
		private function onButtonStartDown(event:Event):void
		{
			if(_startHandler != null )
			{
				BoardConfigurationManager.getInstance().LevelKey = _id;
				_startHandler();
			}
		}
		
		private function onButtonEditDown(event:Event):void
		{
			if(_editHandler != null)
			{
				_editHandler();
			}
		}
	}
}