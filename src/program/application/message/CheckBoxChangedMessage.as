package program.application.message
{
	import program.domain.User;
	public class CheckBoxChangedMessage
	{
		public static const CLIENT_VIEW_ITEM_RENDERER:String = "clientViewItemRenderer";
		public static const DISCUSS_VIEW_ITEM_RENDERER:String = "discussViewItemRenderer";
		public static const FRIEND_VIEW_ITEM_RENDERER:String = "friendViewItemRenderer";
		
		[Selector]
		public var type:String;
		public var id:String;
		
		public function CheckBoxChangedMessage(_type:String,_id:String)
		{
			type = _type;
			id = _id;
		}
	}
}