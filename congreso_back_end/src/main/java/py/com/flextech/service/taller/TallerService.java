package py.com.flextech.service.taller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.taller.Taller;
import py.com.flextech.repository.sistema.ParametroRepository;
import py.com.flextech.repository.sistema.UsuarioRepository;
import py.com.flextech.repository.taller.TallerRepository;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class TallerService {
	
	private final TallerRepository repository;
	private final UsuarioRepository usuarioRepository;
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
	
	public GenericResponseEntity<List<Taller>> consultaPorDescripcion(String descripcion) {
		List<Taller> list = new ArrayList<>();
		list = repository.findAll();
	    return new GenericResponseEntity<List<Taller>>("Consulta con Éxito!", 200, list);
	}

	public GenericResponseEntity<?> asignarResponsable(Long idUsuario, Long idTaller) {
		Taller taller = repository.findById(idTaller).get();
		if(idUsuario != null) {
			taller.setResponsable(new Usuario(idUsuario));
			Usuario u = usuarioRepository.findById(idUsuario).get();
			u.setIsStaff(true);
			u = usuarioRepository.save(u);
		}else {
			taller.setResponsable(null);
		}
		taller = repository.save(taller);
		
		return new GenericResponseEntity<Taller>("Guardo con Éxito!", 200, taller);
	}

	public GenericResponseEntity<Taller> consultaTallerById(Long idTaller) {
		Taller taller = repository.findById(idTaller).get();
		return new GenericResponseEntity<Taller>("Consulto con Éxito!", 200, taller);
	}
	
	
	
	
}
