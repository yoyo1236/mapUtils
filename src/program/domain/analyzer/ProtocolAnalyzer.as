package program.domain.analyzer
{
	public interface ProtocolAnalyzer {
		function analysis(str:String):void
		function getProtocolType():String
		function getProtocolValue():Object
	}
}
