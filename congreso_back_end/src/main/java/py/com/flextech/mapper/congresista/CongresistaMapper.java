package py.com.flextech.mapper.congresista;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;

import py.com.flextech.model.pagos.dto.ResumenCobradoDto;
import py.com.flextech.model.sistema.Usuario;

public interface CongresistaMapper {
	
	Page<Usuario> consultaCongresistaPorNombreORegistroAcademico(String nombre, String registroAcademico);
	
	 Page<Usuario> consultaCongresistaConFiltros(
		      @Param("nombre") String nombre,
		      @Param("registroAcademico") String registroAcademico,
		      @Param("estado") String estado,              // "TODOS" | "PAGOS" | "EXONERADOS" | "PENDIENTES"
		      @Param("desde") LocalDateTime desde,         // nullable
		      @Param("hasta") LocalDateTime hasta,         // nullable
		      @Param("aplicaFechaPago") Boolean aplicaFechaPago // true si filtro de fecha debe aplicar sobre FC_PAGO
		  );

		  List<ResumenCobradoDto> resumenPorCobradorTurno(
		      @Param("desde") LocalDateTime desde,
		      @Param("hasta") LocalDateTime hasta
		  );
		  
		  
		  List<Usuario> consultaCongresistaPorCondicion(
			      @Param("condicion") String condicion
			  );
		  
		  List<Usuario> consultaCongresistaDisponiblesSorteo(String tipoSorteo);
}
