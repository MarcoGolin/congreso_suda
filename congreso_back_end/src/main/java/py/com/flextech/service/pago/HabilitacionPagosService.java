package py.com.flextech.service.pago;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.pagos.HabilitacionPagos;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.repository.pagos.HabilitacionPagosRepository;
import py.com.flextech.repository.sistema.UsuarioRepository;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class HabilitacionPagosService {
	
	private final HabilitacionPagosRepository repository;
	private final UsuarioRepository usuarioRepository;
	
	public GenericResponseEntity<HabilitacionPagos> habilitar(Long idUsuario, HabilitacionPagos habilitacion) {

		habilitacion.setFechaRegistro(LocalDateTime.now());
		habilitacion.setUsuarioRegistro(new Usuario(idUsuario));
		habilitacion = repository.saveAndFlush(habilitacion);
		
		//habilita al financiero al congresista
		Usuario congresista = usuarioRepository.findById(habilitacion.getUsuario().getId()).get();
		congresista.setIsFinanciero(true);
		congresista =  usuarioRepository.saveAndFlush(congresista);
		
	    return new GenericResponseEntity<HabilitacionPagos>("Guardado con Éxito!", 200, habilitacion);
	}
	
	public GenericResponseEntity<List<HabilitacionPagos>> consultaHorarios(Long idUsuario) {
		List<HabilitacionPagos> habilitaciones = repository.findByUsuario(new Usuario(idUsuario));
	    return new GenericResponseEntity<List<HabilitacionPagos>>("Guardado con Éxito!", 200, habilitaciones);
	}
	
	public GenericResponseEntity<HabilitacionPagos> consultarSiEstaHabilitado(Long idUsuario) {
	    System.out.println("********* consultarSiEstaHabilitado *************");
	    System.out.println("USUARIO ID: " + idUsuario);

	    List<HabilitacionPagos> lista = repository.findByUsuario(new Usuario(idUsuario));
	    LocalDateTime ahora = LocalDateTime.now();

	    System.out.println("Ahora: " + ahora);
	    System.out.println("Total habilitaciones encontradas: " + (lista != null ? lista.size() : 0));

	    if (lista != null) {
	        int i = 1;
	        for (HabilitacionPagos h : lista) {
	            System.out.println("---- Habilitacion #" + i + " ----");
	            System.out.println("ID: " + h.getId());
	            System.out.println("Inicio: " + h.getInicio());
	            System.out.println("Fin: " + h.getFin());
	            System.out.println("Usuario: " + (h.getUsuario() != null ? h.getUsuario().getId() : "null"));
	            System.out.println("Activo? " + (!ahora.isBefore(h.getInicio()) && !ahora.isAfter(h.getFin())));
	            System.out.println("toString(): " + h.toString());
	            i++;
	        }
	    }

	    Optional<HabilitacionPagos> habilitacionExistente = Optional.ofNullable(
	        lista.stream()
	             .filter(h -> (!ahora.isBefore(h.getInicio()) && !ahora.isAfter(h.getFin())))
	             .findFirst()
	             .orElse(null)
	    );

	    System.out.println("Resultado habilitacionExistente.isPresent(): " + habilitacionExistente.isPresent());
	    habilitacionExistente.ifPresent(h -> {
	        System.out.println("Habilitación seleccionada -> ID: " + h.getId());
	        System.out.println("Inicio: " + h.getInicio());
	        System.out.println("Fin: " + h.getFin());
	    });

	    return new GenericResponseEntity<HabilitacionPagos>(
	        "Guardado con Éxito!",
	        200,
	        habilitacionExistente
	    );
	}

}
