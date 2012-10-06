package program.application.message
{
	public class MapMessage
	{
		public static var DRAW_LINES:String = "drawLines";
		public static var DRAW_POINT_MOVE_DIRECTLY:String = "drawPointMoveDirectly";
		public static var DRAW_POINT_MOVE_INDIRECTLY:String = "drawPointMoveIndirectly";
		
		[Selector]
		public var type:String;
		public var param:Object;
		
		public function MapMessage(_type:String)
		{
			type = _type;
		}
		
		public function setParam(_param:Object):MapMessage
		{
			param = _param;
			return this;
		}
		
		public function getParam():Object
		{
			return param;
		}
	}
}