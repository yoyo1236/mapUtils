package program.domain.builder
{
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	public class ProtocolBuilder {
		public static var CLASS_PATH:String = "program.domain.builder.ProtocolBuilder";
		private var protocolType:String;
		protected var content:String;
		protected var users:ArrayCollection;
		protected var groups:ArrayCollection;
		
		
		
		public function ProtocolBuilder()
		{
		}
		
		public function getProtocolType():String
		{
			return protocolType;
		}
		
		public function setContent(content:Object):void
		{
			this.content = (String)(content);
		}
		
		public function setUsers(users:Object):void
		{
			this.users = (ArrayCollection)(users);
		}
		
		public function setGroups(groups:Object):void
		{
			this.groups = (ArrayCollection)(groups);
		}
		
		public function getContent():Object
		{
			return content;
		}
		
		public function getUsers():Object
		{
			return this.users;
		}
		
		public function getGroups():Object
		{
			return this.groups;
		}
		
		public function buildUser():Object
		{
			return null;
		}
		
		public function buildGroup():Object
		{
			return null;
		}
		
		public function buildContent():Object
		{
			return null;
		}
		
		public static function createBuilder(protocolType:String,groups:Object,users:Object,content:Object):ProtocolBuilder
		{
			var classPath:String = ProtocolBuilder.CLASS_PATH;
			classPath = classPath.substr(0, classPath.lastIndexOf(".")+1)
				+ protocolType + "_"
				+ classPath.substr(classPath.lastIndexOf(".")+1);
			var instance:ProtocolBuilder;
			var classReference:Class = getDefinitionByName(classPath) as Class;
			instance = new classReference() as ProtocolBuilder;
			instance.setProtocolType();
			instance.setGroups(groups);
			instance.setUsers(users);
			instance.setContent(content);
			
			return instance;
		}
		
		public function setProtocolType():void
		{
			var className:String = ObjectUtil.getClassInfo(this).name;
			protocolType = className.substring(className.lastIndexOf(":")+1, className.indexOf("_"));
			//System.out.println("ProtocolType类型为："+protocolType);
		}
		
	}
}