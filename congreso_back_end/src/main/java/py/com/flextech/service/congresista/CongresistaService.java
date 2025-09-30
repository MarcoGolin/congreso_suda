package py.com.flextech.service.congresista;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import lombok.RequiredArgsConstructor;
import py.com.flextech.mapper.congresista.CongresistaMapper;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.pagos.dto.ResumenCobradoDto;
import py.com.flextech.model.pagos.enums.FiltroEstado;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.enums.TipoUsuarioEnum;
import py.com.flextech.repository.sistema.UsuarioRepository;
import py.com.flextech.service.sistema.EmailQueueService;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class CongresistaService {
	
	private final UsuarioRepository repository;
	private final EmailQueueService emailQueueService;
	private final CongresistaMapper congresistaMapper;
	
	public GenericResponseEntity<?> save(Usuario usuario) {
		
		Boolean enviarEmailConfirmacion = false;
		
		if(usuario.getId()== null) {
			
			Optional<Usuario> existente = repository.findByEmail(usuario.getEmail());
			if(existente.isPresent()) {
				return new GenericResponseEntity<String>("El Email " + usuario.getEmail() + " ya se encuentra registrado!", 201, null);
			}
			
			 usuario.setFechaRegistro(LocalDateTime.now());
			 UUID uuid = UUID.randomUUID();
			 usuario.setUuid(uuid.toString());
			 usuario.setIsCongresista(true);
			 enviarEmailConfirmacion = true;
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
			emailQueueService.encolarEnvio(destino, titulo, null, model, template);
		}
	    return new GenericResponseEntity<Usuario>("Guardado con Éxito!", 200, usuario);
	}
	
	
	public GenericResponseEntity<PageInfo<Usuario>> consultaCongresistaPorNombreORegistroAcademico(String nombre, 
			String registroAcademico, 
			int pageNo,
			int pageSize) {
		PageHelper.startPage(pageNo, pageSize, true);
		Page<Usuario> congresistas = congresistaMapper.consultaCongresistaPorNombreORegistroAcademico(nombre, registroAcademico);
		return new GenericResponseEntity<PageInfo<Usuario>>("Guardado con Éxito!", 200, new PageInfo<>(congresistas));
	}
	
	public GenericResponseEntity<PageInfo<Usuario>> consultaConFiltros(
		    String nombre,
		    String registroAcademico,
		    FiltroEstado estado,
		    LocalDateTime desde,
		    LocalDateTime hasta,
		    int pageNo,
		    int pageSize) {

		  PageHelper.startPage(pageNo, pageSize, true);
		  final boolean aplicaFechaPago = (estado == FiltroEstado.PAGOS || estado == FiltroEstado.EXONERADOS);

		  Page<Usuario> page = congresistaMapper.consultaCongresistaConFiltros(
		      nombre,
		      registroAcademico,
		      estado != null ? estado.name() : "TODOS",
		      desde, hasta,
		      aplicaFechaPago
		  );
		  return new GenericResponseEntity<>("OK", 200, new PageInfo<>(page));
		}

		public GenericResponseEntity<List<ResumenCobradoDto>> resumenCobradorTurno(
		    LocalDateTime desde, LocalDateTime hasta) {
		  List<ResumenCobradoDto> rows = congresistaMapper.resumenPorCobradorTurno(desde, hasta);
		  return new GenericResponseEntity<>("OK", 200, rows);
		}
		
		
		public GenericResponseEntity<List<Usuario>> consultaCongresistaPorTipo(TipoUsuarioEnum tpUsuario) {
			
			  String condicion = "";
			  
			  if(tpUsuario == TipoUsuarioEnum.boStaff) {
				  condicion = "U.BO_STAFF = TRUE";
			  }else if (tpUsuario == TipoUsuarioEnum.boInvitado) {
				  condicion = "U.BO_INVITADO = TRUE";
			  }else if (tpUsuario == TipoUsuarioEnum.boDisertante) {
				  condicion = "U.BO_DISERTANTE = TRUE";
			  }else {
				  condicion = "U.BO_CONGRESISTA = TRUE AND U.BO_STAFF = FALSE AND U.BO_INVITADO = FALSE AND U.BO_DISERTANTE = FALSE";
			  }
			  
			  List<Usuario> list = congresistaMapper.consultaCongresistaPorCondicion(condicion);
			  return new GenericResponseEntity<>("OK", 200, list);
		}
		
		
		public GenericResponseEntity<String> reenviarEmailInscripcion() {
			  String condicion = "u.BO_ENVIADO_EMAIL_INSCRIPCION = FALSE";
			  List<Usuario> list = congresistaMapper.consultaCongresistaPorCondicion(condicion);
			  for (Usuario usuario : list) {
					String titulo = "Confirmacion de Correo IVCUSMI";
					String template = "email_confirmacion.ftl";
					String destino = usuario.getEmail();
					String nombre = usuario.getNombreCompleto();
					Map<String, String> model = new HashMap<>();
					model.put("nombre", nombre);
					model.put("titulo", titulo);
					emailQueueService.encolarEnvio(destino, titulo, null, model, template);
			}
			  return new GenericResponseEntity<>("OK", 200, list.size() + " correos reenviados!");
		}
		
		public GenericResponseEntity<?> restablecerContrasenha(Long idUsuario) {
			Usuario usuario = repository.findById(idUsuario).get();
			usuario.setSenha(usuario.getRegistroAcademico());
			usuario = repository.saveAndFlush(usuario);
		    return new GenericResponseEntity<Usuario>("Contraseña establecida con Éxito!", 200, usuario);
		}
		
		public GenericResponseEntity<?> consultaCongresistaPorId(Long idUsuario) {
			Usuario  usuario = repository.findById(idUsuario).get();
		    return new GenericResponseEntity<Usuario>("Contraseña establecida con Éxito!", 200, usuario);
		}
		
		static byte[] uuidStringToBytes(String s) {
			  String hex = s.replace("-", "");
			  int n = hex.length();
			  byte[] out = new byte[n/2];
			  for (int i=0; i<n; i+=2) out[i/2] = (byte) Integer.parseInt(hex.substring(i, i+2), 16);
			  return out;
		}
		
		public GenericResponseEntity<Usuario> consultaByUUID(String uuid) {
			Usuario  usuario = repository.findByUuidBin(uuidStringToBytes(uuid)).get();
			return new GenericResponseEntity<Usuario>("Contraseña establecida con Éxito!", 200, usuario);
		}

}
