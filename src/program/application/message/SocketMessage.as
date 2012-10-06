package program.application.message
{
	import mx.collections.ArrayList;

	public class SocketMessage
	{
		public static var CONNECT_SOCKET_SERVER:String = "connectSocketServer";
		public static var CONNECT_SOCKET_SERVER_SUCCESS:String = "connectSocketServerSuccess";
		public static var RECEIVE_SOCKET_MESSAGE:String = "receiveSocketMessage";
		public static var SEND_SOCKET_MESSAGE:String = "sendSocketMessage";
		
		/*LIST*/
		/*更新大厅用户列表*/
		public static var UPDATE_CLIENT_LIST:String = "updateClientList";
		/*更新讨论组列表*/
		public static var UPDATE_DISCUSS_GROUP_LIST:String = "updateDiscussGroupList";
		/*发起创建讨论组*/
		public static var CREATE_DISCUSS_GROUP:String = "createDiscussGroup";
		/*收到新的讨论组邀请*/
		public static var NEWDISCUSS_GROUP_INVITING:String = "newdiscussGroupInviting";
		/*同意讨论组邀请*/
		public static var AGREE_FOR_DISCUSS_GROUP_INVITING:String = "AgreeForDiscussGroupInviting";
		public static var EXIT_DISCUSS_GROUP:String = "exitDiscussGroup";
		
		/*CONTENT*/
		/*收到大厅信息*/
		public static var RECEIVED_PUBLIC_CONTENT:String = "receivedPublicContent";
		/*发送公聊信息*/
		public static var SEND_PUBLIC_CONTENT:String = "sendPublicContent";
		/*发送私聊信息*/
		public static var SEND_PRIVATE_CONTENT:String = "sendPrivateContent";
		/*发送讨论组信息*/
		public static var SEND_DISCUSS_GROUP_CONTENT:String = "sendDiscussGroupContent";
		/*收到讨论组信息*/
		public static var RECEIVED_DISCUSS_GROUP_CONTENT:String = "receivedDiscussGroupContent";

		/*NUM*/
		/*更新大厅在线人数*/
		public static var ONLINE_NUM:String = "onlineNum";
		
		/*无信息*/
		public static var NO_MESSAGE:String = "noMessage";
		
		public var param:Object;
		public var transData:String;
		[Selector]
		public var type:String;
		
		public function SocketMessage(_type:String,_param:Object)
		{
			type = _type;
			param = _param;
			transData = param as String;
		}
		
		public function setTransData(_data:String):SocketMessage
		{
			transData = _data;
			return this;
		}
		
	}
}