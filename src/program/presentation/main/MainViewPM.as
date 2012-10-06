package program.presentation.main
{
	import com.examyes.flex.tools.ExtJS;
	import com.examyes.flex.tools.Utils;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.logging.*;

	public class MainViewPM
	{
		private var LOG:ILogger = Utils.getLogger(this);
		
		private var dataUpdateTimer:Timer;
		
		/** 指示数据是否已经更新成功  */
		private var dataUpdated:Boolean = false;
		
		/** 时间更新间隔 */
		private var dataUpdateInterval:int = 1000;
		
		[MessageDispatcher]
		public var send:Function;
		
		public function MainViewPM()
		{
//			/** 从外部HTML页面呢中获取配置数据 */
//			var n:Number = parseInt(ExtJS.call("getUpdateInterval"));
//			if (isNaN(n))
//			{
//				/** 如果外部页面未指定，则使用默认值  */
//				LOG.debug("ExtJS can not get update interval");	
//			}
//			else
//			{
//				dataUpdateInterval = n;
//				LOG.debug("ExtJS get Update Interval: {0}ms", dataUpdateInterval);
//			}
//			dataUpdateTimer = new Timer(dataUpdateInterval);
//			dataUpdateTimer.addEventListener(TimerEvent.TIMER, dataUpdate);
		}
		
		[Init]
		public function init():void
		{
			LOG.debug("Init"); 
		}
		
//		public function loadConfigData():void
//		{
//			send(new DeviceDataMessage(DeviceDataMessage.GET_CONFIG_DATA));
//		}
//		
//		[MessageHandler(selector="configDataLoaded")]
//		public function configDataLoadedHandler(msg:DeviceDataMessage):void
//		{
//			LOG.debug("configDataLoadedHandler");
//			send(new DeviceDataMessage(DeviceDataMessage.UPDATE_DATA));
//			dataUpdateTimer.start();
//			
//		}
//		
//		[MessageHandler(selector="updateDataComplete")]
//		public function updateDataCompleteHandler(msg:DeviceDataMessage):void
//		{
//			LOG.debug("updateDataCompleteHandler");
//			dataUpdated = true;
//		}
//		
//		/**
//		 *如数据更新失败，则设置dataUpdated为true，这样在下一次定时器调度是才会进行重试 
//		 */		
//		[MessageHandler(selector="updateDataError")]
//		public function updateDataErrorHandler(msg:DeviceDataMessage):void
//		{
//			LOG.debug("updateDataErrorHandler");
//			dataUpdated = true;
//		}
//		
//		private function dataUpdate(event:TimerEvent):void
//		{			
//			if (dataUpdated)
//			{
//				send(new DeviceDataMessage(DeviceDataMessage.UPDATE_DATA));
//				dataUpdated = false;
//			}
//		}
	}
}