package py.com.flextech.model.pagos;

import java.time.Instant;
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


@Entity
@Table(name = "FIN_HABILITACION_PAGOS")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class HabilitacionPagos {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_HABILITACION")
	private Long id;
	
	@NotNull
	@Column(name = "FC_REGISTRO")
	private LocalDateTime fechaRegistro;
	
	@JsonSerialize(using = UsuarioSerializer.class)
	@NotNull
	@ManyToOne
	@JoinColumn(name = "ID_USUARIO", referencedColumnName = "ID_USUARIO")
	private Usuario usuario;
	
	@NotNull
	@Column(name = "INICIO")
	private LocalDateTime inicio;

	@NotNull
	@Column(name = "FIN")
	private LocalDateTime fin;

	@Column(name = "OBSERVACION")
	private String observacion;
	
	@JsonSerialize(using = UsuarioSerializer.class)
	@NotNull
	@ManyToOne
	@JoinColumn(name = "ID_USUARIO_REGISTRO", referencedColumnName = "ID_USUARIO")
	private Usuario usuarioRegistro;
	


}
