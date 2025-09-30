package py.com.flextech.utils.handlers;

//409 (conflicto de negocio)
public class ConflictException extends RuntimeException {
	public ConflictException(String msg) { super(msg); }
}

