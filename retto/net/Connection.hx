package retto.net;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.events.*;
import openfl.net.Socket;
import openfl.system.Security;

/**
 * Represents a connection to a remote computer.
 * It uses a concept of commands and data.
 * The command is an identifier that defines what should be done and
 * the data is optional and provides additional information.
 * @author Christoph Otter
 */
class Connection
{
	var socket = new Socket (); //this is based on TCP, not UDP ;(
	
	var last = 0.0;
	
	public function new (host : String, port : Int)
	{
		Security.allowDomain ("*");
		
		/*socket.addEventListener (Event.CONNECT, onConnect);
		socket.addEventListener (Event.CLOSE, onClose);*/
		socket.addEventListener (ProgressEvent.SOCKET_DATA, onResponse);
		#if debug
		socket.addEventListener (IOErrorEvent.IO_ERROR, onError);
		socket.addEventListener (SecurityErrorEvent.SECURITY_ERROR, onSecError);
		#end
		
		socket.connect (host, port);
	}
	
	/**
	 * This is called when data arrives
	 */
	public dynamic function onReceive (command : String, ?data : Dynamic) : Void //TODO: change for server?
	{
	}
	
	/**
	 * Use this to send data to the server.
	 * @param	command an identifier telling the server what to do
	 * @param	data use it to give more information to the server
	 */
	public function sendCommand (command : String, ?data : Dynamic) : Void
	{
		var serializer = new Serializer ();
		
		serializer.serialize (command);
		serializer.serialize (data);
		socket.writeUTFBytes (serializer.toString ());
		try {
			socket.flush ();
		}
		catch (e : Dynamic) {
		}
		
	}
	
	/*function onConnect (e : Event) : Void
	{
		//send some id?
		//socket.writeUTFBytes ("hi");
	}
	
	function onClose (e : Event) : Void
	{
		//socket.close ();
	}*/
	
	function onError (e : IOErrorEvent) : Void
	{
		#if debug
		trace ("IOError: " + e);
		#end
	}
	
	function onResponse (e : ProgressEvent) : Void
	{
		if (socket.bytesAvailable > 0) {
			var dataString = socket.readUTFBytes (socket.bytesAvailable);
			var unserializer = new Unserializer (dataString);
			
			var command = unserializer.unserialize ();
			var data = unserializer.unserialize ();
			
			onReceive (command, data);
		}
	}
	
	function onSecError (e : SecurityErrorEvent) : Void
	{
		#if debug
		trace ("SecurityError: " + e);
		#end
	}
	
}