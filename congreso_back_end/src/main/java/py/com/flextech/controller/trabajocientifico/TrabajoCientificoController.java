package py.com.flextech.controller.trabajocientifico;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
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
}
