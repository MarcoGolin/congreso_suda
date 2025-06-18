package py.com.flextech.config.security;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

	    @Override
	    public void addCorsMappings(CorsRegistry registry) {
	        registry.addMapping("/sorteo/api/**")
	                .allowedOrigins("sorteomillonario.com.py")
	                .allowedMethods("GET", "POST", "PUT", "DELETE");
	    }
}