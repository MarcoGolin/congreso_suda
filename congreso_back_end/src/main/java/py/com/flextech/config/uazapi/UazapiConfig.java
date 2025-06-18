package py.com.flextech.config.uazapi;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class UazapiConfig {
    @Bean
    WebClient webClient() {
//        return WebClient.builder()
//                .baseUrl("https://flextech.uazapi.dev") // Reemplaza con la URL base de la API
//                .defaultHeader("apiKey", "pkH5mjIQfEh2a9QGMxpT5w3J149v422joNsIG6csj4I5AEuZrd") // Puedes usar variables de configuración en lugar de valores fijos
//                .build();
    	  return WebClient.builder()
                  .baseUrl("https://flextech.uazapi.com") // Reemplaza con la URL base de la API
                  .defaultHeader("adminToken", "pkH5mjIQfEh2a9QGMxpT5w3J149v422joNsIG6csj4I5AEuZrd") // Puedes usar variables de configuración en lugar de valores fijos
                  .build();
    }
}
