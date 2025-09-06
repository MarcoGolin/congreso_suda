package py.com.flextech.controller.organizadores;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.organizadores.Organizadores;
import py.com.flextech.service.organizadores.OrganizadoresService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/organizadores" })
public class OrganizadoresController {
	
	private final OrganizadoresService service;
	@GetMapping("/consultaTodos")
	public GenericResponseEntity<List<Organizadores>> consultaTodos() {
		return service.consultaTodos();
	}
}
