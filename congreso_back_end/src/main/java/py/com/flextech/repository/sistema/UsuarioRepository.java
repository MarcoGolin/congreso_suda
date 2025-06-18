package py.com.flextech.repository.sistema;


import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import py.com.flextech.model.sistema.Usuario;


public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

	Boolean existsByEmail(String email);

	Optional<Usuario> findByEmail(String email);

	Optional<Usuario> findByEmailAndSenha(String email, String senha);


}
