package py.com.flextech.controller.sistema;

import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.service.sistema.ParametroService;


@RestController
@RequestMapping({ "/api/parametro" })
@Transactional(rollbackOn = Exception.class)
public class ParametroController {
	
	@Autowired
	private ParametroService parametroService;

	@PostMapping("/save")
	public ResponseEntity<Parametro> save(@RequestAttribute Long tenant, @RequestBody Parametro parametro) {
		parametro = parametroService.save(tenant, parametro);
		return ResponseEntity.ok(parametro);
	}
	

}
