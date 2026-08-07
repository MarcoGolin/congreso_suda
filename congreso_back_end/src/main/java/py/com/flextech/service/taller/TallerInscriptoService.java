package py.com.flextech.service.taller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import lombok.RequiredArgsConstructor;
import py.com.flextech.mapper.taller.TallerInscriptoMapper;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.taller.Taller;
import py.com.flextech.model.taller.TallerInscripto;
import py.com.flextech.repository.sistema.UsuarioRepository;
import py.com.flextech.repository.taller.TallerInscriptoRepository;
import py.com.flextech.repository.taller.TallerRepository;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class TallerInscriptoService {
	
	private final TallerInscriptoRepository repository;
	private final TallerRepository tallerRepository;
	private final UsuarioRepository usuarioRepository;
	private final TallerInscriptoMapper tallerInscriptoMapper;
	
	public GenericResponseEntity<TallerInscripto> inscribir(Long idUsuario, Long idTaller, Boolean isJuntaDirectiva) {
		Usuario usuario = usuarioRepository.findById(idUsuario).get();
		if(Boolean.FALSE.equals(usuario.getIsPago()) && !Boolean.TRUE.equals(usuario.getIsExonerado())) {
			return new GenericResponseEntity<TallerInscripto>(usuario.getNombreCompleto() + ", está pendiente el pago de su inscripción al congreso para poder participar de los talleres!", 300, null);
		}
		Taller taller = tallerRepository.findById(idTaller).get();
		
		List<TallerInscripto> talleresInscriptos = repository.findByTallerAndUsuario(taller, usuario);
		if(!talleresInscriptos.isEmpty()) {
			return new GenericResponseEntity<TallerInscripto>("Ya se encuentra inscripto al taller: " + taller.getTitulo(), 300, talleresInscriptos.get(0));
		}
		TallerInscripto inscripcion =  new TallerInscripto();
		inscripcion.setFecha(LocalDateTime.now());
		inscripcion.setTaller(taller);
		inscripcion.setUsuario(usuario);
		inscripcion.setIsExonerado(false);
		inscripcion.setIsJuntaDirectiva(isJuntaDirectiva);
		inscripcion =  repository.saveAndFlush(inscripcion);
	    return new GenericResponseEntity<TallerInscripto>("Guardo con Éxito!", 200, inscripcion);
	}
	
	public GenericResponseEntity<TallerInscripto> verificarInscripto(Long idUsuario, Long idTaller) {
		Usuario usuario = usuarioRepository.findById(idUsuario).get();
		Taller taller = tallerRepository.findById(idTaller).get();
		List<TallerInscripto> talleresInscriptos = repository.findByTallerAndUsuario(taller, usuario);
		if(talleresInscriptos.isEmpty()) {
			return new GenericResponseEntity<TallerInscripto>("No se encuentra inscripto al taller: " + taller.getTitulo(), 404, null);
		}
		TallerInscripto tallerInscripto = talleresInscriptos.get(0);
	    return new GenericResponseEntity<TallerInscripto>("Guardo con Éxito!", 200, tallerInscripto);
	}
	
	public GenericResponseEntity<List<TallerInscripto>> consultarTalleresPorUsuario(Long idUsuario) {
		List<TallerInscripto> talleresInscriptos = repository.findByUsuario(new Usuario(idUsuario));
	    return new GenericResponseEntity<List<TallerInscripto>>("Consulto con Éxito!", 200, talleresInscriptos);
	}
	
	public GenericResponseEntity<PageInfo<Usuario>> consultaParticipantesDelTaller(Long idTaller,
			int pageNo,
			int pageSize) {
		PageHelper.startPage(pageNo, pageSize, true);
		Page<TallerInscripto> congresistas = tallerInscriptoMapper.consultaParticipantesDelTaller(idTaller);
		return new GenericResponseEntity<PageInfo<Usuario>>("Guardado con Éxito!", 200, new PageInfo<>(congresistas));
	}

	public GenericResponseEntity<?> remover(Long idInscripto) {
		repository.deleteById(idInscripto);
		return new GenericResponseEntity<String>("Removido con Éxito!", 200, "");
	}
	
}
