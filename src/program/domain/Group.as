package program.domain
{
	[Bindable]
	public class Group
	{
		public var name:String;
		public var type:String;
		
		[Init]
		public function init():void
		{
			
		}
		
		public function Group(_name:String)
		{
			name = _name;
		}
		
		public function setName(_name:String):Group
		{
			name = _name;
			return this;
		}
		
		public function setType(_type:String):Group
		{
			type = _type;
			return this;
		}
	}
}