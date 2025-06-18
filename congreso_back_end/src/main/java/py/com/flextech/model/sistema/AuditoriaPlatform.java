package py.com.flextech.model.sistema;

import java.time.LocalDateTime;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import py.com.flextech.model.sistema.serializer.UsuarioSerializer;

@Entity(name = "AUD_PLATAFORM")
@Getter
@Setter
public class AuditoriaPlatform {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_AUD_PLATFORM")
	private Long id;

	@Column(name = "DT_ULTIMO_LOGIN")
	private LocalDateTime dtUltimoLogin;

	@NotNull
	@ManyToOne
	@JsonSerialize(using = UsuarioSerializer.class)
	@JoinColumn(name = "ID_USUARIO", referencedColumnName = "ID_USUARIO")
	private Usuario usuario;
}
