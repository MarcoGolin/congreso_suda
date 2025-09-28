package py.com.flextech.service.taller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.organizadores.Organizadores;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.model.taller.Taller;
import py.com.flextech.repository.organizadores.OrganizadoresRepository;
import py.com.flextech.repository.sistema.ParametroRepository;
import py.com.flextech.repository.taller.TallerRepository;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class TallerService {
	
	private final TallerRepository repository;
	private final ParametroRepository parametroRepository;
	
	
	public GenericResponseEntity<List<Taller>> consultaTodos() {
		Parametro parametro = parametroRepository.findById(1L).get();
		Boolean mostrarTaller = parametro.getMostrarTalleres();
		List<Taller> list = new ArrayList<>();
		if(mostrarTaller == true) {
			list = repository.findAll();
		}
	    return new GenericResponseEntity<List<Taller>>("Consulta con Éxito!", 200, list);
	}
	
}
