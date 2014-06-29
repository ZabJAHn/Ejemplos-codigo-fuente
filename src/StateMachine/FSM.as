package StateMachine
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class FSM
	{
		protected var _currentState:State;
		protected var _initialState:State;
		
		protected var _states:Object;
		protected var _transitions:Object;
		
		protected var _scene:Sprite;
		
		public function FSM(scene:Sprite)
		{
			this._scene = scene;
			this._initialState = null;
			this._currentState = null;
			this._states = new Object();
			this._transitions = new Object();
			
			this._scene.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void{
			step();
		}
		
		public function get currentState():State{
			return (this._currentState);
		}
		
		public function getStateByName(stateName:String):State{
			var state:State = this._states[stateName];
			if (state != null){
				return (state);
			};
			trace((("ERROR: state with name: \"" + stateName) + "\" was not found."));
			return (null);
		}
		
		public function get initialState():State{
			return (this._initialState);
		}
		
		private function step():void{
			
			if (this._currentState == null){
				this._currentState = this._initialState;
				this._currentState.onEnter();
			}
				
			var stepState:State = this._currentState;
			this._currentState.onUpdate();

			if (stepState == this._currentState){
				var stepTransitions:Array = this._transitions[this._currentState.name];
				var index:uint;

				for (index = 0; index < stepTransitions.length; index++) {
					if (stepTransitions[index].checkCondition(this._currentState)){
						stepState = stepTransitions[index].nextState;
						break;
					}
				}
			}
				
			if (stepState != this._currentState){
				this._currentState.onExit();
				this._currentState = stepState;
				this._currentState.onEnter();
			}
		}
		
		public function addState(state:State, isInitial:Boolean=false):State{
			this._states[state.name] = state;
			this._transitions[state.name] = new Array();
			
			if ((((this._initialState == null)) || (isInitial))){
				this._initialState = state;
			};
			return (state);
		}
		
		public function addTransition(initialTransitionState:State, finalTransitionState:State, transitionFunction:Function):void{
			if (this._transitions[initialTransitionState.name] != undefined){
				this._transitions[initialTransitionState.name].push(new Transition(finalTransitionState.name, transitionFunction, this));
			};
		}
	}
}