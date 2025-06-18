package py.com.flextech.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
public class GenericResponseEntity <T>{
	
	private String message;
	private long code;
	private Object  object;
	
	

}
