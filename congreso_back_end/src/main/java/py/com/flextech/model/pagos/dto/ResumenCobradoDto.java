package py.com.flextech.model.pagos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data @AllArgsConstructor @NoArgsConstructor
public class ResumenCobradoDto {
	  private String usuarioPagoId;
	  private String usuarioPagoNombre;

	  // pagos
	  private Integer cantDiaPagos;
	  private Double  montoDiaPagos;
	  private Integer cantTardePagos;
	  private Double  montoTardePagos;
	  private Integer cantNochePagos;
	  private Double  montoNochePagos;

	  // exonerados
	  private Integer cantDiaEx;
	  private Integer cantTardeEx;
	  private Integer cantNocheEx;

	}