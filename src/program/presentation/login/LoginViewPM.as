package program.presentation.login
{
	import com.examyes.flex.tools.Utils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.logging.*;
	
	import program.application.message.LocalFileMessage;
	import program.application.message.LoginMessage;
	import program.domain.User;

	public class LoginViewPM
	{
		private var LOG:ILogger = Utils.getLogger(this);
		private var user:User;
		
		[MessageDispatcher]
		public var send:Function;
		
		[Bindable]
		public var loginStatus:int=0;
		
		[Init]
		public function init():void
		{
			LOG.debug("Init");
		}
		
		public function login(uname:String,upass:String):void
		{
			loginStatus = 0;
			user = new User(uname, upass);
			send(new LoginMessage(LoginMessage.LOGIN).setUser(user));
		}
		
		[MessageHandler(selector="loginSuccessed")]
		public function loginSuccessedHandler(msg:LoginMessage):void
		{
			loginStatus = 1;
		}
		
		[MessageHandler(selector="loginFailed")]
		public function loginFailedHandler(msg:LoginMessage):void
		{
		}
		
		[MessageHandler(selector="logout")]
		public function logoutHandler(msg:LoginMessage):void
		{
			loginStatus = 0;
			send(new LocalFileMessage(LocalFileMessage.SAVE_LOCAL_DATA).SetData(""));
		}
	}
}