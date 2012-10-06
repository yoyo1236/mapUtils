package program.domain.builder
{
	import mx.collections.ArrayCollection;
	
	import program.domain.Group;
	
	public class CNDGJ_ProtocolBuilder extends ProtocolBuilder
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
	}
}