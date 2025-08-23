package py.com.flextech.model.sistema;


import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "SYS_PARAMETRO")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Parametro {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_PARAMETRO")
	private Long id;


	@NotNull
	@Column(name = "VL_INSRIPCION_ACTUAL")
	private BigDecimal vlInscripconActual;
		
	
	public Parametro(Long id) {
		this.id = id;
	}
	
}
