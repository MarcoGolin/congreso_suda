package py.com.flextech.config.i18n;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Locale;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;

@Configuration
public class InternationalizationConfig implements WebMvcConfigurer {

  /**
   * * @return default Locale set by the user
   */
  @Bean(name = "localeResolver")
   LocaleResolver localeResolver() {
	  final AcceptHeaderLocaleResolver resolver = new AcceptHeaderLocaleResolver();
	  resolver.setSupportedLocales(Arrays.asList(new Locale("en"), new Locale("es"), new Locale("pt")));
	  resolver.setDefaultLocale(new Locale("es"));
	  return resolver;
	  
  }

  


  @Bean
   MessageSource messageSource() { // Not sure if this is needed
    final ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
    messageSource.setDefaultEncoding(StandardCharsets.UTF_8.name());
    messageSource.setBasenames("classpath:/i18n/messages");
    messageSource.setUseCodeAsDefaultMessage(true);
    messageSource.setCacheSeconds(5);
    messageSource.setDefaultEncoding("UTF-8");
    return messageSource;
  }
  
  @Bean
   LocaleChangeInterceptor localeChangeInterceptor() {
      LocaleChangeInterceptor lci = new LocaleChangeInterceptor();
      lci.setParamName("lang");
      return lci;
  }
  
}