package py.com.flextech.repository.checkin;


import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import py.com.flextech.model.checkin.Checkin;
import py.com.flextech.model.checkin.enums.CheckinTipoEnum;
import py.com.flextech.model.checkin.enums.CoffeeBreakEnum;


public interface CheckInRepository extends JpaRepository<Checkin, Long> {
	
	  boolean existsByUsuarioIdAndTipo(Long idUsuario, CheckinTipoEnum tipo);

	  Optional<Checkin> findFirstByUsuarioIdAndTipoOrderByFechaRegistroDesc(
	      Long idUsuario, CheckinTipoEnum tipo);

	  boolean existsByUsuarioIdAndTipoAndRefriSlotAndFechaRegistroGreaterThanEqualAndFechaRegistroLessThan(
	      Long idUsuario,
	      CheckinTipoEnum tipo,
	      CoffeeBreakEnum refriSlot,
	      LocalDateTime desdeIncl,
	      LocalDateTime hastaExcl);

	  Optional<Checkin> findFirstByUsuarioIdAndTipoAndRefriSlotAndFechaRegistroGreaterThanEqualAndFechaRegistroLessThanOrderByFechaRegistroDesc(
	      Long idUsuario,
	      CheckinTipoEnum tipo,
	      CoffeeBreakEnum refriSlot,
	      LocalDateTime desdeIncl,
	      LocalDateTime hastaExcl);

}
