package py.com.flextech.model.sistema;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import py.com.flextech.model.checkin.Checkin;

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
	private LocalDateTime fechaRegistro;

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
	private LocalDateTime fechaActivacion;

	@NotNull
	@Column(name = "BO_ACTIVADO")
	private Boolean isActivado;
	
	//PAGO
	@NotNull
	@Column(name = "BO_IS_PAGO")
	private Boolean isPago;

	@Column(name = "FC_PAGO")
	private LocalDateTime fechaPago;

	@Column(name = "NR_COMPROBANTE")
	private String nrComprobante;
	
	@Column(name = "USUARIO_PAGO")
	private String usuarioPago;

	@Column(name = "VL_PAGO")
	private BigDecimal montoPago;

	@Column(name = "BO_EXONERADO")
	private Boolean isExonerado;
	
	@Column(name = "OBS_ANULACION_PAGO")
	private String obsAnulacionPago;

	@NotNull
	@Column(name = "UUID")
	private String uuid;
	
	@Column(name = "UUID_BIN", insertable = false, updatable = false)
	private byte[] uuidBin;

	@Column(name = "BO_ADMIN")
	private Boolean isAdmin;

	@Column(name = "BO_FINANCIERO")
	private Boolean isFinanciero;
	
	@Column(name = "BO_STAFF")
	private Boolean isStaff;

	@Column(name = "BO_CONGRESISTA")
	private Boolean isCongresista;
	
	@Column(name = "BO_INVITADO")
	private Boolean isInvitado;

	@Column(name = "BO_DISERTANTE")
	private Boolean isDisertante;
	
	@Column(name = "BO_AUDIOVISUAL")
	private Boolean isAudioVisual;

	@Column(name = "BO_IS_CHECK_IN")
	private Boolean isCheckIn;
	
	@OneToMany(mappedBy = "usuario", cascade = CascadeType.ALL)
	private List<Checkin> checkin;

	
	@JsonIgnore
	public Usuario(Long id) {
		this.id = id;
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

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		// TODO Auto-generated method stub
		return null;
	}


}
