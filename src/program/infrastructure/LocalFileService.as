package program.infrastructure
{
	import com.examyes.flex.tools.ExtJS;
	import mx.controls.Alert;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	public class LocalFileService
	{
		[Init]
		public function init():void
		{
		}
		
		public function loadLocalData(loadLocalHandler:Function):void
		{
			//loader.load(urlrequest);
			var result:String = ExternalInterface.call("loadLocalData");
			if(result == "" || result == null)
				return;
			var xml:XML = new XML(result);
			loadLocalHandler(ServiceResult.SUCCESS, xml);
		}
		
		public function saveLocalData(saveLocalHandler:Function,content:String):void
		{
			ExternalInterface.call("saveLocalData",content);
			saveLocalHandler(ServiceResult.SUCCESS);
		}
	}
}