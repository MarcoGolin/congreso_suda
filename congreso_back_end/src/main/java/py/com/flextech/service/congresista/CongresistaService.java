package py.com.flextech.service.congresista;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Rol;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.repository.sistema.UsuarioRepository;
import py.com.flextech.service.sistema.EmailQueueService;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class CongresistaService {
	
	private final UsuarioRepository repository;
//	private final JwtService jwtService;
	private final EmailQueueService emailQueueService;
	
	public GenericResponseEntity<?> save(Usuario usuario) {
		Optional<Usuario> existente = repository.findByEmail(usuario.getEmail());
		if(existente.isPresent()) {
			return new GenericResponseEntity<String>("El Email " + usuario.getEmail() + " ya se encuentra registrado!", 201, null);
		}
		
		Boolean enviarEmailConfirmacion = false;
		
		if(usuario.getId()== null) {
			usuario.setFechaRegistro(Instant.now());
			 UUID uuid = UUID.randomUUID();
			 usuario.setUuid(uuid.toString());
			 enviarEmailConfirmacion = true;
			 usuario.setRol(Rol.CONGRESISTA);
			 usuario.setIsActivado(false);
		}
		usuario = repository.save(usuario);
		
		if(enviarEmailConfirmacion) {
			String titulo = "Confirmacion de Correo IVCUSMI";
			String template = "email_confirmacion.ftl";
			String destino = usuario.getEmail();
			String nombre = usuario.getNombreCompleto();
			Map<String, String> model = new HashMap<>();
			model.put("nombre", nombre);
			model.put("titulo", titulo);
			model.put("codigoActivacionUrl", "CODIGO DE ACTIVACION DE PRUEBA");
			emailQueueService.encolarEnvio(destino, titulo, nombre, null, model, template);
		}
	    return new GenericResponseEntity<Usuario>("Guardado con Éxito!", 200, usuario);
	}
}
