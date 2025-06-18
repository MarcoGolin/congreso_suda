package py.com.flextech.controller.sistema;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import py.com.flextech.model.sistema.Versao;
import py.com.flextech.service.sistema.VersaoService;


@RestController
@CrossOrigin
@RequestMapping({ "/api/versao" })
public class VersaoController {
	
	@Autowired
	private VersaoService versaoService;
	
	@GetMapping("/findVersao")
	public ResponseEntity<Versao> findVersao() {
		Versao v = versaoService.findVersao();
		return ResponseEntity.ok(v);
	}

}
