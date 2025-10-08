package py.com.flextech.repository.sorteo;


import org.springframework.data.jpa.repository.JpaRepository;

import py.com.flextech.model.sorteo.Sorteo;


public interface SorteoRepository extends JpaRepository<Sorteo, Long> {


}
