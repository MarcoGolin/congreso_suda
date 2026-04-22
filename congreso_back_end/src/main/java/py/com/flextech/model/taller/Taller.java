package py.com.flextech.model.taller;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.serializer.UsuarioSerializer;


@Entity
@Table(name = "TR_TALLER")
@Data
@EqualsAndHashCode(callSuper = false)
@NoArgsConstructor
@AllArgsConstructor
@Builder
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

	@Column(name = "COSTO")
	private BigDecimal costo;
	
	@Column(name = "FLAYER")
	private String flayer;

	@NotNull
	@Column(name = "BO_ACTIVO")
	private Boolean isActivo;
	
	@Column(name = "CONTACTO")
	private String contacto;

	@JsonSerialize(using = UsuarioSerializer.class)
	@ManyToOne
	@JoinColumn(name = "ID_RESPONSABLE", referencedColumnName = "ID_USUARIO")
	private Usuario responsable;
	
	@JsonIgnore
	public Taller(Long id) {
		this.id = id;
	}


}
