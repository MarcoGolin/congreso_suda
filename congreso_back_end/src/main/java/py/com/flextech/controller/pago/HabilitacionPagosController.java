package py.com.flextech.controller.pago;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.pagos.HabilitacionPagos;
import py.com.flextech.service.pago.HabilitacionPagosService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/habilitacion_pagos" })
public class HabilitacionPagosController {
	
	private final HabilitacionPagosService service;

	@PostMapping("/habilitar")
	public GenericResponseEntity<HabilitacionPagos> habilitar(@RequestAttribute Long idUsuario, @RequestBody HabilitacionPagos habilitacion) {
		return service.habilitar(idUsuario, habilitacion);
	}
	@GetMapping("/consultaHorarios")
	public GenericResponseEntity<List<HabilitacionPagos>> consultaHorarios(@RequestParam Long idUsuario) {
		return service.consultaHorarios(idUsuario);
	}
	@GetMapping("/consultarSiEstaHabilitado")
	public GenericResponseEntity<HabilitacionPagos> consultarSiEstaHabilitado(@RequestParam Long idUsuario) {
		return service.consultarSiEstaHabilitado(idUsuario);
	}
}
