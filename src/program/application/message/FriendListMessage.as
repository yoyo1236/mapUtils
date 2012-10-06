package program.application.message
{
	public class FriendListMessage
	{
		public static var START_DIALOGIZE:String = "startDialogize";
		public static var STOP_DIALOGIZE:String = "stopDialogize";
		public static var GET_USER_INFO:String = "getUserInfo";
		public static var GET_USER_MAP:String = "getUserMap";
		
		public var fid:String;
		public var fname:String;
		
		[Selector]
		public var type:String;
		public function FriendListMessage(_type:String,_fid:String,_fname:String)
		{
			type = _type;
			fid = _fid;
			fname = _fname;
		}
	}
}