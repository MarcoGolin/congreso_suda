package py.com.flextech.model.trabajocientifico;


import java.time.Instant;
import java.util.List;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.serializer.UsuarioSerializer;

@Entity
@Table(name = "TC_TRABAJO_CIENTIFICO")
@Setter
@Getter
public class TrabajoCientifico {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_TRABAJO_CIENTIFICO")
	private Long id;

	@NotNull
	@Column(name = "FC_REGISTRO")
	private Instant fechaRegistro;

	@NotNull
	@Column(name = "AUTOR_NOMBRE")
	private String autorNombre;

	@NotNull
	@Column(name = "AUTOR_EMAIL")
	private String autorEmail;

	@NotNull
	@Column(name = "AUTOR_TELEFONO")
	private String autorTelefono;

	@NotNull
	@Column(name = "AUTOR_FILIACION")
	private String autorFiliacion;
	
	@OneToMany(mappedBy = "trabajoCientifico", cascade = CascadeType.ALL)
	private List<Coautor> coautores;

	@NotNull
	@Column(name = "TITULO")
	private String titulo;

	@NotNull
	@Column(name = "MODALIDAD")
	private String modalidad;

	@NotNull
	@Column(name = "AREA_TEMATICA")
	private String areaTematica;

	@NotNull
	@Column(name = "AREA_DE_LA_MEDICINA")
	private String areaDeLaMedicina;
	
	@Column(name = "RESUMEN")
	private String resumen;
	
	@NotNull
	@Column(name = "ARCHIVO_WORD_URI")
	private String archivoWordUrl;

	@Column(name = "ARCHIVO_PDF_URI")
	private String archivoPdfUrl;

	@Column(name = "ACEPTO_DECLARACION")
	private Boolean aceptaDeclaracion;
	
	@JsonSerialize(using = UsuarioSerializer.class)
	@NotNull
	@ManyToOne
	@JoinColumn(name = "ID_USUARIO", referencedColumnName = "ID_USUARIO")
	private Usuario usuario;
	
}
