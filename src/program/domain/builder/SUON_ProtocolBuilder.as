package program.domain.builder
{
	public class SUON_ProtocolBuilder extends ProtocolBuilder
	{
		public override function buildContent():Object
		{
			var _content:XML = <content>{this.content}</content>;
			return _content;
		}
	
	}
}