package py.com.flextech.controller.sorteo;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.service.sorteo.SorteoService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/sorteo" })
public class SorteoController {
	
	private final SorteoService service;

	@PostMapping("/guardarGanador")
	public GenericResponseEntity<?> guardarGanador(@RequestParam Long idUsuario, @RequestParam String auspiciante) {
		return service.guardarGanador(idUsuario, auspiciante);
	}


	@GetMapping("/consultaCongresistaDisponiblesSorteo")
	public GenericResponseEntity<?> consultaCongresistaDisponiblesSorteo(@RequestParam String tipoSorteo) {
		return service.consultaCongresistaDisponiblesSorteo(tipoSorteo);
	}

}
