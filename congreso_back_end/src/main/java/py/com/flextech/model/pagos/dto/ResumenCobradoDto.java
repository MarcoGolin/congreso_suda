package py.com.flextech.model.pagos.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data @AllArgsConstructor @NoArgsConstructor
public class ResumenCobradoDto {
	 private String usuarioPagoId;
	  private String usuarioPagoNombre;
	  private Integer cantidad;
	  private BigDecimal montoTotal;
	}