package py.com.flextech.model.sistema.serializer;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import py.com.flextech.model.sistema.Usuario;

public class UsuarioSerializer extends JsonSerializer<Usuario> {

	@Override
	public void serialize(Usuario value, JsonGenerator gen, SerializerProvider serializers)
			throws IOException {
		
		gen.writeStartObject();
		gen.writeNumberField("id", value.getId());
		gen.writeStringField("nombreCompleto", value.getNombreCompleto());
		gen.writeEndObject();
	}

}


