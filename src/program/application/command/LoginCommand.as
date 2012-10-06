package program.application.command
{
	import com.examyes.flex.tools.Utils;
	
	import mx.controls.Alert;
	import mx.logging.*;
	
	import program.application.message.LocalFileMessage;
	import program.application.message.LoginMessage;
	import program.domain.User;
	import program.domain.UserInfo;
	import program.domain.WebProtocol;
	import program.infrastructure.LocalFileService;
	import program.infrastructure.LoginService;
	import program.infrastructure.ServiceResult;

	public class LoginCommand
	{
		private var LOG:ILogger = Utils.getLogger(this);
		private var userTmp:String;
		private var passTmp:String;
		[Inject]
		public var loginService:LoginService;
		
		[Inject]
		public var userInfo:UserInfo;
		
		[MessageDispatcher]
		public var send:Function;
		public var callback:Function;
		
		public function LoginCommand()
		{
		}
		
		public function execute(msg:LoginMessage):void
		{
			userTmp = msg.user.name;
			passTmp = msg.user.pass;
			loginService.login(serviceHandler,msg.user.name+"--"+msg.user.pass);
		}
		
		public function serviceHandler(result:String,xml:XML):void
		{
			if(ServiceResult.SUCCESS == result)
			{
				//Alert.show("登录成功:\n" + xml);
				if("0" == xml.result.@message)
				{
					send(new LoginMessage(LoginMessage.LOGIN_FAILED).setLog("账号或密码错误"));
				}
				else
				{
					userInfo.setUser(new User(userTmp,passTmp).setUid(xml.uid.@message));
					send(new LoginMessage(LoginMessage.LOGIN_SUCCESSED).setLog(xml.toString()));
					var localdata:String = WebProtocol.buildLocalData(userTmp,passTmp,xml.uid.@message);
					send(new LocalFileMessage(LocalFileMessage.SAVE_LOCAL_DATA).SetData(localdata));
				}
			}
			else
			{
				//send(new LoginMessage(LoginMessage.LOGIN_FAILED).setLog("服务端出错"));
				send(new LoginMessage(LoginMessage.LOGIN_SUCCESSED));
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