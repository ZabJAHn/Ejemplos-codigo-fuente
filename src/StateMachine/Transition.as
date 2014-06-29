package StateMachine
{
	public class Transition
	{
		
		private var _nextState:String;
		private var _condition:Function;
		private var _parentFSM:FSM;
		
		public function Transition(nextState:String, condition:Function, parentFSM:FSM)
		{
			_nextState = nextState;
			_condition = condition;
			_parentFSM = parentFSM;
		}
		
		public function checkCondition(state:State):Boolean
		{
			return (this._condition.call(state));
		}
		
		public function get nextState():State
		{
			return (this._parentFSM.getStateByName(this._nextState));
		}
	}
}