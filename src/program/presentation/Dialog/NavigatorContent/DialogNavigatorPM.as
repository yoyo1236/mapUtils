package program.presentation.Dialog.NavigatorContent
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class DialogNavigatorPM
	{
		public var titleContext:String;
		public var content:ArrayCollection = new ArrayCollection();
		public function DialogNavigatorPM()
		{
		}
		
		[Init]
		public function init():void
		{
			
		}
		
		public function setTitle(title:String):void
		{
			titleContext = title;
		}
		
		public function addLine(s:String):void
		{
			content.addItem(s);
		}
		
		public function removeContent():void
		{
			content.removeAll();
		}
	}
}