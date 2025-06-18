package py.com.flextech.service.sistema;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import py.com.flextech.model.sistema.Versao;
import py.com.flextech.repository.sistema.VersaoRepository;


@Service
public class VersaoService {


	@Autowired
	private VersaoRepository versaoRepository;
	
	public Versao findVersao() {
		Versao v = versaoRepository.findVersao();
		return v;
	}


}
