package py.com.flextech.service.checkIn;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.checkin.Checkin;
import py.com.flextech.model.checkin.enums.CheckinTipoEnum;
import py.com.flextech.model.checkin.enums.CoffeeBreakEnum;
import py.com.flextech.model.dto.GenericResponseEntity;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.taller.Taller;
import py.com.flextech.repository.checkin.CheckInRepository;
import py.com.flextech.repository.sistema.UsuarioRepository;
import py.com.flextech.utils.handlers.BadRequestException;
import py.com.flextech.utils.handlers.ConflictException;


@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class CheckInService {
	
		private final UsuarioRepository usuarioRepository;
		private final CheckInRepository checkInRepository;

		 public GenericResponseEntity<Checkin> checkin(
			      Long idUsuarioOperador,
			      String uuid,
			      CheckinTipoEnum tipo,
			      Long idTaller,
			      CoffeeBreakEnum refriSlot) {

			    // 1) Resolver congresista por UUID
			    Usuario congresista = usuarioRepository.findByUuidBin(uuidStringToBytes(uuid))
			        .orElseThrow(() -> new BadRequestException("QR inválido: no existe un usuario con ese UUID."));
			    
			    
			    

			    // 2) Validaciones por tipo
			    switch (tipo) {
			      case KIT_ENTREGADO -> validarKit(congresista.getId());
			      case COFFEE_BREAK_ENTREGADO -> validarCoffee(congresista.getId(), refriSlot);
			      case LIGA_ASISTENCIA -> {
			        if (idTaller == null) throw new BadRequestException("idTaller es obligatorio para TALLER_ASISTENCIA.");
			      }
			      default -> { /* CONGRESO_ASISTENCIA: sin restricciones previas */ }
			    }

			    // 3) Persistir
			    Checkin c = new Checkin();
			    c.setFechaRegistro(LocalDateTime.now());
			    c.setUsuario(congresista);
			    c.setTipo(tipo);
			    c.setUsuarioOperador(new Usuario(idUsuarioOperador));
			    if (idTaller != null) c.setTaller(new Taller(idTaller));
			    if (refriSlot != null) c.setRefriSlot(refriSlot);

			    c = checkInRepository.saveAndFlush(c); // si hay carrera, lo frena el índice único y lo mapeamos arriba
			    return new GenericResponseEntity<>("Check-in con éxito!", 200, c);
			  }

			  private void validarKit(Long idUsuario) {
			    if (checkInRepository.existsByUsuarioIdAndTipo(idUsuario, CheckinTipoEnum.KIT_ENTREGADO)) {
			      var previo = checkInRepository.findFirstByUsuarioIdAndTipoOrderByFechaRegistroDesc(
			          idUsuario, CheckinTipoEnum.KIT_ENTREGADO);
			      String cuando = previo.map(p -> p.getFechaRegistro().toString()).orElse("ya registrado");
			      throw new ConflictException("El KIT ya fue entregado a este congresista (" + cuando + ").");
			    }
			  }

			  private void validarCoffee(Long idUsuario, CoffeeBreakEnum refriSlot) {
			    if (refriSlot == null) {
			      throw new BadRequestException("refriSlot es obligatorio para COFFEE_BREAK_ENTREGADO (MATUTINO/VESPERTINO/NOCTURNO).");
			    }
			    var z = java.time.ZoneId.of("America/Asuncion");
			    var hoy = java.time.LocalDate.now(z);
			    var desde = hoy.atStartOfDay();
			    var hastaExcl = hoy.plusDays(1).atStartOfDay();

			    boolean existe = checkInRepository
			        .existsByUsuarioIdAndTipoAndRefriSlotAndFechaRegistroGreaterThanEqualAndFechaRegistroLessThan(
			            idUsuario, CheckinTipoEnum.COFFEE_BREAK_ENTREGADO, refriSlot, desde, hastaExcl);

			    if (existe) {
			      var previo = checkInRepository
			          .findFirstByUsuarioIdAndTipoAndRefriSlotAndFechaRegistroGreaterThanEqualAndFechaRegistroLessThanOrderByFechaRegistroDesc(
			              idUsuario, CheckinTipoEnum.COFFEE_BREAK_ENTREGADO, refriSlot, desde, hastaExcl);
			      String cuando = previo.map(p -> p.getFechaRegistro().toString()).orElse("hoy");
			      throw new ConflictException("Ya se entregó el Coffee Break (" + refriSlot + ") hoy a este congresista (" + cuando + ").");
			    }
			  }

		static byte[] uuidStringToBytes(String s) {
			  String hex = s.replace("-", "");
			  int n = hex.length();
			  byte[] out = new byte[n/2];
			  for (int i=0; i<n; i+=2) out[i/2] = (byte) Integer.parseInt(hex.substring(i, i+2), 16);
			  return out;
		}
		
		
		
		
}


