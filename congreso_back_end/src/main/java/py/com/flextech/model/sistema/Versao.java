package py.com.flextech.model.sistema;
import java.io.Serializable;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Entity
@Table(name = "sys_versao")
@Data
public class Versao implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2940932221910937414L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ID_VERSAO")
	private Long id;

	@NotNull
	@Column(name = "DT_VERSAO")
	private LocalDateTime dtVersao;
	
	@NotNull
	@Column(name = "NR_VERSAO")
	private String nrVersao;
	
	@NotNull
	@Column(name = "NR_BUILD")
	private Long nrBuild;
	
	@NotNull
	@Column(name = "BO_FORCE_UPDATE")
	private Boolean forceUpdate;
	
	@JsonIgnore
	@NotNull
	@Column(name = "KEY_MASTER")
	private String keyMaster;

}
