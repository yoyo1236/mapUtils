package program.application.command
{
	import com.examyes.flex.tools.Utils;
	
	import mx.controls.Alert;
	import mx.logging.*;
	
	import program.application.message.LocalFileMessage;
	import program.application.message.LoginMessage;
	import program.domain.User;
	import program.domain.UserInfo;
	import program.infrastructure.LocalFileService;
	import program.infrastructure.LoginService;
	import program.infrastructure.ServiceResult;

	public class loadLocalDataCommand
	{
		private var LOG:ILogger = Utils.getLogger(this);
		public var callback:Function;
		[Inject]
		public var localFileService:LocalFileService;
		
		[MessageDispatcher]
		public var send:Function;
		
		public function loadLocalDataCommand()
		{
		}
		
		public function execute(event:LocalFileMessage):void
		{
			localFileService.loadLocalData(loadLocalHandler);
		}
		
		public function loadLocalHandler(result:String,xml:XML):void
		{
			if (ServiceResult.SUCCESS == result)
			{
				send(new LoginMessage(LoginMessage.LOGIN).setUser(new User(xml.username.@message,xml.password.@message)));
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