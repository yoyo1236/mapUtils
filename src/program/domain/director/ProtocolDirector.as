package program.domain.director
{
	import program.domain.builder.ProtocolBuilder;

	public interface ProtocolDirector {
		function buildProtocol(pb:ProtocolBuilder):Object;
	}
}