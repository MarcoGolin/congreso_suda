package py.com.flextech.config.database;


import javax.sql.DataSource;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataBaseConfig {

    @Bean
    DataSource getDataSource() {
		DataSourceBuilder<?> dataSourceBuilder = DataSourceBuilder.create();
		//dataSourceBuilder.driverClassName("com.mysql.jdbc.Driver");
		dataSourceBuilder.url("jdbc:mysql://localhost:3306/saas_congreso?useSSL=false&useUnicode=true&serverTimezone=UTC");
		dataSourceBuilder.username("root");
		dataSourceBuilder.password("84125497");
		return dataSourceBuilder.build();
	}
}
