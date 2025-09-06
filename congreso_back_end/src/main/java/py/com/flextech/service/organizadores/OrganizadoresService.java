package py.com.flextech.service.organizadores;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.organizadores.Organizadores;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.repository.organizadores.OrganizadoresRepository;
import py.com.flextech.repository.sistema.ParametroRepository;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class OrganizadoresService {
	
	private final OrganizadoresRepository repository;
	private final ParametroRepository parametroRepository;
	
	
	public GenericResponseEntity<List<Organizadores>> consultaTodos() {
		Parametro parametro = parametroRepository.findById(1L).get();
		Boolean mostrarComite = parametro.getMostrarComite();
		List<Organizadores> list = new ArrayList<>();
		if(mostrarComite == true) {
			list = repository.findAll();
		}
	    return new GenericResponseEntity<List<Organizadores>>("Consulta con Éxito!", 200, list);
	}
	
}
