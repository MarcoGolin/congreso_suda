package py.com.flextech.utils.adapter;


import java.io.IOException;
import java.time.LocalDateTime;

import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonToken;
import com.google.gson.stream.JsonWriter;

public class LocalDateTimeAdapter extends TypeAdapter<LocalDateTime> {
    @Override
    public void write(final JsonWriter jsonWriter, final LocalDateTime localDate) throws IOException {
        if (localDate == null) {
            jsonWriter.nullValue();
        } else {
            jsonWriter.value(localDate.toString());
        }
    }

    @Override
    public LocalDateTime read(final JsonReader jsonReader) throws IOException {
    	
    	try {
    		 if (jsonReader.peek() == JsonToken.NULL) {
    	            jsonReader.nextNull();
    	            return null;
    	        } else {
    	            return LocalDateTime.parse(jsonReader.nextString());
    	        }
		} catch (Exception e) {
			return null;
		}
    }
}