package py.com.flextech.model.checkin;

import java.time.LocalDateTime;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import py.com.flextech.model.checkin.enums.CheckinTipoEnum;
import py.com.flextech.model.checkin.enums.CoffeeBreakEnum;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.model.sistema.serializer.UsuarioSerializer;
import py.com.flextech.model.taller.Taller;
import py.com.flextech.model.taller.serializer.TallerSerializer;

@Entity
@Table(name = "ev_checkin")
@Setter
@Getter
public class Checkin {
	
	 @Id
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  @Column(name = "ID_CHECKIN")
	  private Long id;

	  @NotNull
	  @Column(name = "FC_REGISTRO", nullable = false)
	  private LocalDateTime fechaRegistro;


	  @JsonSerialize(using = UsuarioSerializer.class)
	  @NotNull
	  @ManyToOne
	  @JoinColumn(name = "ID_USUARIO", referencedColumnName = "ID_USUARIO")
	  private Usuario usuario; // más simple que mapear la entidad completa

	  @NotNull
	  @Enumerated(EnumType.STRING)
	  @Column(name = "TIPO", nullable = false, length = 40)
	  private CheckinTipoEnum tipo;

	  @JsonSerialize(using = TallerSerializer.class)
	  @ManyToOne
	  @JoinColumn(name = "ID_TALLER", referencedColumnName = "ID_TALLER")
	  private Taller taller;

	  @Enumerated(EnumType.STRING)
	  @Column(name = "REFRI_SLOT", nullable = true, length = 40)
	  private CoffeeBreakEnum refriSlot;


	  @JsonSerialize(using = UsuarioSerializer.class)
	  @NotNull
	  @ManyToOne
	  @JoinColumn(name = "ID_USUARIO_OPERADOR", referencedColumnName = "ID_USUARIO")
	  private Usuario usuarioOperador;

}
