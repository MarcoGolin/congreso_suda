package py.com.flextech.repository.taller;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import py.com.flextech.model.taller.Taller;
import py.com.flextech.model.sistema.Usuario;




public interface TallerRepository extends JpaRepository<Taller, Long> {

	List<Taller> findByResponsable(Usuario responsable);

	List<Taller> findByTituloContainingIgnoreCaseOrDescripcionContainingIgnoreCase(String titulo, String descripcion);

}
