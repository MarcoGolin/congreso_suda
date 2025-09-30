package py.com.flextech.controller.checkin;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.checkin.Checkin;
import py.com.flextech.model.checkin.enums.CheckinTipoEnum;
import py.com.flextech.model.checkin.enums.CoffeeBreakEnum;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.service.checkIn.CheckInService;


@CrossOrigin
@RestController
@RequiredArgsConstructor
@RequestMapping({ "/api/checkin" })
public class CheckInController {
	
	private final CheckInService service;


	@PostMapping("/checkin")
	public GenericResponseEntity<Checkin> checkin(@RequestAttribute Long idUsuario,
			@RequestParam(required = true)  String uuid,
			@RequestParam(required = true)  CheckinTipoEnum tipo,
			@RequestParam(required = false)  Long idTaller,
			@RequestParam(required = false)  CoffeeBreakEnum refriSlot) {
		return service.checkin(idUsuario, uuid, tipo, idTaller, refriSlot);
	}
}
