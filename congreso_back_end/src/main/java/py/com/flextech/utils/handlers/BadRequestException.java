package py.com.flextech.utils.handlers;

//400 (request inválido)
public class BadRequestException extends RuntimeException {
	public BadRequestException(String msg) { super(msg); }
}