package py.com.flextech.controller.taller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.taller.Taller;
import py.com.flextech.service.taller.TallerService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/taller" })
public class TallerController {
	
	private final TallerService service;
	
	
	@GetMapping("/consultaTodos")
	public GenericResponseEntity<List<Taller>> consultaTodos() {
		return service.consultaTodos();
	}

	@GetMapping("/consultaPorDescripcion")
	public GenericResponseEntity<List<Taller>> consultaPorDescripcion(@RequestParam String descripcion) {
		return service.consultaPorDescripcion(descripcion);
	}
	
	@PostMapping("/asignarResponsable")
	public GenericResponseEntity<?> asignarResponsable(@RequestParam(required = false)Long idUsuario, @RequestParam Long idTaller) {
		return service.asignarResponsable(idUsuario, idTaller);
	}
	
	@GetMapping("/consultaTallerById")
	public GenericResponseEntity<Taller> consultaTallerById(@RequestParam Long idTaller) {
		return service.consultaTallerById(idTaller);
	}
}
