package program.presentation.map
{
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.utils.WebMercatorUtil;
	import com.examyes.flex.tools.Utils;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.logging.*;
	
	import org.osmf.events.TimeEvent;
	
	import program.application.message.MapMessage;


	public class MapViewPM
	{
		private var LOG:ILogger = Utils.getLogger(this);
		public var view:MapView;
		public var pharosList:ArrayCollection;
		public var waterLevelDetectorList:ArrayCollection;
		
		//0:在layer中的索引;1:源点;2:目的点;3:移动所需时间;4:当前时间
		public var movedPoints:ArrayCollection = new ArrayCollection();
		public var dataUpdateInterval:Number = 100;
		public var totalTimeFactor:Number = 1000/dataUpdateInterval;
		
		public var pharosGraphicHashMap:Object = new Object();
		
		[MessageDispatcher]
		public var send:Function;
		
		public function MapViewPM()
		{
		}
		
		[Init]
		public function init():void
		{
			LOG.debug("Init");
		}
		
		public function initComplete(_mapView:MapView):void
		{
			view = _mapView;
			var tmpSR:SpatialReference = view.baseMapLayer.spatialReference;
			var lines:Array = [[
				new MapPoint(-1726185, 9543036, tmpSR),
				new MapPoint(34923, 6920940, tmpSR),
				new MapPoint(1874303, 6255632, tmpSR),
				new MapPoint(1835168, 6255632, tmpSR),
				new MapPoint(1913439, 6138225, tmpSR)
			]];
			//var myGraphicLine:Graphic = new Graphic(new MapPoint(-1726185, 9543036, tmpSR));
			//view.markerLayer.add(myGraphicLine);
			for(var i:int=0; i<60; i++)
			{
				send(new MapMessage(MapMessage.DRAW_POINT_MOVE_DIRECTLY).setParam([new MapPoint(-1726185+Math.random()*300000, 9543036, tmpSR),new MapPoint(34923+Math.random()*30000000, 6920940+Math.random()*30000000, tmpSR),2]));
			}
			//send(new MapMessage(MapMessage.DRAW_LINES).setParam(lines));
			var timer:Timer = new Timer(dataUpdateInterval);
			timer.addEventListener(TimerEvent.TIMER, pointsMoveHandle);
			timer.start();
		}
		
		public function pointsMoveHandle(event:TimerEvent):void
		{
			//0:在layer中的索引;1:源点;2:目的点;3:移动所需时间;4:当前时间
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			if (graphicLayerPoint.length == 0) return;
			
			for (var i:int = 0; i<movedPoints.length; i++)
			{
				var totalTime:int = movedPoints[i][3] * totalTimeFactor;
				if (movedPoints[i][4] == totalTime - 1)
				{
					graphicLayerPoint[movedPoints[i][0]] = new  Graphic(movedPoints[i][2], view.nodeSymbol);
					movedPoints.removeItemAt(i);
				}
				else
				{
					graphicLayerPoint[movedPoints[i][0]].geometry.x += (movedPoints[i][2].x - movedPoints[i][1].x)/totalTime;
					graphicLayerPoint[movedPoints[i][0]].geometry.y += (movedPoints[i][2].y - movedPoints[i][1].y)/totalTime;
					movedPoints[i][4]++;
				}
				
			}
			view.markerLayer.refresh();
		}
		
		[MessageHandler(selector="drawLines")]
		public function drawLinesHandler(msg:MapMessage):void
		{
			var myPolyline:Polyline = new Polyline();//new Polyline(msg.getParam() as Array,view.baseMapLayer.spatialReference);
			/*var myGraphicLine:Graphic = new Graphic(myPolyline);
			myGraphicLine.symbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0xDD2222, 1.0, 1);
			view.markerLayer.add(myGraphicLine);*/
			var myGraphicLine:Graphic = new Graphic();
			var arr:Array = msg.getParam() as Array;
			var i:int=0;
			var timer:Timer = new Timer(1000, arr[0].length-1);
			timer.addEventListener(TimerEvent.TIMER, TimerMethod);
			timer.start();
			function TimerMethod(event:TimerEvent):void
			{
				var mps:Array=new Array;
				var mpStat:MapPoint=arr[0][i] as MapPoint;
				var mpEnd:MapPoint=arr[0][i+1] as MapPoint;
				mps.push(mpStat);
				mps.push(mpEnd);
				myPolyline.addPath(mps);
				
				myGraphicLine=new Graphic(myPolyline,new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0xDD2222, 1.0, 1));
				
				view.markerLayer.add(myGraphicLine);
				
				i=i+1;
			}
		}
		
		[MessageHandler(selector="drawPointMoveIndirectly")]
		public function drawPointMoveIndirectly(msg:MapMessage):void
		{
			var srcPoint:MapPoint = msg.getParam()[0];
			var dstPoint:MapPoint = msg.getParam()[1];
			var time:int = msg.getParam()[2];
			
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			view.markerLayer.add(new Graphic(new MapPoint(srcPoint.x, srcPoint.y), view.nodeSymbol));
			//0:在layer中的索引;1:源点;2:目的点;3:移动所需时间;4:当前时间
			movedPoints.addItem([graphicLayerPoint.length - 1, srcPoint, dstPoint, time, 0]);
			/*
			
			var timer:Timer = new Timer(100, time);
			var i:int = 0;
			var j:int = 0;
			timer.addEventListener(TimerEvent.TIMER, TimerMethod);
			var xOffset:Number = 0, yOffset:Number = 0;
			
			for (i = 0; view.markerLayer.numGraphics; i++)
			{
				var point:MapPoint = graphicLayerPoint[i].geometry;
				if (point.x == srcPoint.x && point.y == srcPoint.y)
				{
					xOffset = (dstPoint.x - srcPoint.x)/time;
					yOffset = (dstPoint.y - srcPoint.y)/time;
					timer.start();
					break;
				}
			}
			
			function TimerMethod(event:TimerEvent):void
			{
				if(j == time - 1)
				{
					graphicLayerPoint[i] = new Graphic(dstPoint);
				}
				else
				{
					graphicLayerPoint[i].geometry.x += xOffset;
					graphicLayerPoint[i].geometry.y += yOffset;
				}
				view.markerLayer.refresh();
				j=j+1;
			}*/
			
		}
		
		[MessageHandler(selector="drawPointMoveDirectly")]
		public function drawPointMoveDirectly(msg:MapMessage):void
		{
			var srcPoint:MapPoint = msg.getParam()[0];
			var dstPoint:MapPoint = msg.getParam()[1];
			var graphicPoint:Graphic = new Graphic();
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			/*for (var i:int = 0; view.markerLayer.numGraphics; i++)
			{
				var point:MapPoint=graphicLayerPoint.getItemAt(i).point;
				if (point.x == srcPoint.x && point.y == srcPoint.y)
				{
					graphicLayerPoint[i] = dstPoint;
				}
			}*/
			
			graphicPoint=new Graphic(dstPoint, view.nodeSymbol);
			view.markerLayer.add(graphicPoint);
		}

/*		[MessageHandler(selector="configDataLoaded")]
		public function configDataReady(event:DeviceDataMessage):void
		{
			LOG.debug("configDataReady");
		}
		*/
	}
}