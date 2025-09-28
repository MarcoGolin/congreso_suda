package py.com.flextech.model.taller;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Table(name = "TR_TALLER")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class Taller {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_TALLER")
	private Long id;
	

	@NotNull
	@Column(name = "TITULO")
	private String titulo;
	
	@NotNull
	@Column(name = "DESCRIPCION")
	private String descripcion;
	
	@NotNull
	@Column(name = "ORGANIZADOR")
	private String organizador;
	
	@NotNull
	@Column(name = "FECHA_HORA")
	private LocalDateTime fechaHora;
	
	@NotNull
	@Column(name = "SALA")
	private String sala;

	@NotNull
	@Column(name = "COSTO")
	private BigDecimal costo;
	
	@NotNull
	@Column(name = "FLAYER")
	private String flayer;

	@NotNull
	@Column(name = "BO_ACTIVO")
	private Boolean isActivo;
	
	@NotNull
	@Column(name = "CONTACTO")
	private String contacto;

	@NotNull
	@Column(name = "RESPONSABLE")
	private String responsable;
	


}
