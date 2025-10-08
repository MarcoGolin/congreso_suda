package py.com.flextech.model.sorteo;

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
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.serializer.UsuarioSerializer;


@Entity
@Table(name = "AUD_SORTEO")
@Data
@EqualsAndHashCode(callSuper = false)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sorteo {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_SORTEO")
	private Long id;
	
	
	@JsonSerialize(using = UsuarioSerializer.class)
	@NotNull
	@ManyToOne
	@JoinColumn(name = "ID_USUARIO", referencedColumnName = "ID_USUARIO")
	private Usuario usuario;
	

	@NotNull
	@Column(name = "FC_SORTEO")
	private LocalDateTime fcRegistro;
	
	@NotNull
	@Column(name = "AUSPICIANTE")
	private String auspiciante;

	public Sorteo(@NotNull Long idUsuario, @NotNull String auspiciante) {
		super();
		this.fcRegistro = LocalDateTime.now();
		this.usuario = new Usuario(idUsuario);
		this.auspiciante = auspiciante;
	}
	
	
	
}
