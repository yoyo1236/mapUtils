package program.application.command
{
	import com.examyes.flex.tools.Utils;
	
	import mx.controls.Alert;
	import mx.logging.*;
	
	import program.application.message.LocalFileMessage;
	import program.application.message.LoginMessage;
	import program.application.message.SocketMessage;
	import program.domain.User;
	import program.domain.UserInfo;
	import program.infrastructure.ServiceResult;
	import program.infrastructure.SocketService;

	public class SendSocketMessageCommand
	{
		private var LOG:ILogger = Utils.getLogger(this);
		public var callback:Function;
		[Inject]
		public var socketService:SocketService;
		
		[MessageDispatcher]
		public var send:Function;
		
		public function SendSocketMessageCommand()
		{
		}
		
		public function execute(msg:SocketMessage):void
		{
			socketService.sendSocketContent(sendDataHandler,msg.transData);
		}
		
		public function sendDataHandler(result:String):void
		{
			if (ServiceResult.SUCCESS == result)
			{
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