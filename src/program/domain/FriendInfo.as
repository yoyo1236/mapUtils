package program.domain
{
	public class FriendInfo
	{
		public var fid:String;
		public var fname:String;
		[Bindable]
		public var isDialogized:Boolean = false;
		
		public function FriendInfo(_fid:String,_fname:String)
		{
			fid = _fid;
			fname = _fname;
		}
	}
}