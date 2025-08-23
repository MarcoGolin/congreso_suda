package py.com.flextech.mapper.congresista;

import com.github.pagehelper.Page;

import py.com.flextech.model.sistema.Usuario;

public interface CongresistaMapper {
	
	Page<Usuario> consultaCongresistaPorNombreORegistroAcademico(String nombre, String registroAcademico);
	
}
