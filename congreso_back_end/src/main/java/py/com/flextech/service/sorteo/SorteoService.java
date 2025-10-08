package py.com.flextech.service.sorteo;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.mapper.congresista.CongresistaMapper;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sorteo.Sorteo;
import py.com.flextech.repository.sorteo.SorteoRepository;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class SorteoService {
	
	private final CongresistaMapper congresistaMapper;
	private final SorteoRepository repository;
	
	
	public GenericResponseEntity<?> guardarGanador(Long idUsuario, String auspiciante) {
		Sorteo sorteo =  new Sorteo(idUsuario, auspiciante);
		repository.save(sorteo);
		return new GenericResponseEntity<List<Usuario>>("Guardo con Éxito!", 200,null);
	}
		
	public GenericResponseEntity<List<Usuario>> consultaCongresistaDisponiblesSorteo(String tipoSorteo) {
		List<Usuario> list = congresistaMapper.consultaCongresistaDisponiblesSorteo(tipoSorteo);
		return new GenericResponseEntity<List<Usuario>>("Consulta con Éxito!", 200, list);
	}


}
