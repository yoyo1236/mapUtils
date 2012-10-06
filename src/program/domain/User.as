package program.domain
{
	[Bindable]
	public class User
	{
		public var name:String;
		public var pass:String;
		public var uid:String;
		public var type:String;
		
		[Init]
		public function init():void
		{
			
		}
		
		public function User(_name:String,_pass:String)
		{
			name = _name;
			pass = _pass;
		}
		
		public function setUid(_uid:String):User
		{
			uid = _uid;
			return this;
		}
		
		public function setName(_name:String):User
		{
			name = _name;
			return this;
		}
		public function setType(_type:String):User
		{
			type = _type;
			return this;
		}
	}
}