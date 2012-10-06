package program.domain
{
	public class ClientInfo
	{
		[Bindable]
		public var fid:String;
		[Bindable]
		public var fname:String;
		[Bindable]
		public var joinDiscussGroupCB:Boolean;
		[Bindable]
		public var joinDiscussCBEnable:Boolean = true;
		[Bindable]
		public var joinFriendBT:Boolean = true;
		[Bindable]
		public var isDialogized:Boolean = false;
		
		public function ClientInfo(_fid:String,_fname:String)
		{
			fid = _fid;
			fname = _fname;
		}
	}
}