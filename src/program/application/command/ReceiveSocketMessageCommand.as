package program.application.command
{
	import com.examyes.flex.tools.Utils;
	
	import mx.controls.Alert;
	import mx.logging.*;
	
	import program.application.message.DialogMessage;
	import program.application.message.LoginMessage;
	import program.application.message.SocketMessage;
	import program.domain.SocketProtocol;
	import program.domain.UserInfo;
	import program.infrastructure.ServiceResult;
	import program.infrastructure.SocketService;

	public class ReceiveSocketMessageCommand
	{
		private var LOG:ILogger = Utils.getLogger(this);
		[Inject]
		public var socketService:SocketService;
		[Inject]
		public var socketProtocol:SocketProtocol;
		
		public var callback:Function;
		
		[MessageDispatcher]
		public var send:Function;
		
		
		public function execute(msg:SocketMessage):void
		{
			//var protocol:SocketProtocol = new SocketProtocol();
			//protocol.analysisProtocol((String)(msg.param));
			//send(new SocketMessage( protocol.getSocketMessageType(),  protocol.getParam()));
			send(socketProtocol.analysisMessage((String)(msg.param) ));
			callback();
		}
		
		[Destroy]
		public function destroy (): void 
		{
			LOG.debug("Destroy");
		}
	}
}