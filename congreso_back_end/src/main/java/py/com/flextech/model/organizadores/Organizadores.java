package py.com.flextech.model.organizadores;

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
@Table(name = "ORG_ORGANIZADORES")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class Organizadores {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_ORGANIZADOR")
	private Long id;
	

	@NotNull
	@Column(name = "FOTO")
	private String foto;
	
	@NotNull
	@Column(name = "NOMBRE")
	private String nombre;
	
	@NotNull
	@Column(name = "CARGO")
	private String cargo;
	
	@NotNull
	@Column(name = "BO_DESTACAR")
	private Boolean destacar;
	


}
