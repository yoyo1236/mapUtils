package program.application.command
{
	import com.examyes.flex.tools.Utils;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.logging.*;
	
	import program.application.message.LocalFileMessage;
	import program.application.message.LoginMessage;
	import program.application.message.SocketMessage;
	import program.domain.SocketProtocol;
	import program.domain.User;
	import program.domain.UserInfo;
	import program.infrastructure.ServiceResult;
	import program.infrastructure.SocketService;

	public class ConnectSocketServerCommand
	{
		private var LOG:ILogger = Utils.getLogger(this);
		public var callback:Function;
		[Inject]
		public var socketService:SocketService;
		
		[Inject]
		public var userInfo:UserInfo;
		
		[MessageDispatcher]
		public var send:Function;
		
		public function execute(msg:SocketMessage):void
		{
			socketService.connectServer(connectHandler);
		}
		
		public function connectHandler(result:String):void
		{
			if (ServiceResult.SUCCESS == result)
			{
				send(new SocketMessage(SocketMessage.CONNECT_SOCKET_SERVER_SUCCESS,userInfo.getUser()));
			}
			callback(result);
		}
		
		[Destroy]
		public function destroy (): void 
		{
			LOG.debug("Destroy");
		}
	}
}