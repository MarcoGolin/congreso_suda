package py.com.flextech.mapper.taller;

import com.github.pagehelper.Page;

import py.com.flextech.model.taller.TallerInscripto;

public interface TallerInscriptoMapper {
	
	Page<TallerInscripto> consultaParticipantesDelTaller(Long idTaller);
	
}
