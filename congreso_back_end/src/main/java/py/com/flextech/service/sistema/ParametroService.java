package py.com.flextech.service.sistema;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.mapper.sistema.ParametroMapper;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.model.sistema.Versao;
import py.com.flextech.repository.sistema.ParametroRepository;


@Transactional(rollbackFor = Exception.class)
@Service
@RequiredArgsConstructor
public class ParametroService {

	private final ParametroMapper parametroMapper;
	
	private final ParametroRepository parametroRepository;
	
	private final VersaoService versaoService;
	
	
	
	public Parametro findParametroByEmpresa(Long tenant){
		Parametro parametro = parametroMapper.findParametroByEmpresa(tenant);
		Versao v = versaoService.findVersao();
		parametro.setVersao(v);
		return parametro;
	}
	
	public Parametro save(Long tenant, Parametro parametro){
		parametro.setDtUltModificacao(LocalDateTime.now());
		parametro = parametroRepository.save(parametro);
		return parametro;
	}
	

}
