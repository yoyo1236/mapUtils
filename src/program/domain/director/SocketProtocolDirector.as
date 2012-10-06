package program.domain.director
{
	import program.domain.builder.ProtocolBuilder;
	
	public class SocketProtocolDirector implements ProtocolDirector{
		public var protocolBuilder:ProtocolBuilder;
		
		public function buildProtocolHead():XML
		{
			var head:XML = <protocolHead />;
			//head.setAttribute("type",protocolBuilder.protocolType);
			head.@type = protocolBuilder.getProtocolType();
			return head;
		}
		
		public function buildProtocolBody():XML
		{
			var body:XML = <protocolBody />;
			var group:XML = protocolBuilder.buildGroup() as XML;
			var user:XML = protocolBuilder.buildUser() as XML;
			var content:XML = protocolBuilder.buildContent() as XML;
			
			if(group != null)
				body.group = group;
			if(user != null)
				body.user = user;
			if(content != null)
				body.content = content;
			
			return body;
		}
	
		public function buildProtocol(pb:ProtocolBuilder):Object
		{
			var protocol:XML = <protocol />;
			protocolBuilder = pb;
			protocol.protocolHead = buildProtocolHead();
			protocol.protocolBody = buildProtocolBody();
			return protocol;
		}
	
	}
}