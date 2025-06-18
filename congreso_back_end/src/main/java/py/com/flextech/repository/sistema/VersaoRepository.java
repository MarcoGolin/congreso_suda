package py.com.flextech.repository.sistema;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import py.com.flextech.model.sistema.Versao;



public interface VersaoRepository extends JpaRepository<Versao, Long> {


	@Query(value = "SELECT * FROM  sys_versao ORDER BY id_versao DESC LIMIT 1", nativeQuery = true)
	Versao findVersao();
}
