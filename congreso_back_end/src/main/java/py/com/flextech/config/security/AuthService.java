package py.com.flextech.config.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.repository.sistema.UsuarioRepository;

@Service
public class AuthService {

	@Autowired
	private UsuarioRepository usuarioRepository;
	
	
	public UserDetailsService userDetailsService() {
		return new UserDetailsService() {
			@Override
			public UserDetails loadUserByUsername(String username) {
				Usuario usuario = usuarioRepository.findByEmail(username).get();
				return usuario;
			}
		};
	}
}
