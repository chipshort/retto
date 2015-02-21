package retto.util;

/**
 * ...
 * @author Christoph Otter
 */
class OrderedIntMap<T> implements Map.IMap<Int, T>
{
	public var length (get, null) : Int;
	
	var map = new Map<Int, T> ();
	var keyList = new Array<Int> ();
	
	inline function get_length () : Int
		return keyList.length;
	
	public function new ()
	{
	}
	
	public function get (k : Int) : Null<T>
	{
		return map.get (k);
	}
	
	public function set (k : Int, v : T) : Void
	{
		if (!map.exists (k)) keyList.push (k);
		map.set (k, v);
	}
	
	public function exists (k : Int) : Bool
	{
		return map.exists (k);
	}
	
	public function remove (k : Int) : Bool
	{
		keyList.remove (k);
		return map.remove (k);
	}
	
	public function sort (f : Int -> Int -> T -> T -> Int) : Void
	{
		keyList.sort (function (i1, i2) {
			return f (i1, i2, map.get (i1), map.get (i2));
		});
	}
	
	public function keys () : Iterator<Int>
	{
		return keyList.iterator ();
	}
	
	public function iterator () : Iterator<T>
	{
		var keys = keyList.iterator ();
		var _map = map;
		return {
			next: function () {
				return _map.get (keys.next ());
			},
			hasNext: function () {
				return keys.hasNext (); //does not work without surrounding function, for some reason?
			}
		}
	}
	
	public function toMap () : Map<Int, T>
	{
		return map;
	}
	
	public function toString () : String
	{
		return map.toString ();
	}
}