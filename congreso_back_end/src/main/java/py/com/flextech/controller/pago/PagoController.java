package py.com.flextech.controller.pago;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.service.pago.PagoService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/pago" })
public class PagoController {
	
	private final PagoService service;

	@PutMapping("/confirmar")
	public GenericResponseEntity<?> confirmar(@RequestAttribute Long idUsuario, @RequestParam Long idCongresista, @RequestParam Boolean isExonerado) {
		return service.confirmar(idUsuario, idCongresista, isExonerado);
	}
}
