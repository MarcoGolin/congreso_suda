package py.com.flextech.mapper.sistema;

import py.com.flextech.model.sistema.Parametro;

public interface ParametroMapper {
	
	Parametro findParametroByEmpresa(long tenant);
}
