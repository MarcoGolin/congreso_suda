package py.com.flextech.utils.handlers;

import org.apache.coyote.BadRequestException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import py.com.flextech.model.dto.GenericResponseEntity;

@RestControllerAdvice
public class ApiExceptionHandler {

  @ExceptionHandler(BadRequestException.class)
  public ResponseEntity<GenericResponseEntity<?>> badReq(BadRequestException ex) {
    return ResponseEntity.badRequest()
        .body(new GenericResponseEntity<>(ex.getMessage(), 400, null));
  }

  @ExceptionHandler(ConflictException.class)
  public ResponseEntity<GenericResponseEntity<?>> conflict(ConflictException ex) {
    return ResponseEntity.status(409)
        .body(new GenericResponseEntity<>(ex.getMessage(), 409, null));
  }

  // Unicidad de BD (seguro anti carrera)
  @ExceptionHandler(org.springframework.dao.DataIntegrityViolationException.class)
  public ResponseEntity<GenericResponseEntity<?>> dup(DataIntegrityViolationException ex) {
    String msg = ex.getMostSpecificCause() != null ? ex.getMostSpecificCause().getMessage() : ex.getMessage();
    String userMsg = "Operación no permitida.";
    if (msg != null) {
      if (msg.contains("UQ_KIT_ONCE")) {
        userMsg = "El KIT ya fue entregado previamente a este congresista.";
      } else if (msg.contains("UQ_COFFEE_PER_DAY")) {
        userMsg = "El Coffee Break de esa franja ya fue entregado hoy a este congresista.";
      }
    }
    return ResponseEntity.status(409)
        .body(new GenericResponseEntity<>(userMsg, 409, null));
  }
}