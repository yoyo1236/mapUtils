package program.infrastructure
{
	import com.examyes.flex.services.XMLHTTPService;
	import com.examyes.flex.tools.ExtJS;
	import com.examyes.flex.tools.Utils;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.logging.*;
	import mx.rpc.events.FaultEvent;
	
	import program.application.message.DialogMessage;
	import program.application.message.LoginMessage;
	import program.application.message.SocketMessage;
	import program.domain.User;
	
	public class SocketService
	{
		private var LOG:ILogger = Utils.getLogger(this);
		private var service:XMLHTTPService;
		private var connectHandler:Function;
		private var uploadDiscussListHandler:Function;
		private var url:String;
		
		private var mySocket:Socket;
		
		[MessageDispatcher]
		public var send:Function;
		
		public function SocketService()
		{
			
				
			//Security.loadPolicyFile("http://localhost:8081/crossdomain.xml");
			//Security.loadPolicyFile("xmlsocket://127.0.0.1:843");
			Security.loadPolicyFile("xmlsocket://192.168.1.120:843");
			mySocket = new Socket();  
			mySocket.addEventListener(Event.CONNECT,onConnect);
			mySocket.addEventListener(Event.CLOSE,onClosed);
			mySocket.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
			mySocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSeurity);
			mySocket.addEventListener(ProgressEvent.SOCKET_DATA,onReceiveData);
		}
		
		[Init]
		public function init():void
		{
			LOG.debug("Init");
		}
		
		public function connectServer(_connectHandler:Function):void
		{
			connectHandler = _connectHandler;
			url = ExtJS.call("getSocketServerUrl");
			LOG.debug("ExtJS get Server Url: {0}", url);
			mySocket.connect( url ,9999); 
		}
		
		public function sendSocketContent(sendDataHandler:Function,content:String):void
		{	
			try
			{  
				mySocket.writeUTFBytes(content+"\n");
				mySocket.flush();//发送数据
				sendDataHandler(ServiceResult.SUCCESS);
			}
			catch(ex:Error)
			{
				
			} 
		}
		
		//接收
		private function onReceiveData(evt:ProgressEvent):void
		{
			while(mySocket.bytesAvailable)
			{
				var str:String = mySocket.readUTFBytes(mySocket.bytesAvailable);
				//Alert.show(str);
				var strArr :Array = str.split("\r\n");
				for(var i:int=0;i<strArr.length-1;i++)
				{
					//receiveHandler(strArr[i]);
					send(new SocketMessage(SocketMessage.RECEIVE_SOCKET_MESSAGE,strArr[i]));
				}
			}
		}
		
		//失去连接
		private function onClosed(e:Event):void
		{
			send(new LoginMessage(LoginMessage.LOGOUT));
		}
		
		//IO错误
		private function onIoError(evt:IOErrorEvent):void
		{
			Alert.show(evt.text,"IO错误!");
		}
		
		//安全策略错误
		private function onSeurity(evt:SecurityErrorEvent):void
		{
			Alert.show(evt.text,"安全策略错误!");
		}
		
		//连接成功
		private function onConnect( event:Event ):void 
		{  
			connectHandler(ServiceResult.SUCCESS);
		} 
		
	}
}