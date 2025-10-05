package py.com.flextech.utils.handlers;

import py.com.flextech.model.dto.GenericResponseEntity;

public class ResponseRollbackException extends RuntimeException {
    /**
	 * 
	 */
	private static final long serialVersionUID = 2807822834057840809L;
	private final GenericResponseEntity<?> response;

    public ResponseRollbackException(GenericResponseEntity<?> response) {
        super(response.getMessage());
        this.response = response;
    }

    public GenericResponseEntity<?> getResponse() {
        return response;
    }
}