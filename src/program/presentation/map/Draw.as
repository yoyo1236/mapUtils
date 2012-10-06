package program.presentation.map
{ 
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.utils.WebMercatorUtil;
	import com.examyes.flex.tools.Utils;
	import com.map.MapLayer;
	import com.map.ObjectGraphic;
	import com.map.Symbol.TriangleFlagMarker;
	import com.map.domain.MapObject;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.logging.*;
	
	import org.osmf.events.TimeEvent;
	 


	public class Draw
	{
		private var LOG:ILogger = Utils.getLogger(this);
		public var view:MapLayer;
		public var pharosList:ArrayCollection;
		public var waterLevelDetectorList:ArrayCollection;
		
		//HashMap:  id——地图点集中的索引
		public var allPointsInMap:Object = new Object();
		/*
				0:在layer中的索引;
				1:源点;
				2:目的点;
				3:移动所需时间;
				4:当前时间
		*/
		public var movedPointsArr:ArrayCollection = new ArrayCollection();
		/*		数组位置							类型				初始化
				0:移动点在layer中的索引	int				view.historyTraceLayer.graphicProvider.length-1
				1:所有点							array			用户输入点集
				2:当期段距离					number		不用
				3:步长								number		通过calAverageStep计算
				4:当前点所在段					int				0
				5:当前段步长总数				int				不用
				6:当期段当期步数				int				-1
		*/
		public var historyTracePointsArr:ArrayCollection = new ArrayCollection();
		public var dataUpdateInterval:Number = 500;
		public var totalTimeFactor:Number = 1000/dataUpdateInterval;
		
		public var pharosGraphicHashMap:Object = new Object();
		public var maker:TriangleFlagMarker = new TriangleFlagMarker();
		//点移动定时器
		public var pointsMoveTimer:Timer = new Timer(dataUpdateInterval);
		//历史轨迹定时器
		public var historyTraceTimer:Timer = new Timer(dataUpdateInterval);
		public var tracePlaySpeed:int = 1;
		
		public function Draw ()
		{
		}
		
		[Init]
		public function Init():void
		{
			
		}
		
		public function init (_mapView:MapLayer):void
		{
			view = _mapView;
			var tmpSR:SpatialReference = view.baseMapLayer.spatialReference;

			/*for(var i:int=0; i<60; i++)
			{
				send(new MapMessage(MapMessage.DRAW_POINT_MOVE_DIRECTLY).setParam([new MapPoint(-1726185+Math.random()*300000, 9543036, tmpSR),new MapPoint(34923+Math.random()*30000000, 6920940+Math.random()*30000000, tmpSR),2]));
			}*/
			//send(new MapMessage(MapMessage.DRAW_LINES).setParam(lines));
			//var timer:Timer = new Timer(dataUpdateInterval);
			historyTraceTimer.addEventListener(TimerEvent.TIMER, historyTraceHandle);
			pointsMoveTimer.addEventListener(TimerEvent.TIMER, pointsMoveHandle);
			pointsMoveTimer.start();
		}
		
		//定时器处理函数：点移动
		public function pointsMoveHandle (event:TimerEvent):void
		{
			//0:在layer中的索引;1:源点;2:目的点;3:移动所需时间;4:当前时间
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			if (graphicLayerPoint.length == 0) 
			{
				//pointsMoveTimer.stop();
				return;
			}
			
			for (var i:int = 0; i<movedPointsArr.length; i++)
			{
				var totalTime:int = (movedPointsArr[i][3]) * totalTimeFactor;
				if (movedPointsArr[i][4] >= totalTime-1)
				{
					graphicLayerPoint[movedPointsArr[i][0]].geometry.x = movedPointsArr[i][2].x;
					graphicLayerPoint[movedPointsArr[i][0]].geometry.y = movedPointsArr[i][2].y;
					movedPointsArr.removeItemAt(i);
				}
				else
				{
					graphicLayerPoint[movedPointsArr[i][0]].geometry.x += (movedPointsArr[i][2].x - movedPointsArr[i][1].x)/totalTime;
					graphicLayerPoint[movedPointsArr[i][0]].geometry.y += (movedPointsArr[i][2].y - movedPointsArr[i][1].y)/totalTime;
					movedPointsArr[i][4]++;
				}
				
			}
			view.markerLayer.refresh();
		}
		
		//绘制轨迹
		public function drawLines (pathPoints:Array, layer:GraphicsLayer):void
		{
			var myPolyline:Polyline = new Polyline();
			
			var myGraphicLine:Graphic = new Graphic();
			
			var i:int=0;
			
			for(; i<pathPoints.length-1; i++)
			{
				var mps:Array=new Array;
				var mpStat:MapPoint=pathPoints[i][0] as MapPoint;
				var mpEnd:MapPoint=pathPoints[i+1][0] as MapPoint;
				mps.push(mpStat);
				mps.push(mpEnd);
				myPolyline.addPath(mps);
				
				myGraphicLine=new Graphic(myPolyline,new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0xDD2222, 1.0, 1));
				
				layer.add(myGraphicLine);
			}
			/*var timer:Timer = new Timer(100, pathPoints[0].length-1);
			timer.addEventListener(TimerEvent.TIMER, TimerMethod);
			timer.start();
			function TimerMethod (event:TimerEvent):void
			{
				var mps:Array=new Array;
				var mpStat:MapPoint=pathPoints[0][i] as MapPoint;
				var mpEnd:MapPoint=pathPoints[0][i+1] as MapPoint;
				mps.push(mpStat);
				mps.push(mpEnd);
				myPolyline.addPath(mps);
				
				myGraphicLine=new Graphic(myPolyline,new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0xDD2222, 1.0, 1));
				
				view.markerLayer.add(myGraphicLine);
				i=i+1;
			}*/
		}
		
		//点移动
		public function drawPointMoves (idInLayer:int, dstPoint:MapPoint, time:int = 0):void
		{
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			var referencePoint:MapPoint = new MapPoint(graphicLayerPoint[idInLayer].geometry.x, graphicLayerPoint[idInLayer].geometry.y);
			//0:在layer中的索引;1:源点;2:目的点;3:移动所需时间;4:当前时间
			movedPointsArr.addItem([idInLayer, referencePoint, dstPoint, time, 0]);
		}
		
		//在地图上显示信息窗口
		private function showInfoWindow (point:MapPoint, name:String, info:String):void
		{
			view.map.infoWindow.label = "名称:" + name + "\n"
				+ "信息:" + info + "\n";
			view.map.infoWindow.setStyle("fontFamily", "微软雅黑");
			view.map.infoWindow.show(point);
		}
		
		//鼠标点击处理函数
		private function mouseClickHandler (event:MouseEvent):void
		{
			var g:ObjectGraphic = event.currentTarget as ObjectGraphic;
			
			//setFocus(g.objectType,g.objectId);
			//var graphicLayerPoint:ArrayCollection = g.graphicsLayer.graphicProvider as ArrayCollection;
			view.map.centerAt( g.geometry as MapPoint );
			showInfoWindow(g.geometry as MapPoint, g.objectName, g.objectInfo);
		}
		
		//鼠标移动处理函数
		private function mouseMoveHandler (event:MouseEvent):void
		{
			var g:ObjectGraphic = event.currentTarget as ObjectGraphic;
			showInfoWindow(g.geometry as MapPoint, g.objectName, g.objectInfo);
			g.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			
			function mouseOut (event:MouseEvent):void
			{
				view.map.infoWindow.hide();
			}
		}
		
		//快速转到当前目标
		public function setFocus(type:String, id:int, showAnimation:Boolean=true):void
		{
			if(allPointsInMap[type + id] == null)return;
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			view.map.centerAt( graphicLayerPoint[allPointsInMap[type + id]].geometry as MapPoint);
		}
		
		//显示静态目标及状态
		public function setStableObject (type:String, id:int, x:Number, y:Number, state:int, name:String, info:String=""):void
		{
			var g:ObjectGraphic = new ObjectGraphic(type, id, view.pointXToScreen(x), view.pointYToScreen(y), state, name, info);
			g.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			g.addEventListener(MouseEvent.ROLL_OVER, mouseMoveHandler);
			view.markerLayer.add(g);
			allPointsInMap[type + id] = (view.markerLayer.graphicProvider as ArrayCollection).length - 1;
		}
		
		//显示动态目标及状态
		public function setMovaleObject (type:String, id:int, x:Number, y:Number, state:int, name:String, info:String="", showAnimation:Boolean=false):void
		{
			var g:ObjectGraphic = new ObjectGraphic(type, id, view.pointXToScreen(x), view.pointYToScreen(y), state, name, info);
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			if(allPointsInMap[type + id] == null)
			{
				view.markerLayer.add(g);
			}
			else 
			{
				if(showAnimation)
					drawPointMoves(allPointsInMap[type + id], g.geometry as MapPoint, 5);
				else
					drawPointMoves(allPointsInMap[type + id], g.geometry as MapPoint, 0);
			}
		}
		 
		//定时器处理函数：历史轨迹显示
		public function historyTraceHandle (event:TimerEvent):void
		{
			//0:在layer中的索引;1:源点;2:目的点;3:移动所需时间;4:当前时间
			var graphicLayerPoint:ArrayCollection = view.historyTraceLayer.graphicProvider as ArrayCollection;
			/*		数组位置							类型				初始化
					0:移动点在layer中的索引	int				view.historyTraceLayer.graphicProvider.length-1
					1:所有点							array			用户输入点集[MapPoint,time]
					2:当期段距离					number		不用
					3:步长								number		不用
					4:当前点所在段					int				0
					5:当前段步长总数				int				不用
					6:当期段当期步数				int				-1
			*/
			for (var i:int = 0; i<historyTracePointsArr.length; i++)
			{
				var _trace:Array = historyTracePointsArr[i];
				
				if (_trace[6] >= _trace[5] || _trace[6] == -1)	//当期步数 > 当期段总步数 || 初始化阶段
				{
					if (_trace[6] != -1)	//不是初始化阶段时
					{
						_trace[4] ++;
					}
					//点直接移动至当期段末的用户输入点集
					graphicLayerPoint[_trace[0]].geometry.x = _trace[1][_trace[4]][0].x;
					graphicLayerPoint[_trace[0]].geometry.y = _trace[1][_trace[4]][0].y;
					//退出条件：当期段为最后一个段，且 当期步数 > 当期段总步数
					if (_trace[4] >= _trace[1].length - 1)
					{
						//移除该轨迹点
						historyTracePointsArr.removeItemAt(i);
						//i--; 
						continue;
					}
					//计算新段的段距离
					_trace[2] = Math.sqrt( (_trace[1][_trace[4]][0].x - _trace[1][_trace[4] + 1][0].x)*(_trace[1][_trace[4]][0].x - _trace[1][_trace[4] + 1][0].x)
													+  (_trace[1][_trace[4]][0].y - _trace[1][_trace[4] + 1][0].y)*(_trace[1][_trace[4]][0].y - _trace[1][_trace[4] + 1][0].y)
					);
					//计算新步长：根据源点到目的点的距离，以及两点之间的时间戳和播放速度
					_trace[3] = calStep(_trace[1][_trace[4]][0], _trace[1][_trace[4] + 1][0], (_trace[1][_trace[4] + 1][1] - _trace[1][_trace[4]][1])/tracePlaySpeed );
					//计算新段总步数：段距离/步长，去下限
					_trace[5] = Math.floor(_trace[2] / _trace[3]);
					//初始化当期步数
					_trace[6] = 0;
					
					view.mousecoords.text = 
						"0:移动点在layer中的索引 " + _trace[0] +
						"\n1:所有点 " + _trace[1] +
						"\n2:当期段距离	" + _trace[2] +
						"\n3:步长 " + _trace[3] +
						"\n4:当前点所在段 " + _trace[4] +
						"\n5:当前段步长总数 " + _trace[5] +
						"\n6:当期段当期步数 " + _trace[6];
				}
				else
				{
					//将步长转换成X和Y坐标的偏移
					var xOffset:Number = _trace[3] / _trace[2] * (_trace[1][_trace[4]+1][0].x - _trace[1][_trace[4]][0].x);
					var yOffset:Number = _trace[3] / _trace[2] * (_trace[1][_trace[4]+1][0].y - _trace[1][_trace[4]][0].y);
					//轨迹点加上这些偏移
					graphicLayerPoint[_trace[0]].geometry.x += xOffset;
					graphicLayerPoint[_trace[0]].geometry.y += yOffset;
					//当期步数加1
					_trace[6]++;
				}
			}
			view.historyTraceLayer.refresh();
		}
		
		//不用函数：计算平均步数
		public function calAverageStep(traces:Array, step:int):Number
		{
			var total:Number = 0;
			for (var i:int=0; i<traces.length - 1; i++)
			{
				var srcPoint:MapPoint = traces[i][0] as MapPoint;
				var dstPoint:MapPoint = traces[i + 1][0] as MapPoint;
				total += Math.sqrt( (dstPoint.x - srcPoint.x)*(dstPoint.x - srcPoint.x) + (dstPoint.y - srcPoint.y)*(dstPoint.y - srcPoint.y) );
			}
			
			return total/step;
		}
		
		//根据源点到目的点的距离以及时间计算新步长
		public function calStep(srcPoint:MapPoint, dstPoint:MapPoint, time:Number):Number
		{
			var total:Number = Math.sqrt( (dstPoint.x - srcPoint.x)*(dstPoint.x - srcPoint.x) + (dstPoint.y - srcPoint.y)*(dstPoint.y - srcPoint.y) );
			
			return total/(time*totalTimeFactor);
		}
		
		//回放移动目标历史轨迹
		public function playHistoryTrace(type:String, id:int, traces:Array, name:String, info:String="", showTrace:Boolean=true, speed:int=1):void
		{
			/*		数组位置							类型				初始化
					0:移动点在layer中的索引	int				view.historyTraceLayer.graphicProvider.length-1
					1:所有点							array			用户输入点集[MapPoint,time]
					2:当期段距离					number		不用
					3:步长								number		不用
					4:当前点所在段					int				0
					5:当前段步长总数				int				不用
					6:当期段当期步数				int				-1
			*/
			var tracesTrans:Array = new Array();
			for (var i:int=0; i<traces.length; i++)
			{
				tracesTrans[i] =  [new MapPoint(traces[i][0], traces[i][1]), traces[i][2]];
			}
			
			view.pointsChangeToScreen(tracesTrans);
			tracePlaySpeed = speed;
			//var step:Number = calAverageStep(traces, 100/speed);
			//var point:MapPoint = new MapPoint(traces[0].x, traces[0].y);
			var graphicLayerPoint:ArrayCollection = view.markerLayer.graphicProvider as ArrayCollection;
			if (allPointsInMap[type + id] == null)
				return ;
			
			if (showTrace)
				drawLines(tracesTrans, view.historyTraceLayer);
			
			var g:ObjectGraphic = graphicLayerPoint[allPointsInMap[type + id]];
			var gClone:ObjectGraphic = g.clone(tracesTrans[0].x, tracesTrans[0].y, name, info);
			gClone.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			gClone.addEventListener(MouseEvent.ROLL_OVER, mouseMoveHandler);
			view.historyTraceLayer.add(gClone);
			
			historyTracePointsArr.addItem( 
				[view.historyTraceLayer.graphicProvider.length-1, tracesTrans, 0, 0, 0, 0, -1] 
			);
			historyTraceTimer.start();
			
		}
	}
}