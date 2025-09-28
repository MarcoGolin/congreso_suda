package py.com.flextech.config.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
public class CorsConfig {

  @Bean
  public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration cfg = new CorsConfiguration();

    cfg.setAllowedOriginPatterns(List.of(
    		  "https://www.congresounisud.com",
    		  "https://congresounisud.com",
    		  "https://*.congresounisud.com",
    		  "http://localhost:*", "http://127.0.0.1:*", "http://[::1]:*",
    		  // si abrís desde IG/FB:
    		  "https://l.instagram.com", "https://*.instagram.com",
    		  "https://l.facebook.com", "https://lm.facebook.com", "https://*.facebook.com",
    		  "null" // algunos webviews
    		));
    		cfg.setAllowedMethods(List.of("GET","POST","PUT","DELETE","OPTIONS","PATCH"));
    		cfg.setAllowedHeaders(List.of("Authorization","Content-Type","X-Requested-With","*"));
    		cfg.setExposedHeaders(List.of("Content-Disposition"));
    		cfg.setAllowCredentials(true);
    cfg.setMaxAge(3600L); // cache preflight 1h

    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", cfg);
    return source;
  }
}
