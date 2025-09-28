package py.com.flextech.model.taller.serializer;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import py.com.flextech.model.taller.Taller;

public class TallerSerializer extends JsonSerializer<Taller> {

	@Override
	public void serialize(Taller value, JsonGenerator gen, SerializerProvider serializers)
			throws IOException {
		
		gen.writeStartObject();
		gen.writeNumberField("id", value.getId());
		gen.writeEndObject();
	}

}


