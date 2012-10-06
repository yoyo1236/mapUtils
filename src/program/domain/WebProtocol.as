package program.domain
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.spicefactory.lib.reflect.Parameter;

	public class WebProtocol
	{
		//客户端发送，服务端接收
		/*11--用户ID--用户名：新用户加入*/
		public static var NEWUSER_JOIN:String = "11";
		/*22--消息内容：发送公聊消息*/
		public static var PUBLIC_CHAT:String = "22";
		/*33--消息接收者--消息内容：发送私聊消息*/
		public static var PRIVATE_CHAT:String = "33";
		/*44--讨论组名称--讨论组员1--讨论组员2--讨论组员3……：请求建立讨论组*/
		public static var CREATE_NEWDISCUSS_GROUP:String = "44";
		/*55--讨论组名称：加入讨论组*/
		public static var NEWDISCUSS_GROUP_JOIN:String = "55";
		/*66--讨论组名称--消息内容：发送消息到讨论组*/
		public static var SEND_TO_DISCUSSGROUP:String = "66";
		/*88--讨论组名称--退出者ID：退出讨论组*/
		public static var EXIT_DISCUSSGROUP:String = "88";
		/*99*/
		public static var CLOSE_SOCKET:String = "99";
		
		//服务端发送，客户端接收
		/*11--用户1--用户2--用户3……：更新大厅在线列表*/
		public static var UPDATE_CLIENT_LIST:String = "11";
		/*22--消息内容：发送聊天内容*/
		public static var UPDATE_CHAT_CONTENT:String = "22";
		/*33--讨论组名称：新讨论组邀请*/
		public static var NEWDISCUSS_GROUP_INVITING:String = "33";
		/*44--讨论组名称--讨论组员1--讨论组员2--……：更新讨论组列表*/
		public static var UPDATE_DISCUSS_GROUP_LIST:String = "44";
		/*55--讨论组名称--消息内容：发送消息到讨论组*/
		public static var UPDATE_DISCUSS_CONTENT:String = "55";
		/*66--消息内容*/
		public static var UPDATE_ONLINE_NUM:String = "66";
		
		private var data:String;
		private var message:String;
		
		private var param:ArrayCollection;
		
		public function WebProtocol(_data:String)
		{
			data = _data;
			param = new ArrayCollection(data.split("--"));
			//message = param[0];
			message = (String)(param.removeItemAt(0));
		}
		
		public function getMessage():String
		{
			return message;
		}
		
		public function getParam():Array
		{
			return param.source;
		}
		
		public static function buildMessage(type:String,...param):String
		{
			var message:String = null;
			switch(type)
			{
				case CREATE_NEWDISCUSS_GROUP:
					message = CREATE_NEWDISCUSS_GROUP + "--" +param[0];
					for(var i:int=0;i<param[1].length;i++)
					{
						message += "--";
						message += (ClientInfo)(param[1][i]).fid;
						/*message += "--";
						message += (ClientInfo)(param[1][i]).fname;*/
					}
					break;
				case NEWUSER_JOIN:
					var user:User = (User)(param[0]);
					message = NEWUSER_JOIN + "--" + user.uid + "--" + user.name;
					break;
				case PUBLIC_CHAT:
					message = PUBLIC_CHAT + "--" + param[0];
					break;
				case PRIVATE_CHAT:
					message = PRIVATE_CHAT + "--" + param[0] + "--" + param[1];
					break;
				case CLOSE_SOCKET:
					message = CLOSE_SOCKET;
					break;
				case NEWDISCUSS_GROUP_JOIN:
					message = NEWDISCUSS_GROUP_JOIN + "--" + param[0];
					break;
				case SEND_TO_DISCUSSGROUP:
					message = SEND_TO_DISCUSSGROUP + "--" + param[0] + "--" + param[1];
					break;
				case EXIT_DISCUSSGROUP:
					message = EXIT_DISCUSSGROUP + "--" + param[0] + "--" + param[1];
					break;
			}
			return message;
		}
		
		public static function buildLocalData(user:String,pass:String,id:String):String
		{
			var str:String = 
				"<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n"+ 
				"<results>\n"+
				"	<userid message=\""+id+"\" />\n"+
				"	<username message=\""+user+"\" />\n"+
				"	<password message=\""+pass+"\" />\n"+
				"</results>\n";
			return str;
		}
	}
}