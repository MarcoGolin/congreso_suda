package py.com.flextech.controller.base;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import py.com.flextech.utils.file.FileUtils;


@RestController
@CrossOrigin
@RequestMapping({ "/api/apk" })
@AllArgsConstructor
public class ImageController {
	
	private final FileUtils fileUtils;
	
    
    @GetMapping("/download")
    public ResponseEntity<?> downloadApk(@RequestParam String fileName) {
    	if(fileName.isEmpty()) {
    		return  ResponseEntity.ok("SIN APK");
    	}
    	Resource resource = fileUtils.loadToDiskPrinterServer(fileName);
//    	String mediaType = fileUtils.getMediaType(resource);
    	String mediaType = "application/vnd.android.package-archive";
    	return ResponseEntity.ok()
				.header("Content-Type", mediaType)
				.header("Content-Disposition", "inline; filename=\"" + fileName + "\"").body(resource);
    }

}
