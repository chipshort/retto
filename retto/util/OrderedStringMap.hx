package retto.util;

/**
 * ...
 * @author Christoph Otter
 */
class OrderedStringMap<T> implements Map.IMap<String, T>
{
	public var length (get, null) : Int;
	
	var map = new Map<String, T> ();
	var keyList = new Array<String> ();
	
	inline function get_length () : Int
		return keyList.length;

	public function new ()
	{
	}
	
	public function get (k : String) : Null<T>
	{
		return map.get(k);
	}
	
	public function set (k : String, v : T) : Void
	{
		if (!map.exists (k)) keyList.push (k);
		map.set (k, v);
	}
	
	public function exists (k : String) : Bool
	{
		return map.exists (k);
	}
	
	public function remove (k : String) : Bool
	{
		keyList.remove (k);
		return map.remove (k);
	}
	
	public function sort (f : String -> String -> T -> T -> Int) : Void
	{
		keyList.sort (function (s1, s2) {
			return f (s1, s2, map.get (s1), map.get (s2));
		});
	}
	
	public function keys () : Iterator<String>
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
	
	public function toMap () : Map<String, T>
	{
		return map;
	}
	
	public function toString () : String
	{
		return map.toString ();
	}
}