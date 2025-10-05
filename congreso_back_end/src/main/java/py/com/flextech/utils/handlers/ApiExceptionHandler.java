package py.com.flextech.utils.handlers;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import py.com.flextech.model.dto.GenericResponseEntity;

@RestControllerAdvice
public class ApiExceptionHandler {

  @ExceptionHandler(BadRequestException.class) // ✅ tu clase
  public ResponseEntity<GenericResponseEntity<?>> badReq(BadRequestException ex) {
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .contentType(MediaType.APPLICATION_JSON)
        .body(new GenericResponseEntity<>(ex.getMessage(), 400, null));
  }

  @ExceptionHandler(ConflictException.class)
  public ResponseEntity<GenericResponseEntity<?>> conflict(ConflictException ex) {
    return ResponseEntity.status(HttpStatus.CONFLICT)
        .contentType(MediaType.APPLICATION_JSON)
        .body(new GenericResponseEntity<>(ex.getMessage(), 409, null));
  }

  @ExceptionHandler(DataIntegrityViolationException.class)
  public ResponseEntity<GenericResponseEntity<?>> dup(DataIntegrityViolationException ex) {
    String msg = ex.getMostSpecificCause() != null ? ex.getMostSpecificCause().getMessage() : ex.getMessage();
    String userMsg = "Operación no permitida.";
    if (msg != null) {
      if (msg.contains("UQ_KIT_ONCE")) userMsg = "El KIT ya fue entregado previamente a este congresista.";
      else if (msg.contains("UQ_COFFEE_PER_DAY")) userMsg = "El Coffee Break de esa franja ya fue entregado hoy a este congresista.";
    }
    return ResponseEntity.status(HttpStatus.CONFLICT)
        .contentType(MediaType.APPLICATION_JSON)
        .body(new GenericResponseEntity<>(userMsg, 409, null));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<GenericResponseEntity<?>> beanValidation(MethodArgumentNotValidException ex) {
    var first = ex.getBindingResult().getAllErrors().stream().findFirst()
        .map(err -> err.getDefaultMessage()).orElse("Solicitud inválida");
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .contentType(MediaType.APPLICATION_JSON)
        .body(new GenericResponseEntity<>(first, 400, null));
  }

  // ✅ Catch–all para no devolver body vacío nunca más
  @ExceptionHandler(Exception.class)
  public ResponseEntity<GenericResponseEntity<?>> generic(Exception ex) {
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .contentType(MediaType.APPLICATION_JSON)
        .body(new GenericResponseEntity<>("Error interno", 500, null));
  }
}
