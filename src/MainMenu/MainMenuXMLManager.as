package MainMenu
{
	import Assets.AssetsManager;

	public class MainMenuXMLManager
	{
		private const CONFIG_XML:String = "BoardsConfigXML";
		private const BOARD_CHILD:String = "board";
		
		private static var _instance:MainMenuXMLManager;
		
		private var _mainMenuConfig:XML;
		
		public function get MainMenuConfig():XML
		{
			return _mainMenuConfig;
		}
		
		public function set MainMenuConfig(value:XML):void
		{
			_mainMenuConfig = value;
		}
		
		public function get BoardChilds():XMLList
		{
			return _mainMenuConfig.child(BOARD_CHILD);
		}
		
		public function MainMenuXMLManager(key:SingletonKey)
		{
			if(!key)
			{
				throw new Error('Singleton, use the get instance method.');
			}
		}
		
		public static function getInstance():MainMenuXMLManager
		{
			if(_instance == null)
			{
				_instance = new MainMenuXMLManager(new SingletonKey);
				_instance._mainMenuConfig = AssetsManager.getXML(_instance.CONFIG_XML);
			}
			
			return _instance;
		}
		
		public function updateChild(id:String, name:String):void
		{
			for each (var level:XML in BoardChilds) 
			{
				if(level.@id == id)
				{
					level.@name = name;
					return;
				}
			}
			var xmlChild:XML = 
				<board id="" name="" editable="true">
					<score rank="1" value="0"/>
					<score rank="2" value="0"/>
					<score rank="3" value="0"/>
					<score rank="4" value="0"/>
					<score rank="5" value="0"/>
				</board>;
			xmlChild.@id = id;
			xmlChild.@name = name;
			_mainMenuConfig.appendChild(xmlChild);
		}
	}
}

class SingletonKey{
}