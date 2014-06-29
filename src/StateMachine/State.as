package StateMachine
{
	import starling.display.Sprite;

	public class State
	{
		private var _name:String;
		
		private var _parentFSM:FSM;
		
		protected var _scene:Sprite;
		
		public function State(name:String, parentFSM:FSM, scene:Sprite)
		{
			_name = name;
			_parentFSM = parentFSM;
			_scene = scene;
		}
		
		
		public function get name():String
		{
			return _name;
		}
		
		public function onEnter():void
		{
		}
		
		public function onUpdate():void
		{
		}
		
		public function onExit():void
		{
		}
		
		protected function get parentFsm():FSM{
			return parentFsm;
		}
	}
}