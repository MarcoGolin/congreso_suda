package py.com.flextech.utils.file.servlet;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ResourceUtils;

import com.opencsv.CSVWriter;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.export.SimpleExporterInput;
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput;
import net.sf.jasperreports.export.SimpleXlsExporterConfiguration;
import net.sf.jasperreports.export.SimpleXlsReportConfiguration;
import py.com.flextech.mapper.sistema.ParametroMapper;
import py.com.flextech.model.sistema.Parametro;
import py.com.flextech.model.sistema.Usuario;
import py.com.flextech.repository.sistema.UsuarioRepository;

@Service
@Transactional(rollbackFor = Exception.class)
public class CreaRelatorio {
	

	@Autowired
	private UsuarioRepository uRepository;

	@Autowired
	private ParametroMapper pMapper;
	
	@Value("${image.directory}")
	private String fileDirectory;
	
	public  ResponseEntity<?> geraRelatorio(Long tenant, 
			Long idUsuario, 
			String timeOffSet, 
			String filtro, 
			String nomeRelatorio, 
			List<?> list,
			Boolean isXML) {
	
		Usuario usuario = uRepository.findById(idUsuario).get();
		Parametro parametro = pMapper.findParametroByEmpresa(tenant);
		String path = "classpath:reports/";
		
		if(filtro == null || filtro.isEmpty()) {
			filtro = "SIN FILTROS";
		}
		
		try {
			File file = ResourceUtils.getFile(path+nomeRelatorio+".jrxml");
			InputStream input = new FileInputStream(file);
			JasperReport jasperReport = JasperCompileManager.compileReport(input);
			JRBeanCollectionDataSource source = new JRBeanCollectionDataSource(list);
			Map<String, Object> parameters = new HashMap<>();
			// parameters.put("LOGO", (empresa.getFoto().replace("data:image/jpeg;base64,",
			// "").getBytes("UTF-8")));
			parameters.put("USUARIO", usuario);
			parameters.put("PARAMETRO", parametro);
			parameters.put("TIME_OFF_SET", timeOffSet);
			parameters.put("SUB_REPORT_DIR", path);
			parameters.put("FILTRO", filtro);
			parameters.put("IMAGE_DIRECTORY", fileDirectory);
			
			
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, source);
			
			if(isXML) {
				JRXlsExporter exporterXLS = new JRXlsExporter();
				byte[] rawBytes;

				ByteArrayOutputStream xlsReport = new ByteArrayOutputStream();
				exporterXLS.setExporterInput(new SimpleExporterInput(jasperPrint));
				exporterXLS.setExporterOutput(new SimpleOutputStreamExporterOutput(xlsReport));

				SimpleXlsReportConfiguration xlsReportConfiguration = new SimpleXlsReportConfiguration();
				SimpleXlsExporterConfiguration xlsExporterConfiguration = new SimpleXlsExporterConfiguration();

				xlsReportConfiguration.setOnePagePerSheet(true);
				xlsReportConfiguration.setRemoveEmptySpaceBetweenRows(true);
				xlsReportConfiguration.setDetectCellType(true);
				xlsReportConfiguration.setWhitePageBackground(false);
				exporterXLS.setConfiguration(xlsExporterConfiguration);
				exporterXLS.exportReport();
				rawBytes = xlsReport.toByteArray();

				if (rawBytes == null) {
					return ResponseEntity.ok(null);
				}
				String s = Base64.getEncoder().encodeToString(rawBytes);
				return ResponseEntity.ok().header("Content-Type", "application/xls; charset=UTF-8")
						.header("Content-Disposition", "inline; filename=\"" + nomeRelatorio + "-"
								+ LocalDate.now() + ".xls\"")
						.body(s);
				
			}else {
				// Export the report to a PDF file
				byte[] data = JasperExportManager.exportReportToPdf(jasperPrint);
				if (data == null) {
					return ResponseEntity.ok(null);
				}
				String strg = Base64.getEncoder().encodeToString(data);
				return ResponseEntity.ok()
						// Specify content type as PDF
						.header("Content-Type", "application/pdf; charset=UTF-8")
						// Tell browser to display PDF if it can
						.header("Content-Disposition", "inline; filename=\"" + tenant.toString() + ".pdf\"").body(strg);
			}
			
			
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			return ResponseEntity.ok("ERROR AL GENERAR EL REPORTE");
		}
	}

	
	  public  byte[] crearArchivoCSV(List<String[]> csvDataList) throws IOException {
	        // Crear el archivo CSV en memoria
	        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
	        OutputStreamWriter writer = new OutputStreamWriter(outputStream, StandardCharsets.UTF_8);
	        CSVWriter csvWriter = new CSVWriter(writer, ';',
	                CSVWriter.DEFAULT_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER,
	                CSVWriter.DEFAULT_LINE_END);
	        csvWriter.writeAll(csvDataList);
	        csvWriter.close();

	        // Obtener los bytes del archivo CSV
	        byte[] csvBytes = outputStream.toByteArray();
	        
	        

	        return csvBytes;
	    }


}
