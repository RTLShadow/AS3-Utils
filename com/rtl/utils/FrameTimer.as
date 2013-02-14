package
{
  import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author RTLShadow
	 */
	public class FrameTimer extends EventDispatcher
	{
		// read/write variables.
		public var delay:int;
		public var amount:int;
		
		// private variables (only supposed to be accessed by FrameTimer)
		private var _currentCount:int;
		private var _currentLoop:int;
		private var stage:Stage;
		
		// Constructor
		/**
		 * Creates a new instance of the FrameTimer class, uses a frame-based method of keeping time
		 * instead of milliseconds like Adobe's built-in Timer class.
		 * FrameTimers scale with lag or fps-changing, so if you mean for 60fps to be 1 second, but people run the game at 30FPS, 60 frames will be 2 seconds.
		 * @param	delay	How often the timer updates. (60 frames at 60FPS = 1 second)
		 * @param	stageRef	Reference to FP's main stage, needed for the ENTER_FRAME event.
		 * @param	amount	How many times this timer should be run, 0 or less is forever.
		 */
		public function FrameTimer( delay:int, stageRef:Stage, amount:int = 0 ):void
		{
			this.delay = delay;
			this.amount = amount;
			stage = stageRef;
		}
		
		// PUBLIC FUNCTIONS
		/**
		 * Start the timer. This creates an ENTER_FRAME listener to update the timer.
		 */
		public function start():void
		{
			stop();
			stage.addEventListener( Event.ENTER_FRAME, update );
		}
		
		/**
		 * Stops the timer. This resets _currentCount and _currentLoop back to 0, and removes the ENTER_FRAME listener.
		 */
		public function stop():void
		{
			_currentCount = 0;
			_currentLoop = 0;
			
			if ( stage.hasEventListener( Event.ENTER_FRAME ) )
			{
				stage.removeEventListener( Event.ENTER_FRAME, update );
			}
		}
		
		// Getters/Setters
		/**
		 * Returns the frames since last update. (i.e. 32 frames into the third update would return 32.)
		 */
		public function get currentCount():int
		{
			return _currentCount;
		}
		
		/**
		 * Returns how many loops the timer has run.
		 */
		public function get currentLoop():int
		{
			return _currentLoop;
		}
		
		// INTERNAL FUNCTIONS
		private function update( e:Event ):void
		{
			
			_currentCount++;
			if ( _currentCount == delay )
			{
				_currentCount = 0;
				_currentLoop++;
				dispatchEvent( new FrameTimerEvent( FrameTimerEvent.LOOP, _currentLoop ) );
				
				if ( _currentLoop == amount )
				{
					dispatchEvent( new FrameTimerEvent( FrameTimerEvent.LOOP_END, _currentLoop ) );
					stop();
				}
			}
		
		}
	}

}
