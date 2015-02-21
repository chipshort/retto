package retto.util;

/**
 * ...
 * @author Christoph Otter
 */
class ObjMap<K, V> implements Map.IMap<K,V>
{
	var keyList = new Array<K> ();
	var values = new Array<V> ();
	
	public function new () : Void
	{
	}
	
	public function get (k : K) : Null<V>
	{
		var i = keyList.indexOf(k);
		
		if (i == -1) return null;
		
		return values[i];
	}
	
	public function set (k : K, v : V) : Void
	{
		var i = keyList.indexOf(k);
		
		if (i == -1) {
			keyList.push (k);
			values.push (v);
		}
		else {
			keyList[i] = k;
			values[i] = v;
		}
	}
	
	public function exists (k : K) : Bool
	{
		return keyList.indexOf (k) != -1;
	}
	
	public function remove (k : K) : Bool
	{
		var i = keyList.indexOf(k);
		
		
		return keyList.remove (k) && values.remove (values[i]);
	}
	
	public function keys () : Iterator<K>
	{
		return keyList.iterator ();
	}
	
	public function iterator () : Iterator<V>
	{
		return values.iterator ();
	}
	
	public function toString () : String
	{
		return Std.string (this);
	}
}