package com.rtl.utils
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author RTLShadow
	 */
	public class SoundManager
	{
		private static var soundNames:Array = [];
		private static var soundList:Array = [];
		
		private static var _soundMuted:Boolean = false;
		private static var _musicMuted:Boolean = false;
		private static var _soundVol:Number = 1;
		private static var _musicVol:Number = 1;
		
		public static const SOUND:int = 0;
		public static const MUSIC:int = 1;
		public static const OTHER:int = 2;
		
		/**
		 * Adds a sound to the list of sounds that you can play.
		 * @param	s	The Sound object to add to the list.
		 * @param	name	The name of the sound, you cannot have duplicates in the same list.
		 * @param	type	The type to classify the sound under. Defaults are SOUND(0), MUSIC(1), and OTHER(2). Used to classify what sounds to mute.
		 */
		public static function addSound( s:Sound, name:String, type:int ):void
		{
			if ( soundList[ name ] == undefined )
			{
				var st:SoundTransform = new SoundTransform(( type == SOUND ) ? _soundVol : (( type == MUSIC ) ? _musicVol : 1 ) );
				soundList[ name ] = { sound: s, // sound object
						transform: st, // SoundTransform
						channel: s.play(), // SoundChannel
						type: type, // the type of sound (i.e. SOUND, MUSIC, OTHER)
						isPlaying: false }; // if the sound is currently playing
				
				soundNames.push( name );
				soundList[ name ].channel.stop();
				
			}
			else
			{
				throw( new Error( "The name '" + name + "' already exists for a sound name." ) )
			}
		}
		
		/**
		 * Removes a sound from the list of sounds
		 * @param	name	The name of the sound you want to remove.
		 */
		public static function removeSound( name:String ):void{
			if( soundList[name] ) {
				
				soundNames.splice(soundNames.indexOf( name ), 1); // Remove the name from soundNames array
				
				stopSound(name); // Stop the sound
				
				soundList[name] = null; // Null out the value
				
				delete soundList[name]; // Delete the 'name' property from the soundList array object
				
			} else {
				throw (new Error("The name '" + name + "' does not exist in the sound list."))
			}
		}
		
		/**
		 * Play a sound from the current list. The sound must have been added through the 'addSound()' function before playing it.
		 * @param	name		The name of the sound to play.
		 * @param	loops	The amount to loop the sound, the default is 0. -1 to repeat infinitely.
		 */
		public static function playSound( name:String, loops:int = 0 ):void
		{
			if ( soundList[ name ] != undefined )
			{
				soundList[ name ].channel = soundList[ name ].sound.play( 0, // position
					( loops == -1 ) ? int.MAX_VALUE : loops, // loop amount
					soundList[ name ].transform ); // transform to apply
				
				soundList[ name ].isPlaying = true;
				soundList[ name ].channel.addEventListener( Event.SOUND_COMPLETE, soundComplete );
			}
			else
			{
				throw( new Error( "Sound '" + name + "' does not exist." ) );
			}
		}
		
		private static function soundComplete( e:Event ):void
		{
			// TODO Find a better way to do this entire function
			for ( var i:int = soundList.length - 1; i >= 0; --i )
			{
				if ( soundList[ i ].channel == e.target )
				{
					soundList[ i ].isPlaying = false;
					break;
				}
			}
		}
		
		/**
		 * Stop the sound being played.
		 * @param	name	The name of the sound to stop.
		 */
		public static function stopSound( name:String ):void
		{
			if ( soundList[ name ].sound != undefined )
			{
				soundList[ name ].channel.stop();
			}
			else
			{
				throw( new Error( "Sound '" + name + "' does not exist." ) );
			}
		}
		
		public static function isPlaying( name:String ):Boolean
		{
			return soundList[ name ].isPlaying;
		}
		
		/**
		 * Get the SoundTransform object of a specific sound.
		 * @param	name
		 * @return	The current SoundTransform of the sound.
		 */
		public static function getTransform( name:String ):SoundTransform
		{
			return soundList[ name ].transform;
		}
		
		/**
		 * Set the SoundTransform of a sound.
		 * @param	name			The name of the sound to set a new SoundTransform.
		 * @param	sTransform	SoundTransform object to set as the new soundTransform.
		 */
		public static function setTransform( name:String, sTransform:SoundTransform ):void
		{
			soundList[ name ].transform = sTransform;
			soundList[ name ].channel.soundTransform = sTransform;
		}
		
		/**
		 * See if all sounds of type 'SOUND' are muted.
		 */
		static public function get soundMuted():Boolean
		{
			return _soundMuted;
		}
		
		/**
		 * Mute all sounds of type 'SOUND'.
		 */
		static public function set soundMuted( m:Boolean ):void
		{
			_soundMuted = m;
			var s:String = "";
			var currTransform:SoundTransform;
			for each ( s in soundNames )
			{
				if ( soundList[ s ].type == SOUND )
				{
					currTransform = getTransform( s );
					if ( m )
						currTransform.volume = 0;
					else
						currTransform.volume = _soundVol;
					setTransform( s, currTransform );
				}
			}

			var event:SoundEvent = new SoundEvent((m) ? SoundEvent.SOUND_MUTED : SoundEvent.SOUND_UNMUTED);
			dispatchEvent(event); // don't pass in any sound names, as this pertains to all sounds
		}
		
		/**
		 * See if all sounds of type 'MUSIC' are muted.
		 */
		static public function get musicMuted():Boolean
		{
			return _musicMuted;
		}
		
		/**
		 * Mute all sounds of type 'MUSIC'.
		 */
		static public function set musicMuted( m:Boolean ):void
		{
			_musicMuted = m;
			_soundMuted = m;
			var s:String = "";
			var currTransform:SoundTransform;
			for each ( s in soundNames )
			{
				if ( soundList[ s ].type == MUSIC )
				{
					currTransform = getTransform( s );
					if ( m )
						currTransform.volume = 0;
					else
						currTransform.volume = _musicVol;
					setTransform( s, currTransform );
				}
			}

			var event:SoundEvent = new SoundEvent((m) ? SoundEvent.MUSIC_MUTED : SoundEvent.MUSIC_UNMUTED);
			dispatchEvent(event); // don't pass in any sound names, as this pertains to all sounds
		}
		
		static public function get soundVol():Number
		{
			return _soundVol;
		}
		
		static public function set soundVol( s:Number ):void
		{
			_soundVol = s;
			var str:String = "";
			var currTransform:SoundTransform;
			for each ( str in soundNames )
			{
				if ( soundList[ str ].type == SOUND )
				{
					currTransform = getTransform( str );
					currTransform.volume = _soundVol;
					setTransform( str, currTransform );
				}
			}
		}
		
		static public function get musicVol():Number
		{
			return _musicVol;
		}
		
		static public function set musicVol( m:Number ):void
		{
			_musicVol = m;
			var str:String = "";
			var currTransform:SoundTransform;
			for each ( str in soundNames )
			{
				if ( soundList[ str ].type == MUSIC )
				{
					currTransform = getTransform( str );
					currTransform.volume = _musicVol;
					setTransform( str, currTransform );
				}
			}
		}
	}

}
