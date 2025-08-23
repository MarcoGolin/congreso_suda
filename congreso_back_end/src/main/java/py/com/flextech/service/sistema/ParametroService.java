package py.com.flextech.service.sistema;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.mapper.sistema.ParametroMapper;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.repository.sistema.ParametroRepository;


@Transactional(rollbackFor = Exception.class)
@Service
@RequiredArgsConstructor
public class ParametroService {

	private final ParametroMapper parametroMapper;
	private final ParametroRepository parametroRepository;
	
	public Parametro findParametroByEmpresa(Long tenant){
		Parametro parametro = parametroMapper.findParametroByEmpresa(tenant);
		return parametro;
	}
	
	public Parametro save(Long tenant, Parametro parametro){
		parametro = parametroRepository.save(parametro);
		return parametro;
	}
	

}
