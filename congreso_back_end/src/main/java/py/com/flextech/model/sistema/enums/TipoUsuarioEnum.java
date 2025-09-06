package py.com.flextech.model.sistema.enums;

public enum TipoUsuarioEnum {
	boAdmin("isAdmin"), 
	boFinanciero("isFinanciero"), 
	boStaff("isStaff"),
	boCongresista("isCongresista"),
	boInvitado("isInvitado"),
	boDisertante("isDisertante");
	
	
	private final String label;

	TipoUsuarioEnum(String valorOpcao) {
		label = valorOpcao;
	}

	public String getLabel() {
		return label;
	}


}
