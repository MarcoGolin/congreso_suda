package py.com.flextech.service.pago;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.text.NumberFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Currency;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.repository.sistema.ParametroRepository;
import py.com.flextech.repository.sistema.UsuarioRepository;
import py.com.flextech.service.sistema.EmailQueueService;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class PagoService {
	
	  private static final Locale LOCALE_PY = new Locale("es", "PY");
	  private static final Currency PYG = Currency.getInstance("PYG");

	
	private final UsuarioRepository repository;
	private final ParametroRepository parametroRepository;
	private final EmailQueueService emailQueueService;
	
	private static final String CODE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
	// (sin I, O, 0, 1 para evitar confusión)
	private static final SecureRandom RAND = new SecureRandom();

	private static final ZoneId ZONE_PY = ZoneId.of("America/Sao_Paulo");
	private static final DateTimeFormatter DTF_PY =
	    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", new Locale("es", "PY"))
	                     .withZone(ZONE_PY);

	private static String randomCode(int len) {
	    StringBuilder sb = new StringBuilder(len);
	    for (int i = 0; i < len; i++) {
	        sb.append(CODE_ALPHABET.charAt(RAND.nextInt(CODE_ALPHABET.length())));
	    }
	    return sb.toString();
	}

	/** Genera un comprobante único; intenta 5 veces con 6 chars, luego sube a 8 si colisiona. */
	private String generarComprobanteUnico() {
		 String code = randomCode(6);
	     return code;
	}
	
	private static String formatFechaPago(LocalDateTime instant) {
	    if (instant == null) return "";
	    return DTF_PY.format(instant);
	}
	
	public GenericResponseEntity<?> confirmar(Long idUsuario, Long idCongresista, Boolean isExonerado) {
		
		Usuario usuarioPago = repository.findById(idUsuario).get();
		Usuario congresista = repository.findById(idCongresista).get();
		Parametro parametro = parametroRepository.findById(1L).get();
		
		
		if(congresista.getIsPago() == false) {
			congresista.setIsPago(true);
			congresista.setFechaPago(LocalDateTime.now());
			congresista.setNrComprobante(generarComprobanteUnico());
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
		
		String titulo = "Confirmacion de Pago de la inscripción IVCUSMI";
		String template = "email_confirmacion_pago.ftl";
		String destino = congresista.getEmail();
		String nombre = congresista.getNombreCompleto();
		Map<String, String> model = new HashMap<>();
		model.put("nombre", nombre);
		model.put("titulo", titulo);
		model.put("monto", formatGuaranies(congresista.getMontoPago()));
		model.put("numeroComprobante", congresista.getNrComprobante());
		model.put("fechaPago", formatFechaPago(congresista.getFechaPago()));
		model.put("codigoInscripcion", congresista.getUuid());
		emailQueueService.encolarEnvio(destino, titulo, null, model, template);
		
	    return new GenericResponseEntity<Usuario>("Guardado con Éxito!", 200, congresista);
	}
	
		
	public GenericResponseEntity<?> anular(Long idUsuario, Long idCongresista) {
		Usuario usuarioAnulacion = repository.findById(idUsuario).get();
		Usuario congresista = repository.findById(idCongresista).get();
		
		congresista.setMontoPago(BigDecimal.ZERO);
		congresista.setIsPago(false);
		congresista.setIsExonerado(false);
		congresista.setObsAnulacionPago("El usuario " + usuarioAnulacion.getNombreCompleto() + " anulo en fecha "+LocalDateTime.now());
		congresista =  repository.saveAndFlush(congresista);
		
		
	    return new GenericResponseEntity<Usuario>("Anulado con Éxito!", 200, congresista);
	}
	
	
	 public static String formatGuaranies(BigDecimal amount) {
		    if (amount == null) return "";
		    NumberFormat nf = NumberFormat.getCurrencyInstance(LOCALE_PY);
		    nf.setCurrency(PYG);
		    int fd = PYG.getDefaultFractionDigits(); // Para PYG es 0
		    nf.setMaximumFractionDigits(fd);
		    nf.setMinimumFractionDigits(fd);
		    nf.setGroupingUsed(true);
		    return nf.format(amount);
		  }
	
	
}
