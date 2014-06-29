package Board
{
	import flash.utils.Dictionary;

	public class BoardConfigurationManager
	{
		[Embed(source="../../levels/Nuevo_Ciclo_Valiente.json", mimeType="application/octet-stream")]
		public static const Nuevo_Ciclo_Valiente:Class;
		
		[Embed(source="../../levels/Ciclo_Madre.json", mimeType="application/octet-stream")]
		public static const Ciclo_Madre:Class;
		
		[Embed(source="../../levels/Primeros_Ciclos.json", mimeType="application/octet-stream")]
		public static const Primeros_Ciclos:Class;
		
		[Embed(source="../../levels/Popy.json", mimeType="application/octet-stream")]
		public static const Popy:Class;
		
		[Embed(source="../../levels/Tiempo_Para_La_Escuela.json", mimeType="application/octet-stream")]
		public static const Tiempo_Para_La_Escuela:Class;
		
		private static var _instance:BoardConfigurationManager;
		
		private var _levelKey:String;
		private var _levels:Dictionary = new Dictionary();
		
		public function set LevelKey(value:String):void
		{
			_levelKey = value;
		}
		
		public function get LevelKey():String
		{
			return _levelKey;
		}
		
		public function BoardConfigurationManager(key:SingletonKey)
		{
			if(!key)
			{
				throw new Error('Singleton, use the get instance method.');
			}
		}
		
		public static function getInstance():BoardConfigurationManager
		{
			if(_instance == null)
			{
				_instance = new BoardConfigurationManager(new SingletonKey);
			}
			
			return _instance;
		}
		
		public function getLevel():Object
		{
			if(_levels[_levelKey] == undefined)
			{
				var json:Object = JSON.parse(new String(new BoardConfigurationManager[_levelKey]()));
				_levels[_levelKey] = json;
			}
			return _levels[_levelKey];
		}
		
		public function saveLevel(levelKey:String, level:Object):void
		{
			_levels[levelKey] = level;
		}
	}
}

class SingletonKey{
}