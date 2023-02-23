package com.marondal.marondalgram.common;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

public class FileManagerService {
	
	public static final String FILE_UPLOAD_PATH = "D:\\김인규 강사\\web\\20221011\\springProject\\marondalgram\\upload\\images";
	
	private static Logger logger = LoggerFactory.getLogger(FileManagerService.class);
	
	public static String saveFile(int userId, MultipartFile file) {
		// 파일 저장
		
		// 사용자 별로 폴더를 구분한다. 
		// 사용자 별로 폴더를 새로 만든다
		// 폴더이름 : userId_현재시간
		// UNIX TIME : 1970년 1월 1일 부터 흐른 시간 (millisecond 1/1000)
		
		String directoryName = "/" + userId + "_" + System.currentTimeMillis() + "/";
		
		// 디렉토리 생성
		String directoryPath = FILE_UPLOAD_PATH + directoryName;
		File directory = new File(directoryPath);
		if(directory.mkdir() == false) {
			// 디렉토리 생성 실패 
			// 디렉토리 생성 실패 로그 추가 
			logger.error("savefile : 디렉토리 생성 실패 "  + directoryPath);
			return null;
		}
		
		// 파일 저장
		String filePath = null;
		try {
			byte[] bytes = file.getBytes();
			
			filePath = directoryPath + file.getOriginalFilename();
			Path path = Paths.get(filePath);
			Files.write(path, bytes);
			
		} catch (IOException e) {
			
			e.printStackTrace();
			
			logger.error("saveFile : 파일 생성 에러 - " + filePath);
			
			return null;
		}
		
		// 클라이언트에 접근 가능한 경로를 문자열로 리턴
		
		
		// http://localhost:8090/images/~
		// /images/2_38239823/test.png
		
		return "/images" + directoryName + file.getOriginalFilename();
	}
	
	// 파일 삭제 메소드
	public static boolean removeFile(String filePath) {  // /images/2_1676377118515/animal-gb14808a98_640.jpg
		// 삭제 경로 /images 를 제거하고
		// 실제 파일 저장 경로에 이어 붙여 준다. 
		// D:\\김인규 강사\\web\\20221011\\springProject\\upload\\images/2_1676377118515/animal-gb14808a98_640.jpg
		
		String realFilePath = FILE_UPLOAD_PATH + filePath.replace("/images", "");
		Path path = Paths.get(realFilePath);
		
		// 파일이 존재하는지 
		if(Files.exists(path)) {
			try {
				Files.delete(path);
			} catch (IOException e) {
				
				e.printStackTrace();
				
				return false;
			}
		}
		
		// D:\\김인규 강사\\web\\20221011\\springProject\\upload\\images/2_1676377118515
		// 디렉토리 경로
		Path dirPath = path.getParent();
		// 디렉토리존재 하는지
		if(Files.exists(dirPath)) {
			try {
				Files.delete(dirPath);
			} catch (IOException e) {
				
				e.printStackTrace();
				
				return false;
			}
		}
		
		
		return true;
		
	}
}
