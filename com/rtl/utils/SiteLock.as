package com.rtl.utils
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author RTLShadow
	 */
	public class SiteLock
	{
		public var _url:String;
		
		private var _lTesting:Boolean;
		private var _wArray:Array;
		private var _bArray:Array;
		private var _blacklisted:Boolean;
		private var _whitelisted:Boolean;
		
		private var stage:Stage;
		
		/**
		 * @param	localTesting Whether or not you want to allow local testing.
		 */
		public function SiteLock( stageRef:Stage, localTesting:Boolean, whitelistArray:Array, blacklistArray:Array )
		{
			stage = stageRef;
			_lTesting = localTesting;
			_wArray = whitelistArray;
			_bArray = blacklistArray;
			_url = stage.loaderInfo.url;
		}
		
		/**
		 * Check if the current site is allowed.
		 */
		public function get isAllowed():Boolean
		{
			var a:Boolean;
			
			var i:int = 0;
			while ( i < _wArray.length ) // If "i" is less than array length.
			{
				if ( _url.search( _wArray[ i ] ) != -1 ) // See if the next url in the array is the current one...
				{
					_whitelisted = true; // Set whitelisted to true
					break; // Break the while statement.
				}
				i++;
			}
			if ( !_whitelisted ) // If it's not whitelisted. (In case the URL is on the whitelist and blacklist for some reason.)
			{
				i = 0; // Reset i.
				while ( i < _bArray.length ) //  If "i" is less than array.
				{
					if ( _url.search( _bArray[ i ] ) != -1 ) // See if the next url in the array is the current one...
					{
						_blacklisted = true; // Set blacklisted to false.
						break; // Break the while statement.
					}
					i++;
				}
			}
			
			if ( _whitelisted ) // If whitelisted...
			{
				a = true;
			}
			else if ( _blacklisted ) // Else if blacklisted...
			{
				a = false;
			}
			else // If not blacklisted or whitelisted.
			{
				if ( _lTesting ) // If local testing is allowed.
				{
					( isLocal ) ? a = true : a = false; // If the URl is local, allow. If not, disallow.
				}
				else // If not local, blacklisted, or whitelisted...
				{
					a = false; // disallow.
				}
			}
			return a;
		}
		
		/**
		 * Check if the SWF is being played locally.
		 */
		public function get isLocal():Boolean
		{
			var local:Boolean;
			if ( _url.search( "file://" ) != -1 )
			{
				local = true;
			}
			else
			{
				local = false;
			}
			return local;
		}
		
		/**
		 * Allow/Disallow local testing of your swf.
		 * @param	allowLocal
		 */
		public function set localTesting( allowLocal:Boolean ):void
		{
			_lTesting = allowLocal;
		}
		
		/**
		 * Specify which sites to allow.
		 * @param	siteArray Array of sites to allow.
		 */
		public function set allowedSites( siteArray:Array ):void
		{
			_wArray = siteArray;
		}
		
		public function get allowedSites():Array
		{
			return _wArray;
		}
		
		/**
		 * Specify which sites to deny.
		 * @param	siteArray Array of sites to deny.
		 */
		public function set deniedSites( siteArray:Array ):void
		{
			_bArray = siteArray;
		}
		
		public function get deniedSites():Array
		{
			return _bArray;
		}
		
		/**
		 * The current URL of the .swf
		 */
		public function get url():String
		{
			return _url;
		}
	}
}