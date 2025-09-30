package py.com.flextech.controller.congresista;

import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.pagos.enums.FiltroEstado;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.enums.TipoUsuarioEnum;
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

	@GetMapping("/consultaCongresistaPorNombreORegistroAcademico")
	public GenericResponseEntity<?> consultaCongresistaPorNombreORegistroAcademico(@RequestParam String nombre, 
			@RequestParam String  registroAcademico,
			@RequestParam int pageNr,
			@RequestParam int pageSize) {
		return service.consultaCongresistaPorNombreORegistroAcademico(nombre, registroAcademico, pageNr, pageSize);
	}
	
	@GetMapping("/consultaConFiltros")
	public GenericResponseEntity<?> consultaConFiltros(
	    @RequestParam(required = false) String nombre,
	    @RequestParam(required = false) String registroAcademico,
	    @RequestParam(defaultValue = "TODOS") FiltroEstado estado,
	    @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime desde,
	    @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime hasta,
	    @RequestParam int pageNr,
	    @RequestParam int pageSize) {

	  return service.consultaConFiltros(nombre, registroAcademico, estado, desde, hasta, pageNr, pageSize);
	}

	@GetMapping("/resumenCobradorTurno")
	public GenericResponseEntity<?> resumenCobradorTurno(
	    @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime desde,
	    @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime hasta) {
	  return service.resumenCobradorTurno(desde, hasta);
	}
	
	@GetMapping("/consultaCongresistaPorTipo")
	public GenericResponseEntity<?> consultaCongresistaPorTipo(
	    @RequestParam(required = true)  String tipoUsuario) {
	  return service.consultaCongresistaPorTipo(TipoUsuarioEnum.valueOf(tipoUsuario));
	}

	@GetMapping("/reenviarEmailInscripcion")
	public GenericResponseEntity<?> reenviarEmailInscripcion() {
		return service.reenviarEmailInscripcion();
	}
	
	@PutMapping("/restablecerContrasenha")
	public GenericResponseEntity<?> restablecerContrasenha(@RequestParam Long idCongresista) {
		return service.restablecerContrasenha(idCongresista);
	}
	
	@GetMapping("/consultaCongresistaPorId")
	public GenericResponseEntity<?> consultaCongresistaPorId(
	    @RequestParam(required = true)  Long idUsuario) {
	  return service.consultaCongresistaPorId(idUsuario);
	}

	@GetMapping("/consultaByUUID")
	public GenericResponseEntity<?> consultaByUUID(
			@RequestParam(required = true)  String uuid) {
		return service.consultaByUUID(uuid);
	}

}
