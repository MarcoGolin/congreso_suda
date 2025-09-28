package py.com.flextech.repository.trabajocientifico;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import py.com.flextech.model.trabajocientifico.TrabajoCientifico;
import py.com.flextech.model.sistema.Usuario;



public interface TrabajoCientificoRepository extends JpaRepository<TrabajoCientifico, Long> {
	
	List<TrabajoCientifico> findByUsuario(Usuario usuario);
}
