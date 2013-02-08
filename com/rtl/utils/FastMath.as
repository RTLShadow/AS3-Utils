package com.rtl.utils
{
	
	/**
	 *
	 * @author RTLShadow
	 *
	 */
	public class FastMath
	{
		public static var DEGREES_TO_RADIANS:Number = Math.PI / 180;
		public static var RADIANS_TO_DEGREES:Number = 180 / Math.PI;
		
		public static function randomNum( min:Number, max:Number ):Number
		{
			return min + ( max - min ) * Math.random();
		}
		
		public static function calculateDistance( x1:Number, y1:Number, x2:Number, y2:Number ):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt( dx * dx + dy * dy );
		}
		
		public static function smallestNum( arr:Array ):Number
		{
			var sNum:Number = Infinity;
			for ( var i:int = 0; i < arr.length; i++ )
			{
				if ( arr[ i ] < sNum )
				{
					sNum = arr[ i ];
				}
			}
			return sNum;
		}
		
		public static function largestNum( arr:Array ):Number
		{
			var lNum:Number = Number.MIN_VALUE;
			for ( var i:int = 0; i < arr.length; i++ )
			{
				if ( arr[ i ] > lNum )
				{
					lNum = arr[ i ];
				}
			}
			return lNum;
		}
		
		public static function toRadians( deg:Number ):Number
		{
			return deg * DEGREES_TO_RADIANS;
		}
		
		public static function toDegrees( rad:Number ):Number
		{
			return rad * RADIANS_TO_DEGREES;
		}
	
	}
}