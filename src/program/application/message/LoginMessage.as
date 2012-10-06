package program.application.message
{
	import program.domain.User;
	public class LoginMessage
	{
		public static const LOGIN:String = "login";
		public static const LOGOUT:String = "logout";
		
		public static const LOGIN_SUCCESSED:String = "loginSuccessed";
		public static const LOGIN_FAILED:String = "loginFailed";
		
		public static const ONLINE_QUERY:String = "onlineQuery";
		public static const ONLINE_QUERY_COMPLETE:String = "onlineQueryComplete";
		
		[Selector]
		public var type:String;
		public var user:User;
		public var isOnline:Boolean;
		public var log:String;
		
		
		public function LoginMessage(_type:String,_isOnline:Boolean = false)
		{
			type = _type;
			isOnline = _isOnline;
		}
		
		public function setUser(_user:User):LoginMessage
		{
			user = _user;
			return this;
		}
		
		public function setLog(_log:String):LoginMessage
		{
			log = _log;
			return this;
		}
		
		public function getLog():String
		{
			return log;
		}
		

	}
}