package py.com.flextech.service.sistema;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import py.com.flextech.model.sistema.AuditoriaPlatform;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.repository.sistema.AuditoriaPlatformRepository;

@Service
@Transactional(rollbackFor = Exception.class)
public class AuditoriaPlatformService {

	@Autowired
	private AuditoriaPlatformRepository auditoriaPlatformRepository;


	public void save(Usuario usuario) {
		AuditoriaPlatform aud = new AuditoriaPlatform();
		aud.setUsuario(usuario);
		aud.setDtUltimoLogin(LocalDateTime.now());
		auditoriaPlatformRepository.save(aud);
		
	}

}
