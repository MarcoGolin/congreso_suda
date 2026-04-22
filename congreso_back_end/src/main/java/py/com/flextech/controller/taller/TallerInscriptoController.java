package py.com.flextech.controller.taller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.taller.TallerInscripto;
import py.com.flextech.service.taller.TallerInscriptoService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/tallerInscripto")
public class TallerInscriptoController {
	
	private final TallerInscriptoService service;
	
	
	@PostMapping("/inscribir")
	public GenericResponseEntity<TallerInscripto> inscribir(@RequestAttribute Long idUsuario, @RequestParam Long idTaller) {
		return service.inscribir(idUsuario, idTaller, null);
	}
	
	@PostMapping("/inscribirListado")
	public GenericResponseEntity<TallerInscripto> inscribirListado(@RequestParam Long idUsuario, @RequestParam Long idTaller,  @RequestParam Boolean isJuntaDirectiva) {
		return service.inscribir(idUsuario, idTaller, isJuntaDirectiva);
	}

	@GetMapping("/verificarInscripto")
	public GenericResponseEntity<TallerInscripto> verificarInscripto(@RequestAttribute Long idUsuario, @RequestParam Long idTaller) {
		return service.verificarInscripto(idUsuario, idTaller);
	}

	@GetMapping("/consultarTalleresPorUsuario")
	public GenericResponseEntity<List<TallerInscripto>> consultarTalleresPorUsuario(@RequestAttribute Long idUsuario) {
		return service.consultarTalleresPorUsuario(idUsuario);
	}
	
	@GetMapping("/consultaParticipantesDelTaller")
	public GenericResponseEntity<?> consultaParticipantesDelTaller(@RequestParam Long idTaller, 
			@RequestParam int pageNr,
			@RequestParam int pageSize) {
		return service.consultaParticipantesDelTaller(idTaller, pageNr, pageSize);
	}
	
	@DeleteMapping("/remover")
	public GenericResponseEntity<?> remover(@RequestParam Long idInscripto) {
		return service.remover(idInscripto);
	}
}
