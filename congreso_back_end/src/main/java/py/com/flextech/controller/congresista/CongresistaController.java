package py.com.flextech.controller.congresista;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.service.congresista.CongresistaService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/congresista" })
public class CongresistaController {
	
	private final CongresistaService service;

	@PostMapping("/save")
	public GenericResponseEntity<?> save(@RequestBody Usuario usuario) {
		return service.save(usuario);
	}
}
