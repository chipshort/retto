package retto.input;
import openfl.events.AccelerometerEvent;
import openfl.sensors.Accelerometer in FLAccelerometer;

/**
 * ...
 * @author Christoph Otter
 */
class Accelerometer //TODO: test this
{
	static var accelX : Float = Math.NaN;
	static var accelY : Float = Math.NaN;
	static var accelZ : Float = Math.NaN;
	
	static var accel : FLAccelerometer;

	public static function init ()
	{
		if (hasAccelerometer ()) {
			accel = new FLAccelerometer ();
			accel.addEventListener (AccelerometerEvent.UPDATE, update);
		}
	}
	
	/**
	 * @return Math.NaN if there is no accelerometer, otherwise it returns the x acceleration
	 */
	public static function getX () : Float
	{
		return accelX;
	}
	
	/**
	 * @return Math.NaN if there is no accelerometer, otherwise it returns the y acceleration
	 */
	public static function getY () : Float
	{
		return accelY;
	}
	
	/**
	 * @return Math.NaN if there is no accelerometer, otherwise it returns the z acceleration
	 */
	public static function getZ () : Float
	{
		return accelZ;
	}
	
	public static function hasAccelerometer ()
	{
		return FLAccelerometer.isSupported;
	}
	
	static function update (e : AccelerometerEvent)
	{
		accelX = e.accelerationX;
		accelY = e.accelerationY;
		accelZ = e.accelerationZ;
	}
	
}