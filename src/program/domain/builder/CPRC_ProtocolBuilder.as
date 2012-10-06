package program.domain.builder
{
	import mx.collections.ArrayCollection;
	
	import program.domain.Group;
	import program.domain.User;

	public class CPRC_ProtocolBuilder extends ProtocolBuilder
	{
		public override function buildContent():Object
		{
			var _content:XML = <content>{this.content}</content>;
			return _content;
		}
		
		public override function buildUser():Object
		{
			if (this.users == null) return null;
			
			var user:XML = <users />;
			user.@num = users.length.toString();
			
			for (var i:int=0; i<users.length; i++) 
			{
				var userInfo:XML = <userInfo />;
				var ui:User = this.users.getItemAt(i) as User;
				userInfo.@id = ui.uid;
				userInfo.@name = ui.name;
				userInfo.@type = ui.type;
				user.appendChild(userInfo);
			}
			
			return user;
		}
	
	}
}