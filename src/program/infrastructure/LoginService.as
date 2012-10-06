package program.infrastructure
{
	import com.examyes.flex.services.XMLHTTPService;
	import com.examyes.flex.tools.ExtJS;
	import com.examyes.flex.tools.Utils;
	import flash.events.Event;

	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import mx.logging.*;
	import mx.rpc.events.FaultEvent;
	public class LoginService
	{
		private var LOG:ILogger = Utils.getLogger(this);
		private var service:XMLHTTPService;
		private var handler:Function;
		private var params:URLVariables;

		private var name:String;
		private var pass:String;
		[Init]
		public function init():void
		{
			var url:String = ExtJS.call("getWebServerUrl");
			LOG.debug("ExtJS get Server Url: {0}", url);
			params = new URLVariables();
			params.cmd = "ADMIN";
			params.type = "LOGIN";
			service = new XMLHTTPService(url, params, resultHandler, faultHandler);
		}
		
		public function login(loadLocalHandler:Function,content:String):void
		{
			handler = loadLocalHandler;
			params.content = content;
			service.send();
		}
		
		public function LoginService()
		{
		}
		
		private function resultHandler(xml:XML):void
		{
			handler(ServiceResult.SUCCESS, xml);
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			LOG.error(event.fault.toString());
			handler(ServiceResult.FAILED, null);
		}
	}
}