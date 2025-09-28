package py.com.flextech.model.taller;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.serializer.UsuarioSerializer;
import py.com.flextech.model.taller.serializer.TallerSerializer;


@Entity
@Table(name = "TR_TALLER_INSCRIPTO")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class TallerInscripto {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_TALLER_INSCR")
	private Long id;
	
	@NotNull
	@Column(name = "FECHA")
	private LocalDateTime fecha;
	
	@NotNull
	@ManyToOne
	@JoinColumn(name = "ID_TALLER", referencedColumnName = "ID_TALLER")
	private Taller taller;

	@JsonSerialize(using = UsuarioSerializer.class)
	@NotNull
	@ManyToOne
	@JoinColumn(name = "ID_USUARIO", referencedColumnName = "ID_USUARIO")
	private Usuario usuario;
	
	@Column(name = "FC_PAGO")
	private LocalDateTime fechaPago;

	@Column(name = "VL_PAGO")
	private BigDecimal vlPago;

	@Column(name = "NR_COMPROBANTE")
	private String nrComprobante;

	@Column(name = "USUARIO_PAGO")
	private String usuarioPago;

	@NotNull
	@Column(name = "BO_EXONERADO")
	private Boolean isExonerado;

}
