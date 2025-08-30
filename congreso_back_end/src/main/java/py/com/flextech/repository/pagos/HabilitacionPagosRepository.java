package py.com.flextech.repository.pagos;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import py.com.flextech.model.pagos.HabilitacionPagos;
import py.com.flextech.model.sistema.Usuario;



public interface HabilitacionPagosRepository extends JpaRepository<HabilitacionPagos, Long> {

	List<HabilitacionPagos> findByUsuario(Usuario usuario);

}
