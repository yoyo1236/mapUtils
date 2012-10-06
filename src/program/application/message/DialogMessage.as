package program.application.message
{
	import program.domain.User;

	public class DialogMessage
	{
		public static var SEND_DIALOG_MESSAGE:String = "sendDialogMessage";
		public static var SEND_DIALOG_MESSAGE_COMPLETE:String = "sendDialogMessageComplete";
		
		public static var CONNECT_SOCKET_SERVER:String = "connectSocketServer";
		public static var CONNECT_SOCKET_SERVER_COMPLETE:String = "connectSocketServerComplete";
		
		public static var FRESH_DIALOG:String = "freshDialog";
		public static var APPLICATION_COMPLETE:String = "applicationComplete";
		
		//public static var GET_USER_LIST:String = "getUserList";
		
		public var self:User;
		public var target:User;
		public var content:String;
		[Selector]
		public var type:String;
		
		public function DialogMessage(_type:String)
		{
			type = _type;
		}
		
		public function setSelf(_self:User):DialogMessage
		{
			self = _self;
			return this;
		}
		
		public function setTarget(_target:User):DialogMessage
		{
			target = _target;
			return this;
		}
		
		public function setContent(_content:String):DialogMessage
		{
			content = _content;
			return this;
		}
	}
}