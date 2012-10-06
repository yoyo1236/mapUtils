package program.domain
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.spicefactory.lib.reflect.Parameter;
	
	import program.application.message.LoginMessage;
	import program.application.message.SocketMessage;
	import program.domain.analyzer.ProtocolAnalyzer;
	import program.domain.analyzer.SocketProtocolAnalyzer;
	import program.domain.builder.*;
	import program.domain.director.ProtocolDirector;
	import program.domain.director.SocketProtocolDirector;

	public class SocketProtocol
	{
		//客户端发送，服务端接收
		/*11--用户ID--用户名：新用户加入*/
		public static var NEW_USER_JOIN:String = "CNUJ";
		/*22--消息内容：发送公聊消息*/
		public static var PUBLIC_CHAT:String = "CPUC";
		/*33--消息接收者--消息内容：发送私聊消息*/
		public static var PRIVATE_CHAT:String = "CPRC";
		/*44--讨论组名称--讨论组员1--讨论组员2--讨论组员3……：请求建立讨论组*/
		public static var CREATE_NEWDISCUSS_GROUP:String = "CCDG";
		/*55--讨论组名称：加入讨论组*/
		public static var NEW_DISCUSS_GROUP_JOIN:String = "CNDGJ";
		/*66--讨论组名称--消息内容：发送消息到讨论组*/
		public static var SEND_TO_DISCUSSGROUP:String = "CSTD";
		/*88--讨论组名称--退出者ID：退出讨论组*/
		public static var EXIT_DISCUSSGROUP:String = "CED";
		/*99*/
		public static var CLOSE_SOCKET:String = "CCS";
		
		//服务端发送，客户端接收
		/*11--用户1--用户2--用户3……：更新大厅在线列表*/
		public static var UPDATE_CLIENT_LIST:String = "SUCL";
		/*22--消息内容：发送聊天内容*/
		public static var UPDATE_CHAT_CONTENT:String = "SUCC";
		/*33--讨论组名称：新讨论组邀请*/
		public static var NEWDISCUSS_GROUP_INVITING:String = "SDGI";
		/*44--讨论组名称--讨论组员1--讨论组员2--……：更新讨论组列表*/
		public static var UPDATE_DISCUSS_GROUP_LIST:String = "SUDGL";
		/*55--讨论组名称--消息内容：发送消息到讨论组*/
		public static var UPDATE_DISCUSS_CONTENT:String = "SUDC";
		/*66--消息内容*/
		public static var UPDATE_ONLINE_NUM:String = "SUON";
		
		private var data:String;
		public  var message:String;
		
		private var param:ArrayCollection;
		
		[MessageDispatcher]
		public var send:Function;
		
		public function SocketProtocol()
		{
		}
		
		/*public function analysisProtocol(_data:String)
		{
			data = _data;
			param = new ArrayCollection(data.split("--"));
			//message = param[0];
			message = (String)(param.removeItemAt(0));
		}*/
		
		
		public function getParam():Array
		{
			return param.source;
		}
		
		public function buildMessage(socketType:String,protocolType:String, ...param):SocketMessage
		{
			var parameter:Object = new Object();
			var func:Function = null;
			
			switch(protocolType)
			{
				case CREATE_NEWDISCUSS_GROUP:
					parameter["groups"] = param[0][0];
					parameter["users"] = param[0][1];
					break;
				case NEW_USER_JOIN:
					parameter["users"] = param[0];
					break;
				case PUBLIC_CHAT:
					parameter["content"] = param[0];
					break;
				case PRIVATE_CHAT:
					parameter["users"] = param[0][0];
					parameter["content"] = param[0][1];
					break;
				case CLOSE_SOCKET:
					break;
				case NEW_DISCUSS_GROUP_JOIN:
					parameter["groups"] = param[0];
					break;
				case SEND_TO_DISCUSSGROUP:
					parameter["groups"] = param[0][0];
					parameter["content"] = param[0][1];
					break;
				case EXIT_DISCUSSGROUP:
					parameter["groups"] = param[0];
					break;
			}
				
			return new SocketMessage(socketType,buildProtocol(protocolType,parameter))
			
		}
		
		
		[MessageHandler(selector="sendPublicContent")]
		public function sendPublicContentHandler(msg:SocketMessage):void
		{
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.PUBLIC_CHAT,msg.param);
			//var str:String = buildMessage(SocketProtocol.PUBLIC_CHAT,msg.param);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,PUBLIC_CHAT,msg.param));
		}
		
		[MessageHandler(selector="sendPrivateContent")]
		public function sendPrivateContentHandler(msg:SocketMessage):void
		{
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.PRIVATE_CHAT,msg.param[0],msg.param[1]);
			//var str:String = buildMessage(SocketProtocol.PRIVATE_CHAT,msg.param);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,PRIVATE_CHAT,msg.param));
		}
		
		[MessageHandler(selector="sendDiscussGroupContent")]
		public function sendDiscussGroupContentHandler(msg:SocketMessage):void
		{
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.SEND_TO_DISCUSSGROUP,msg.param[0],msg.param[1]);
			//var str:String = buildMessage(SocketProtocol.SEND_TO_DISCUSSGROUP,msg.param);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,SEND_TO_DISCUSSGROUP,msg.param));
		}
		
		[MessageHandler(selector="connectSocketServerSuccess")]
		public function connectSocketServerSuccessHandler(msg:SocketMessage):void
		{
			var user:ArrayCollection = new ArrayCollection();
			user.addItem(msg.param);
			//var str:String = buildMessage(SocketProtocol.NEWUSER_JOIN,user);
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.NEWUSER_JOIN,msg.param);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,NEW_USER_JOIN,user));
		}
		
		[MessageHandler(selector="createDiscussGroup")]
		public function uploadDiscussListHandler(msg:SocketMessage):void
		{
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.CREATE_NEWDISCUSS_GROUP,msg.param[0],msg.param[1]);
			//var str:String = buildMessage(SocketProtocol.CREATE_NEWDISCUSS_GROUP,msg.param);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,CREATE_NEWDISCUSS_GROUP,msg.param));
		}
		
		[MessageHandler(selector="AgreeForDiscussGroupInviting")]
		public function AgreeForDiscussGroupInvitingHandler(msg:SocketMessage):void
		{
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.NEWDISCUSS_GROUP_JOIN,msg.param);
			//var str:String = buildMessage(SocketProtocol.NEWDISCUSS_GROUP_JOIN,msg.param);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,NEW_DISCUSS_GROUP_JOIN,msg.param));
		}
		
		[MessageHandler(selector="logout")]
		public function logoutHandler(msg:LoginMessage):void
		{
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.CLOSE_SOCKET);
			//var str:String = buildMessage(SocketProtocol.CLOSE_SOCKET);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,CLOSE_SOCKET));
		}
		
		[MessageHandler(selector="exitDiscussGroup")]
		public function exitDiscussGroupHandler(msg:SocketMessage):void
		{
			//var str:String = SocketProtocol.buildMessage(SocketProtocol.EXIT_DISCUSSGROUP,msg.param[0],msg.param[1]);
			//var str:String = buildMessage(SocketProtocol.EXIT_DISCUSSGROUP,msg.param);
			//send(new SocketMessage(SocketMessage.SEND_SOCKET_MESSAGE,str));
			send(buildMessage(SocketMessage.SEND_SOCKET_MESSAGE,EXIT_DISCUSSGROUP,msg.param));
		}
		
		public function getSocketMessageType(message:String):String
		{
			switch(message)
			{
				case SocketProtocol.UPDATE_CLIENT_LIST:
					message = SocketMessage.UPDATE_CLIENT_LIST;
					break;
				case SocketProtocol.UPDATE_CHAT_CONTENT:
					message = SocketMessage.RECEIVED_PUBLIC_CONTENT;
					break;
				case SocketProtocol.UPDATE_ONLINE_NUM:
					message = SocketMessage.ONLINE_NUM;
					break;
				case SocketProtocol.UPDATE_DISCUSS_GROUP_LIST:
					message = SocketMessage.UPDATE_DISCUSS_GROUP_LIST;
					break;
				case SocketProtocol.NEWDISCUSS_GROUP_INVITING:
					message = SocketMessage.NEWDISCUSS_GROUP_INVITING;
					break;
				case SocketProtocol.UPDATE_DISCUSS_CONTENT:
					message = SocketMessage.RECEIVED_DISCUSS_GROUP_CONTENT;
					break;
				default:
					message = SocketMessage.NO_MESSAGE;
					break;
			}
			return message;
		}
		
		public function buildProtocol(protocolType:String,param:Object):String
		{
			var director:ProtocolDirector = new SocketProtocolDirector();
			
			var builder:ProtocolBuilder = ProtocolBuilder.createBuilder(protocolType,param["groups"],param["users"],param["content"]);//createBuilder(protocolType,param);
			
			var xml:XML = director.buildProtocol(builder) as XML;
			var protocolStr:String = replaceAll(xml.toXMLString(),"\n","");
			
			return protocolStr;
		}
		
		public function analysisMessage(msg:String):SocketMessage
		{
			var analysis:ProtocolAnalyzer = new SocketProtocolAnalyzer();
			analysis.analysis(msg);
			//param = new ArrayCollection(data.split("--"));
			//message = param[0];
			//message = (String)(param.removeItemAt(0));
			//var builder:ProtocolBuilder = ProtocolBuilder.createBuilder(protocolType,param["groups"],param["users"],param["content"]);
			return new SocketMessage(getSocketMessageType(analysis.getProtocolType()), analysis.getProtocolValue());
		}
		
		/**     
		 * replaceAll     
		 * @param source:String 源数据     
		 * @param find:String 替换对象     
		 * @param replacement:Sring 替换内容     
		 * @return String     
		 * **/     
		private function replaceAll( source:String, find:String, replacement:String ):String
		{      
			return source.split( find ).join( replacement );      
		}  
		
	}
}