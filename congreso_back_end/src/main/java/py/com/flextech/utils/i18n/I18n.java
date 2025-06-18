package py.com.flextech.utils.i18n;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;

@Component
@AllArgsConstructor
public class I18n {
	
	private MessageSource messageSource;
	
	public String getMessage(String key, @Nullable String[] args) {
		return  messageSource.getMessage(key, args,  LocaleContextHolder.getLocale());
	}
	
	
	public String getMessage(String key) {
		return  messageSource.getMessage(key, null,  LocaleContextHolder.getLocale());
	}

}
