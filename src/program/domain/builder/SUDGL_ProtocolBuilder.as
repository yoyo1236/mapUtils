package program.domain.builder
{
	import mx.collections.ArrayCollection;
	
	import program.domain.Group;
	import program.domain.User;
	
	public class SUDGL_ProtocolBuilder extends ProtocolBuilder
	{
		public override function buildGroup():Object
		{
			if (this.groups == null) return null;
			
			var group:XML = <groups />;
			group.@type = "";
			group.@num = groups.length.toString();
			
			for (var i:int=0; i<this.groups.length; i++) 
			{
				var groupInfo:XML = <groupInfo />;
				var ui:Group = this.groups.getItemAt(i) as Group;
				groupInfo.@name = ui.name;
				group.appendChild(groupInfo);
			}
			
			return group;
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