package com.marondal.marondalgram.user;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.marondal.marondalgram.user.bo.UserBO;
import com.marondal.marondalgram.user.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/user")
public class UserRestController {
	
	@Autowired
	private UserBO userBO;
	
	@PostMapping("/signup")
	public Map<String, String> signup(
			@RequestParam("loginId") String loginId
			, @RequestParam("password") String password
			, @RequestParam("name") String name
			, @RequestParam("email") String email) {
		
		Map<String, String> result = new HashMap<>();
		int count = userBO.addUser(loginId, password, name, email);
		
		if(count == 1) {
			result.put("result", "success");
		} else {
			result.put("result", "fail");
		}
		
		return result;
		
	}
	
	@GetMapping("/duplicate_id")
	public Map<String, Boolean> duplicateId(@RequestParam("loginId") String loginId) {
		
		boolean isDuplicate = userBO.duplicateId(loginId);
		
		Map<String, Boolean> result = new HashMap<>();
		
//		if(isDuplicate) {
//			result.put("is_duplicate", true);
//		} else {
//			result.put("is_duplicate", false);
//		}
		
		result.put("is_duplicate", isDuplicate);
		
		return result;
	}
	
	
	@PostMapping("/signin")
	public Map<String, String> signin(
			@RequestParam("loginId") String loginId
			, @RequestParam("password") String password
			, HttpServletRequest request) {
		
		User user = userBO.getUser(loginId, password);
		Map<String, String> result = new HashMap<>();
		// 조회 성공시 - 일치하는 id password가 존재한다. 
		if(user != null) {
			
			HttpSession session = request.getSession();
			session.setAttribute("userId", user.getId());
			session.setAttribute("userName", user.getName());
			
			result.put("result", "success");
		} else { // 조회 실패시 - 로그인 실패
			result.put("result", "fail");
		}
		
		return result;
	}
	
	
	
	

}
