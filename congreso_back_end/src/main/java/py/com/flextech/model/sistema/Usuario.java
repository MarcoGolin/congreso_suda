package py.com.flextech.model.sistema;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "SYS_USUARIO")
@Data
@EqualsAndHashCode(callSuper = false)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Usuario  implements Serializable , UserDetails  {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4854234903205150197L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_USUARIO")
	private Long id;
	
	@NotNull
	@Column(name = "FC_REGISTRO")
	private Instant fechaRegistro;

	@NotNull
	@Column(name = "NOMBRE_COMPLETO")
	private String nombreCompleto;

	@NotNull
	@Column(name = "EMAIL", unique = true)
	private String email;

	@NotNull
	@Column(name = "SENHA")
	private String senha;

	@NotNull
	@Column(name = "TELEFONO")
	private String telefono;

	@NotNull
	@Column(name = "INSTITUCION")
	private String institucion;

	@NotNull
	@Column(name = "REGISTRO_ACADEMICO")
	private String registroAcademico;

	@NotNull
	@Column(name = "SEMESTRE")
	private String semestre;

	@NotNull
	@Column(name = "SECCION")
	private String seccion;

	@NotNull
	@Column(name = "PAIS")
	private String pais;
	
	//ACTIVACION
	@Column(name = "FC_ACTIVACION")
	private Instant fechaActivacion;

	@NotNull
	@Column(name = "BO_ACTIVADO")
	private Boolean isActivado;
	
	//PAGO
	@NotNull
	@Column(name = "BO_IS_PAGO")
	private Boolean isPago;

	@Column(name = "FC_PAGO")
	private Instant fechaPago;

	@Column(name = "VL_PAGO")
	private BigDecimal montoPago;

	@NotNull
	@Column(name = "UUID")
	private String uuid;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "ROL")
    private Rol rol;
	
	@JsonIgnore
	public Usuario(Long id) {
		this.id = id;
	}


	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
	    return List.of(new SimpleGrantedAuthority("ROLE_" + rol.name()));
	}

	@JsonIgnore
	@Override
	public String getPassword() {
		return senha;
	}

	@JsonIgnore
	@Override
	public String getUsername() {
		return email;
	}

	@JsonIgnore
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@JsonIgnore
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@JsonIgnore
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@JsonIgnore
	@Override
	public boolean isEnabled() {
		return true;
	}


}
