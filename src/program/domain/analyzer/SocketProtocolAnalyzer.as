package program.domain.analyzer
{
	import mx.collections.ArrayCollection;
	
	import program.domain.Group;
	import program.domain.User;
	import program.domain.builder.ProtocolBuilder;

	public class SocketProtocolAnalyzer implements ProtocolAnalyzer{
		public var protocolType:String;
		public var protocolValue:Object;

		public function analysis(msg:String):void 
		{
			/*protocolType = msg.substring(0, 2);// get message
			var arrMsg:Array = msg.split("--");// 以"--"分解成数组
			protocolValue = arrMsg;*/
			
			//Element root = stringToXML(msg);
			var root:XML = new XML(msg);
			analysisHead(root);
			analysisBody(root);
			//System.out.println("收到协议：" + protocolType + "\n内容为：" + msg);
		}
	
		public function getProtocolType():String 
		{
			return protocolType as String;
		}
	
		public function getProtocolValue():Object 
		{
			return protocolValue;
		}
		
		public function analysisHead(root:XML):void
		{
			//if (root == "") return;
			var protocolHead:XMLList = root.protocolHead;
			for each(var xml:XML in protocolHead)
			{
				protocolType = xml.@type;
			}
		}
		
		public function analysisBody(root:XML):void
		{
			//if (root == "") return;
			var protocolBody:XMLList = root.protocolBody;
			for each(var xml:XML in protocolBody)
			{
				var group:XMLList = xml.groups;
				var user:XMLList = xml.users;
				var content:XMLList = xml.content;
				protocolValue = ProtocolBuilder.createBuilder(protocolType, getGroupInfo(group[0]), getUserInfo(user[0]), getContent(content[0]));
			}
		}
		
		public function getGroupInfo(root:XML):ArrayCollection//List<GroupInfo>
		{
			if (root == null || root == "") return null;
			
			var groupInfos:ArrayCollection = new ArrayCollection();
			var groupInfoElements:XMLList = root.groupInfo;
			
			for each(var xml:XML in groupInfoElements)
			{
				var gi:Group = new Group(xml.@name).setType(xml.@type);
				groupInfos.addItem(gi);
			}
			
			return groupInfos;
		}
		
		public function getUserInfo(root:XML):ArrayCollection//List<UserInfo>
		{
			if (root == null || root == "") return null;
			
			var userInfos:ArrayCollection = new ArrayCollection();
			var userInfoElements:XMLList = root.userInfo;
			
			for each(var xml:XML in userInfoElements)
			{
				var gi:User = new User(xml.@name,"").setType(xml.@type).setUid(xml.@id);
				userInfos.addItem(gi);
			}
			
			return userInfos;
		}
		
		public function getContent(root:XML):String
		{
			if (root == null || root == "") return null;
			
			return root.text();
		}
	
	}
}
