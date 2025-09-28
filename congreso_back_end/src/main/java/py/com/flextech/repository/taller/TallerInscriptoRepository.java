package py.com.flextech.repository.taller;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import py.com.flextech.model.taller.TallerInscripto;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.taller.Taller;




public interface TallerInscriptoRepository extends JpaRepository<TallerInscripto, Long> {


	List<TallerInscripto> findByTallerAndUsuario(Taller taller, Usuario usuario);

	List<TallerInscripto> findByUsuario(Usuario usuario);
}
