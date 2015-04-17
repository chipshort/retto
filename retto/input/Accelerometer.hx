package retto.input;
import openfl.events.AccelerometerEvent;
import openfl.sensors.Accelerometer in FLAccelerometer;

/**
 * This class handles access to the Accelerometer on Smartphones / Tablets.
 * @author Christoph Otter
 */
class Accelerometer //TODO: test this
{
	/**
	 * Math.NaN if there is no accelerometer, otherwise the x acceleration.
	 */
	static var accelX (default, null) : Float = Math.NaN;
	/**
	 * Math.NaN if there is no accelerometer, otherwise the y acceleration
	 */
	static var accelY (default, null) : Float = Math.NaN;
	/**
	 * Math.NaN if there is no accelerometer, otherwise the z acceleration
	 */
	static var accelZ (default, null) : Float = Math.NaN;
	
	static var accel : FLAccelerometer;

	public static function init ()
	{
		if (hasAccelerometer ()) {
			accel = new FLAccelerometer ();
			accel.addEventListener (AccelerometerEvent.UPDATE, update);
		}
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