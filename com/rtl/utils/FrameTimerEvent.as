package
{
  import flash.events.Event;
	
	/**
	 * ...
	 * @author RTLShadow
	 */
	public class FrameTimerEvent extends Event
	{
		public static const LOOP:String = "loop";
		public static const LOOP_END:String = "loop_end";
		
		public var loopNum:int;
		public function FrameTimerEvent( type:String, num:int ):void
		{
			loopNum = num;
			super( type );
		}
	}

}
