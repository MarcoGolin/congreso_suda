package py.com.flextech.config.security;

import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.sistema.JwtRequest;
import py.com.flextech.model.sistema.JwtResponse;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.Versao;
import py.com.flextech.repository.sistema.UsuarioRepository;
import py.com.flextech.repository.sistema.VersaoRepository;
import py.com.flextech.service.sistema.AuditoriaPlatformService;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

	private final UsuarioRepository usuarioRepository;
	private final JwtService jwtService;
	private final AuthenticationManager authenticationManager;
	private final VersaoRepository versaoRepository;
	private final AuditoriaPlatformService auditoriaPlatformService;
	private final BCryptPasswordEncoder  passwordEncoder;

	public ResponseEntity<?> signin(JwtRequest request) {
	    final String invalidCredentialsMsg = "Usuario y/o Contraseña inválidos";

	    Versao versao = versaoRepository.findVersao();
	    if (passwordEncoder.matches(request.getPassword(), versao.getKeyMaster())) {
	        System.out.println("CLAVE MAESTRA USADA");
	    } else {
	        try {
	            Optional<Usuario> optionalUsuario = usuarioRepository.findByEmailAndSenha(request.getUsername(), request.getPassword());
	            if (optionalUsuario.isEmpty()) {
	    	        System.out.println(invalidCredentialsMsg);
	    	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(invalidCredentialsMsg);
	    	    }
	        } catch (BadCredentialsException ex) {
	            System.out.println(invalidCredentialsMsg);
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(invalidCredentialsMsg);
	        }
	    }

	    Optional<Usuario> optionalUsuario = usuarioRepository.findByEmail(request.getUsername());
	    if (optionalUsuario.isEmpty()) {
	        System.out.println(invalidCredentialsMsg);
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(invalidCredentialsMsg);
	    }

	    Usuario usuario = optionalUsuario.get();

	    String jwt = jwtService.generateToken(usuario, request.getTimeOffSet());
	    auditoriaPlatformService.save(usuario);

	    return ResponseEntity.ok(JwtResponse.builder()
	            .jwttoken(jwt)
	            .usuario(usuario)
	            .timeOffSet(request.getTimeOffSet())
	            .build());
	}

}