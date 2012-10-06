package program.domain
{
	public class UserInfo
	{
		public var user:User;
		public var friendList:Object;
		public function UserInfo()
		{
		}
		
		public function setUser(_user:User):void
		{
			user = _user;
		}
		
		public function getUser():User
		{
			return user;
		}
	}
}