package py.com.flextech.controller.trabajocientifico;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.trabajocientifico.TrabajoCientifico;
import py.com.flextech.service.trabajocientifico.TrabajoCientificoService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/trabajo_cientifico" })
public class TrabajoCientificoController {
	
	private final TrabajoCientificoService service;

	@PostMapping("/save")
	public GenericResponseEntity<?> save(@RequestAttribute Long idUsuario, @RequestBody TrabajoCientifico data) {
		return service.save(idUsuario, data);
	}
	
	
	@GetMapping("/consultaTrabajosPorUsuario")
	public GenericResponseEntity<List<TrabajoCientifico>> consultaTrabajosPorUsuario(@RequestAttribute Long idUsuario) {
		return service.consultaTrabajosPorUsuario(idUsuario);
	}

	@GetMapping("/consultaTodos")
	public GenericResponseEntity<List<TrabajoCientifico>> consultaTodos() {
		return service.consultaTodos();
	}
	
	@PutMapping("/cancelar")
	public GenericResponseEntity<TrabajoCientifico> cancelar(@RequestParam Long idTrabajo) {
		return service.cancelar(idTrabajo);
	}

	@PutMapping("/cambiarEstado")
	public GenericResponseEntity<TrabajoCientifico> cambiarEstado(@RequestParam Long idTrabajo, @RequestParam String estado) {
		return service.cambiarEstado(idTrabajo, estado);
	}
}
