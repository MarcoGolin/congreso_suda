package py.com.flextech.utils.file;

import java.io.File;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import io.jsonwebtoken.io.IOException;

@Component
public class FileUtils {

	@Value("${image.directory}")
	private String fileDirectory;
	
	@Value("${apk.directory}")
	private String apkDirectory;

	public String saveInDisk(Long tenant, MultipartFile file) throws java.io.IOException {
		String finalPath = fileDirectory + "/" + tenant.toString() + "/";
		File diretory = new File(finalPath);
		String fileName = StringUtils.cleanPath(file.getOriginalFilename());

		String extension = Optional.ofNullable(fileName).filter(f -> f.contains("."))
				.map(f -> f.substring(fileName.lastIndexOf(".") + 1)).get();

		String nomeArquivo = new Date().getTime() + "." + extension;

		if (!diretory.exists()) {
			diretory.mkdirs();
		}

		Path path = Paths.get(finalPath + nomeArquivo);
		try {
			Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			e.printStackTrace();
		}

		return "/" + tenant.toString() + "/" + nomeArquivo;
	}

	public Resource loadToDisk(String fileName) {
		Path path = Paths.get(fileDirectory + fileName);
		Resource resource = null;
		try {
			resource = new UrlResource(path.toUri());
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
		return resource;
	}

	public String getMediaType(Resource resource) {
		String mediaType = null;
		try {
			mediaType = Files.probeContentType(Path.of(resource.getURI()));
		} catch (java.io.IOException e) {
			e.printStackTrace();
		}
		return mediaType;
		
	}

	public ResponseEntity<?> migraFotosProdutos() {

//		List<Produto> produtos = produtoRepository.findAll();
//
//		for (Produto produto : produtos) {
//			if (produto.getFotoSmall() != null) {
//
//				String tenant = produto.getEmpresa().getId().toString();
//
//				String finalPath = fileDirectory + "/" + tenant + "/";
//				File diretory = new File(finalPath);
//
//				String nomeArquivo = new Date().getTime() + "." + "jpg";
//
//				if (!diretory.exists()) {
//					diretory.mkdirs();
//				}
//
//				try (OutputStream stream = new FileOutputStream(finalPath + nomeArquivo)) {
//					stream.write(produto.getFotoSmall());
//					produtoMapper.setFotoPath("/" + tenant + "/" + nomeArquivo, produto.getId());
//
//				} catch (Exception e) {
//					System.out.println(e);
//					return ResponseEntity.ok("ERROR");
//				}
//			}
//		}

		return ResponseEntity.ok("EXITO");
	}
	
	
	public void removeToDisk(String fileName) {
		File file = new File(fileDirectory + fileName);
		file.delete();
	}

	public Resource loadToDiskPrinterServer(String fileName) {
		Path path = Paths.get(apkDirectory + fileName);
		Resource resource = null;
		try {
			resource = new UrlResource(path.toUri());
		} catch (MalformedURLException e) {
			e.printStackTrace();
			System.out.println("ARCHIVO NO ENCONTRADO " +fileName);
		}
		return resource;
	}

}
