package program.application.message
{
	import program.domain.User;
	public class LocalFileMessage
	{
		public static const LOAD_LOCAL_DATA:String = "loadLocalData";
		public static const SAVE_LOCAL_DATA:String = "saveLocalData";
		
		[Selector]
		public var type:String;
		public var localData:String;
		
		public function LocalFileMessage(_type:String)
		{
			type = _type;
		}
		
		public function SetData(_data:String):LocalFileMessage
		{
			localData = _data;
			return this;
		}
	}
}