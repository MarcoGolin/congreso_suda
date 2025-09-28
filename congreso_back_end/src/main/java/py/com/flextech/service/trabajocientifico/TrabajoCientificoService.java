package py.com.flextech.service.trabajocientifico;

import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.trabajocientifico.Coautor;
import py.com.flextech.model.trabajocientifico.TrabajoCientifico;
import py.com.flextech.repository.trabajocientifico.TrabajoCientificoRepository;
import py.com.flextech.service.sistema.EmailQueueService;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class TrabajoCientificoService {
	
	private final TrabajoCientificoRepository repository;
	private final EmailQueueService emailQueueService;
	
	public GenericResponseEntity<?> save(Long idUsuario, TrabajoCientifico data) {
		data.setFechaRegistro(Instant.now());
		data.setUsuario(new Usuario(idUsuario));
		// Coautores: evitar null y setear backref
	    List<Coautor> coautores = Optional.ofNullable(data.getCoautores()).orElseGet(ArrayList::new);
	    for (Coautor c : coautores) {
	        c.setTrabajoCientifico(data);
	    }
	    data.setCoautores(coautores);
		data = repository.saveAndFlush(data);
		
		
		// --- email ---
	    final String titulo   = "Recepción confirmada – Trabajo '"+ data.getTitulo()+"' enviado al IV CUSMI 2025";
	    final String template = "email_recepcion_trabajo.ftl";

	    // Destinatarios (dedup + limpieza)
	    LinkedHashSet<String> para = new LinkedHashSet<>();
	    if (hasText(data.getAutorEmail())) para.add(data.getAutorEmail());

	 // Coautores: nombre — filiación en la misma línea
	    StringBuilder coautoresSB = new StringBuilder();
	    for (Coautor c : coautores) {
	        if (coautoresSB.length() > 0) coautoresSB.append("<br>");
	        String nombre    = orDash(c != null ? c.getNombre()   : null);
	        String filiacion = orDash(c != null ? c.getFiliacion() : null);
	        coautoresSB.append(nombre).append(" — ").append(filiacion);
	        para.add(c.getEmail());
	    }
	    String coautoresLinea = coautoresSB.length() == 0 ? "—" : coautoresSB.toString();

	   
	    // Adjuntos (si usás URL, acá solo informo estado “adjuntado/no adjuntado”)
	    boolean hasWord = hasText(data.getArchivoWordUrl());
	    boolean hasPdf  = hasText(data.getArchivoPdfUrl());

	    Map<String, String> model = new HashMap<>();
	    model.put("titulo", titulo);
	    model.put("autorPrincipal", orDash(data.getAutorNombre()));

	    model.put("tituloTrabajo", orDash(data.getTitulo()));
	    model.put("modalidad", orDash(data.getModalidad()));
	    model.put("areaTematica", orDash(data.getAreaTematica()));
	    model.put("areaDeLaMedicina", orDash(data.getAreaDeLaMedicina()));

	    model.put("autorPrincipalNombreCompleto", orDash(data.getAutorNombre()));
	    // Si tenés un campo real de filiación del autor principal, usalo acá
	    model.put("autorPrincipalFiliacion", orDash(data.getAutorFiliacion())); // o "FILIACIÓN PENDIENTE"

	    model.put("coautoresLinea", coautoresLinea);

	    model.put("archivoWord", hasWord ? "https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/"+data.getArchivoWordUrl() : null);
	    model.put("archivoPDF",  hasPdf  ? "https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/"+data.getArchivoPdfUrl() : null);

	    // Encolar envío (sin adjunto en este caso -> null)
	    
	    //ENVIAR AL RESPONSABLE
	    para.add("congresosudamericana@gmail.com");
	    para.add("marco.golin@congresounisud.com");
	    
	    System.out.println("LISTA ENVIO EMAIL : " + para);
	    
	    emailQueueService.encolarEnvio(para, titulo, null, model, template);

	    return new GenericResponseEntity<>("Guardado con Éxito!", 200, data);
	}
	
	private static boolean hasText(String s) {
	    return s != null && !s.isBlank();
	}

	private static String orDash(String s) {
	    return hasText(s) ? s : "—";
	}
	
	
	public GenericResponseEntity<List<TrabajoCientifico>> consultaTrabajosPorUsuario(Long idUsuario){
		
		List<TrabajoCientifico> trabajos = repository.findByUsuario(new Usuario(idUsuario));
		
		 return new GenericResponseEntity<List<TrabajoCientifico>>("Consulta con Éxito!", 200, trabajos);
		
	}

	public GenericResponseEntity<List<TrabajoCientifico>> consultaTodos(){
		
		List<TrabajoCientifico> trabajos = repository.findAll();
		
		return new GenericResponseEntity<List<TrabajoCientifico>>("Consulta con Éxito!", 200, trabajos);
		
	}
}


