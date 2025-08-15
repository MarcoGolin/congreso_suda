package py.com.flextech.model.trabajocientifico;


import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "TC_COAUTOR")
@Setter
@Getter
public class Coautor {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_COAUTOR")
	private Long id;

	@NotNull
	@Column(name = "NOMBRE")
	private String nombre;

	@NotNull
	@Column(name = "EMAIL")
	private String email;

	@Column(name = "FILIACION")
	private String filiacion;

	@Column(name = "FILIACION_OTRO")
	private String filiacionOtro;
	
	@NotNull
	@ManyToOne
	@JsonIgnore
	@JoinColumn(name = "ID_TRABAJO_CIENTIFICO", referencedColumnName = "ID_TRABAJO_CIENTIFICO")
	private TrabajoCientifico trabajoCientifico;
}
