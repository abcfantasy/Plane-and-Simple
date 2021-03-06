/*
* 
*  Author: Simon Joslin
* 
*  Date: Oct 2008
*
*  If you have any questions, post them on my blog 
*  http://blog.psibaspace.net.au/?p=86
* 
* *******/


package GamePads
{
	
import flash.net.Socket;
import flash.events.*
import flash.display.Loader;
import flash.utils.Endian;
import flash.utils.ByteArray;

	//
	// XBOX360Manager manages connection to the socket server
	// and passes relevant portions of the byte stream to 
	// each of the controllers.
	//
	//

	public class XBOX360Manager
	{
		protected	static var	INSTANCE			:XBOX360Manager 	= new XBOX360Manager();
		protected	static var	STREAMLENGTH	:int 							= 184;
		
		protected 	var 			_socket				:Socket;
		protected 	var 			_ipAddress			:String;
		protected 	var			_port						:int;
		protected 	var			_padStates			:Array;
		protected 	var			_connected 			:Boolean					= false;
		
		// create a buffer bytearray to copy incoming inputs
		protected var				_coordsBytes		:ByteArray;
		protected var 			_inputs					:ByteArray; 
		

		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		//
		///////////////////////////////////////////////////////////
		public function XBOX360Manager():void
		{
			// singleton
			if (INSTANCE)
				throw new Error("Can't instantiate XBOX360Manager, call getInstance()");
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		//
		///////////////////////////////////////////////////////////
		public static function getInstance():XBOX360Manager
		{
			return INSTANCE;
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		//
		///////////////////////////////////////////////////////////
		public function connect(ipAddress:String = "localhost", port:int = 0x4a54):void
		{
			_ipAddress = ipAddress;
			_port = port;
			
			_padStates = new Array();
			_padStates.push(new XBOX360PadState(1));
			_padStates.push(new XBOX360PadState(2));
			_padStates.push(new XBOX360PadState(3));
			_padStates.push(new XBOX360PadState(4));
			
			_coordsBytes = new ByteArray();
			_inputs = new ByteArray();
			
			// if already connected, disconnect
			if (_connected)
			{
				_socket.removeEventListener (Event.CONNECT, onSocketConnected);
				_socket.removeEventListener (ProgressEvent.SOCKET_DATA, onSocketData);
				_socket.removeEventListener (IOErrorEvent.IO_ERROR, onSocketError);
				_socket.close();
				_connected = false;
			}
			_socket = new Socket ();
			_socket.addEventListener (Event.CONNECT, onSocketConnected);
			_socket.addEventListener (ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener (IOErrorEvent.IO_ERROR, onSocketError);
			_socket.connect (_ipAddress, _port);
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		//
		///////////////////////////////////////////////////////////
		function onSocketConnected ( pEvt:Event ):void
		{
			trace("XBOX360Manager connected to server at " + _ipAddress + " on port: " + _port);
			_connected = true;
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		//
		///////////////////////////////////////////////////////////
		function onSocketError ( pEvt:IOErrorEvent ):void
		{
			trace("#### XBOX360Manager::onSocketError #### ERROR!! is the server running?");
			throw new Error(pEvt.toString());
			_connected = false;
		}

		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		// when data comes through the connection, wait till the packet
		// is full then send to parseBytes
		///////////////////////////////////////////////////////////
		function onSocketData ( pEvt:Event ):void
		{
			// grab the bytes coming in
			while ( pEvt.target.bytesAvailable > 0 ) 
			{
				_coordsBytes.writeByte ( pEvt.target.readByte() );
				
				// when a full packet is available, parse it
				if ( _coordsBytes.position == XBOX360Manager.STREAMLENGTH ) 
				{
					_inputs.position = 0;
					_inputs.writeBytes ( _coordsBytes );
					_coordsBytes.position = _inputs.position = 0;
					parseBytes ( _inputs );
				}
			}
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		//
		// create a new XBOX360PadState and
		// send the relevant portions of the stream to it.
		// 
		///////////////////////////////////////////////////////////
		protected function parseBytes(pInputs:ByteArray ):void 
		{
			//var numPlayers:int = pInputs.readInt();
			var i:int = 0;
			var playerByteArray:ByteArray;
			
			// loop through each player input and send to the gamepad state
			for (i; i<4; i++)
			{
				playerByteArray = new ByteArray();
				pInputs.readBytes(playerByteArray, 0, 44);
				var newState:XBOX360PadState = new XBOX360PadState(i+1);
				newState.parseBytes(playerByteArray);
				_padStates[i] = newState;
			}
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		// return the requested XBOX360PadState
		///////////////////////////////////////////////////////////
		public function getState(playerIndex:int):XBOX360PadState
		{
			playerIndex--;
			if (playerIndex > _padStates.length-1 ||
				playerIndex < 0)
			{
				throw new Error("playerIndex out of range");
			}
			
			return _padStates[playerIndex];
		}
	}
}