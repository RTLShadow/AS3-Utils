package
{
    import flash.events.Event;
	
	/**
	 * ...
	 * @author RTLShadow
	 */
	public class SoundEvent extends Event
	{
		public static const MUSIC_MUTED:String = "musicMuted";
		public static const MUSIC_UNMUTED:String = "musicUnmuted";
		public static const SOUND_MUTED:String = "soundMuted";
		public static const SOUND_UNMUTED:String = "soundUnmuted";
		
		public var soundName:String = null;
		
		public function SoundEvent(type:String, soundName:String = null):void
		{
			this.soundName = soundName;
			super(type);
		}
	}
}
