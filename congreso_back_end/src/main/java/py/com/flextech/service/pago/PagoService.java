package py.com.flextech.service.pago;

import java.math.BigDecimal;
import java.time.Instant;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.repository.sistema.ParametroRepository;
import py.com.flextech.repository.sistema.UsuarioRepository;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class PagoService {
	
	private final UsuarioRepository repository;
	private final ParametroRepository parametroRepository;
//	private final EmailQueueService emailQueueService;
	
	public GenericResponseEntity<?> confirmar(Long idUsuario, Long idCongresista, Boolean isExonerado) {
		
		Usuario usuarioPago = repository.findById(idUsuario).get();
		Usuario congresista = repository.findById(idCongresista).get();
		Parametro parametro = parametroRepository.findById(1L).get();
		
		
		if(congresista.getIsPago() == false) {
			congresista.setIsPago(true);
			congresista.setFechaPago(Instant.now());
			congresista.setUsuarioPago(usuarioPago.getEmail() + " - " + usuarioPago.getNombreCompleto());
			if(isExonerado) {
				congresista.setMontoPago(BigDecimal.valueOf(0.0));
			}else {
				congresista.setMontoPago(parametro.getVlInscripconActual());
			}
			congresista.setIsExonerado(isExonerado);
			congresista = repository.saveAndFlush(congresista);
		}else {
			return new GenericResponseEntity<Usuario>("Pago ya realizado!", 400, congresista);
		}
		
//		String titulo = "Confirmacion de Correo IVCUSMI";
//		String template = "email_confirmacion.ftl";
//		String destino = usuario.getEmail();
//		String nombre = usuario.getNombreCompleto();
//		Map<String, String> model = new HashMap<>();
//		model.put("nombre", nombre);
//		model.put("titulo", titulo);
//		emailQueueService.encolarEnvio(destino, titulo, null, model, template);
		
	    return new GenericResponseEntity<Usuario>("Guardado con Éxito!", 200, congresista);
	}
	
	
}
