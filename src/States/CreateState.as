package States
{
	import Assets.AssetsManager;
	
	import Board.BoardConfigurationManager;
	
	import EditableBoard.EditableBoard;
	import EditableBoard.EditableSquare;
	
	import MainMenu.MainMenuXMLManager;
	
	import StateMachine.FSM;
	import StateMachine.State;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	import utils.ResolutionController;
	
	public class CreateState extends State
	{
		private const FONT_NAME:String = "PixelSplitter";
		private const TITTLE_TEXT:String = "Nuevo Tablero";
		private const ATLAS:String = "ButtonAtlas";
		private const APPLY_TEXTURE:String = "Apply";
		
		private var _saved:Boolean = false;
		
		private var _titleTxt:TextInput;
		private var _saveBtn:Button;
		private var _board:EditableBoard;
		private var _startScoreTxt:TextInput;
		private var _minPercentageTxt:TextInput;
		private var _maxPercentageTxt:TextInput;
		private var _hPenalizationTxt:TextInput;
		private var _vPenalizationTxt:TextInput;
		private var _nBonificationTxt:TextInput;
		private var _nPenalizationTxt:TextInput;
		private var _gBonificationTxt:TextInput;
		private var _gPenalizationTxt:TextInput;
		private var _textFields:Array;
		private var _textFieldsText:Array = [
			"Puntaje inicial: ",
			"Porcentaje minimo: ",
			"Porcentaje maximo: ",
			"Penalizacion horizontal: ",
			"Penalizacion vertical: ",
			"Bonificacion normal: ",
			"Penalizacion normal: ",
			"Bonificacion extra: ",
			"Penalizacion extra: "
		];
		
		private function get BoardID():String
		{
			var rex:RegExp = /[\s\r\n]*/gim;
			var id:String = _titleTxt != null ? _titleTxt.text : "";
			id = id.replace(rex,'');
			if(id == "") id = "sin_titulo";
			return id.toLowerCase();
		}
		
		public function CreateState(name:String, parentFSM:FSM, scene:Sprite)
		{
			super(name, parentFSM, scene);
			_titleTxt = new TextInput();
			_startScoreTxt = new TextInput();
			_minPercentageTxt = new TextInput();
			_maxPercentageTxt = new TextInput();
			_hPenalizationTxt = new TextInput();
			_vPenalizationTxt = new TextInput();
			_nBonificationTxt = new TextInput();
			_nPenalizationTxt = new TextInput();
			_gBonificationTxt = new TextInput();
			_gPenalizationTxt = new TextInput();
			_textFields = new Array();
			
			for each (var text:String in _textFieldsText) 
			{
				var tempText:TextField = new TextField(1000, 30, text,"Verdana", 12, 0xffffff);
				tempText.hAlign = HAlign.LEFT;
				_textFields.push(tempText);
			}
			
			_titleTxt.width = 300; _titleTxt.height = 30;
			_startScoreTxt.width = 100; _startScoreTxt.height = 30;
			_minPercentageTxt.width = 100; _minPercentageTxt.height = 30;
			_maxPercentageTxt.width = 100; _maxPercentageTxt.height = 30;
			_hPenalizationTxt.width = 100; _hPenalizationTxt.height = 30;
			_vPenalizationTxt.width = 100; _vPenalizationTxt.height = 30;
			_nBonificationTxt.width = 100; _nBonificationTxt.height = 30;
			_nPenalizationTxt.width = 100; _nPenalizationTxt.height = 30;
			_gBonificationTxt.width = 100; _gBonificationTxt.height = 30;
			_gPenalizationTxt.width = 100; _gPenalizationTxt.height = 30;
			
			_titleTxt.textEditorFactory = titleEditorFactory;
			_startScoreTxt.textEditorFactory = fieldEditorFactory;
			_minPercentageTxt.textEditorFactory = fieldEditorFactory;
			_maxPercentageTxt.textEditorFactory = fieldEditorFactory;
			_hPenalizationTxt.textEditorFactory = fieldEditorFactory;
			_vPenalizationTxt.textEditorFactory = fieldEditorFactory;
			_nBonificationTxt.textEditorFactory = fieldEditorFactory;
			_nPenalizationTxt.textEditorFactory = fieldEditorFactory;
			_gBonificationTxt.textEditorFactory = fieldEditorFactory;
			_gPenalizationTxt.textEditorFactory = fieldEditorFactory;
		}		
		
		public override function onEnter():void
		{
			_saveBtn = new Button(AssetsManager.getAtlas(ATLAS).getTexture(APPLY_TEXTURE), "");
			_saveBtn.addEventListener(Event.TRIGGERED, onSaveButtonDown);
			
			_board = new EditableBoard();
			
			var index:Number = 0;
			for each (var textField:TextField in _textFields)
			{
				_scene.addChild(textField);
				ResolutionController.dockObject(textField, ResolutionController.LEFT, 50, ResolutionController.TOP, 50 + 30*index);
				index++;
			}
			
			_scene.addChild(_titleTxt);
			_scene.addChild(_startScoreTxt);
			_scene.addChild(_minPercentageTxt);
			_scene.addChild(_maxPercentageTxt);
			_scene.addChild(_hPenalizationTxt);
			_scene.addChild(_vPenalizationTxt);
			_scene.addChild(_nBonificationTxt);
			_scene.addChild(_nPenalizationTxt);
			_scene.addChild(_gBonificationTxt);
			_scene.addChild(_gPenalizationTxt);
			_scene.addChild(_saveBtn);
			_scene.addChild(_board);
			
			_titleTxt.text = TITTLE_TEXT;
			_startScoreTxt.text = "500";
			_minPercentageTxt.text = "50";
			_maxPercentageTxt.text = "70";
			_hPenalizationTxt.text = "1";
			_vPenalizationTxt.text = "3";
			_nBonificationTxt.text = "5";
			_nPenalizationTxt.text = "7";
			_gBonificationTxt.text = "25";
			_gPenalizationTxt.text = "25";
			
			_titleTxt.textEditorProperties.maxChars = 20;
			_startScoreTxt.textEditorProperties.maxChars = 5;
			_minPercentageTxt.textEditorProperties.maxChars = 2;
			_maxPercentageTxt.textEditorProperties.maxChars = 2;
			_hPenalizationTxt.textEditorProperties.maxChars = 3;
			_vPenalizationTxt.textEditorProperties.maxChars = 3;
			_nBonificationTxt.textEditorProperties.maxChars = 3;
			_nPenalizationTxt.textEditorProperties.maxChars = 3;
			_gBonificationTxt.textEditorProperties.maxChars = 3;
			_gPenalizationTxt.textEditorProperties.maxChars = 3;
			
			ResolutionController.dockObject(_board, ResolutionController.CENTER, 0, ResolutionController.CENTER, 50);
			ResolutionController.dockObject(_saveBtn, ResolutionController.RIGHT, -50, ResolutionController.BOTTOM, -50);
			ResolutionController.dockObject(_titleTxt, ResolutionController.CENTER, 0, ResolutionController.TOP, 30);
			ResolutionController.dockObject(_startScoreTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 55);
			ResolutionController.dockObject(_minPercentageTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 85);
			ResolutionController.dockObject(_maxPercentageTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 115);
			ResolutionController.dockObject(_hPenalizationTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 145);
			ResolutionController.dockObject(_vPenalizationTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 175);
			ResolutionController.dockObject(_nBonificationTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 205);
			ResolutionController.dockObject(_nPenalizationTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 235);
			ResolutionController.dockObject(_gBonificationTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 265);
			ResolutionController.dockObject(_gPenalizationTxt, ResolutionController.LEFT, 140, ResolutionController.TOP, 295);
		}
		
		public override function onExit():void
		{
			_scene.removeChild(_board);
			_scene.removeChild(_titleTxt);
			_scene.removeChild(_startScoreTxt);
			_scene.removeChild(_minPercentageTxt);
			_scene.removeChild(_maxPercentageTxt);
			_scene.removeChild(_hPenalizationTxt);
			_scene.removeChild(_vPenalizationTxt);
			_scene.removeChild(_nBonificationTxt);
			_scene.removeChild(_nPenalizationTxt);
			_scene.removeChild(_gBonificationTxt);
			_scene.removeChild(_gPenalizationTxt);
			_scene.removeChild(_saveBtn);
			
			for each (var textField:TextField in _textFields)
			{
				_scene.removeChild(textField);
			}
			
			_saved = false;
		}
		
		private function onSaveButtonDown(event:Event):void
		{
			if(!validateForm()) return;
			saveJson();
			saveXML();
			_saved = true;
			_saveBtn.removeEventListener(Event.TRIGGERED, onSaveButtonDown);
		}
		
		public function isSaved():Boolean
		{
			return _saved;
		}
		
		public static function titleEditorFactory():ITextEditor
		{
			var textEditor:StageTextTextEditor = new StageTextTextEditor();
			
			textEditor.autoCorrect = false;
			textEditor.color = 0xdfdfdf;
			textEditor.displayAsPassword = false;
			textEditor.fontFamily = "Helvetica";
			textEditor.fontSize = 24;
			textEditor.width = 200;
			textEditor.height = 30;
			textEditor.textAlign = "center";
			
			return textEditor;
		}
		
		public static function fieldEditorFactory():ITextEditor
		{
			var textEditor:StageTextTextEditor = new StageTextTextEditor();
			
			textEditor.autoCorrect = false;
			textEditor.color = 0xffffff;
			textEditor.displayAsPassword = false;
			textEditor.fontFamily = "Helvetica";
			textEditor.fontSize = 14;
			textEditor.textAlign = "right";
			
			return textEditor;
		}
		
		private function saveJson():void
		{
			var jsonObject:Object = new Object();
			jsonObject.name = _titleTxt.text != "" ? _titleTxt.text : "Sin Titulo";
			jsonObject.initialScore = parseInt(_startScoreTxt.text);
			jsonObject.goldenSquares = parseInt("1");
			jsonObject.verticalPenalization = parseInt(_vPenalizationTxt.text);
			jsonObject.horizontalPenalization = parseInt(_hPenalizationTxt.text);
			jsonObject.normalPrize = parseInt(_nBonificationTxt.text);
			jsonObject.normalPenalization = parseInt(_nPenalizationTxt.text);
			jsonObject.goldenPrize = parseInt(_gBonificationTxt.text);
			jsonObject.goldenPenalization = parseInt(_gPenalizationTxt.text);
			jsonObject.minCompletionPercentage = parseInt(_minPercentageTxt.text);
			jsonObject.maxCompletionPercentage = parseInt(_maxPercentageTxt.text);
			jsonObject.completionTableSize = 0;
			jsonObject.completionTable = [
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0]
			];
			
			var completationTableSize:Number = 0;
			for each (var square:EditableSquare in _board.Squares)
			{
				if(square.Selected)
				{
					completationTableSize++;
					jsonObject.completionTable[square.YPosition][square.XPosition] = 1;
				}
				else
				{
					jsonObject.completionTable[square.YPosition][square.XPosition] = 0;
				}
			}
			
			if(completationTableSize == 0)
			{
				jsonObject.completionTableSize = 1;
				jsonObject.completionTable[0][0] = true;
			}
			else
			{
				jsonObject.completionTableSize = completationTableSize;
			}
			BoardConfigurationManager.getInstance().saveLevel(BoardID, jsonObject);
		}
		
		private function saveXML():void
		{
			var title:String = _titleTxt.text != "" ? _titleTxt.text : "Sin Titulo";
			MainMenuXMLManager.getInstance().updateChild(BoardID, title);
		}
		
		private function validateForm():Boolean
		{
			var pattern:RegExp = /^[0-9]+$/;
			var isValid:Boolean = true;
			
			_startScoreTxt.textEditorProperties.color = 0xffffff;
			_minPercentageTxt.textEditorProperties.color = 0xffffff;
			_maxPercentageTxt.textEditorProperties.color = 0xffffff;
			_hPenalizationTxt.textEditorProperties.color = 0xffffff;
			_vPenalizationTxt.textEditorProperties.color = 0xffffff;
			_nBonificationTxt.textEditorProperties.color = 0xffffff;
			_nPenalizationTxt.textEditorProperties.color = 0xffffff;
			_gBonificationTxt.textEditorProperties.color = 0xffffff;
			_gPenalizationTxt.textEditorProperties.color = 0xffffff;
			
			var isadaf:Boolean = pattern.test(_startScoreTxt.text);
			if(!pattern.test(_startScoreTxt.text))
			{
				_startScoreTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_minPercentageTxt.text))
			{
				_minPercentageTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_maxPercentageTxt.text))
			{
				_maxPercentageTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(parseInt(_maxPercentageTxt.text) < parseInt(_minPercentageTxt.text))
			{
				_minPercentageTxt.textEditorProperties.color = 0xff0000;
				_maxPercentageTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_hPenalizationTxt.text))
			{
				_hPenalizationTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_vPenalizationTxt.text))
			{
				_vPenalizationTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_nBonificationTxt.text))
			{
				_nBonificationTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_nPenalizationTxt.text))
			{
				_nPenalizationTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_gBonificationTxt.text))
			{
				_gBonificationTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			if(!pattern.test(_gPenalizationTxt.text))
			{
				_gPenalizationTxt.textEditorProperties.color = 0xff0000;
				isValid = false;
			}
			
			return isValid;
		}
	}
}