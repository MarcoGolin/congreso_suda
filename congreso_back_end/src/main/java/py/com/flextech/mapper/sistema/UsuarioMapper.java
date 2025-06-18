package py.com.flextech.mapper.sistema;

import java.util.List;

import com.github.pagehelper.Page;

import py.com.flextech.model.sistema.Usuario;

public interface UsuarioMapper {
	
	List<Usuario> findByNomeWithDepartamentos(Long tenant, String nome);

	Usuario findByEmailAndSenha(String login, String senha);

	Usuario findByLogin(String login);

	List<Usuario> findByNomeAtivo(Long tenant, String nome);

	List<Usuario> findAllAtivos(Long tenant);
	
	List<Usuario> findAtivosByDepartamento(Long tenant, Long idDepartamento);

	void ativaNovoUsuario(Long id);

	Usuario findById(Long id);
	
	Page<Usuario> findByConditionSimples(String condition, Long tenant);
	
	List<Usuario> findUsuariosPendienteArreglo(Long tenant, String nombre);

}
