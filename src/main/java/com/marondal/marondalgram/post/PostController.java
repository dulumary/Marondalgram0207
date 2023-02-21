package com.marondal.marondalgram.post;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.marondal.marondalgram.post.bo.PostBO;
import com.marondal.marondalgram.post.model.PostDetail;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/post")
public class PostController {
	
	@Autowired
	private PostBO postBO;
	
	@GetMapping("/timeline/view")
	public String timeline(Model model
			, HttpSession session) {
		
		int userId = (Integer)session.getAttribute("userId");
		
		List<PostDetail> postList = postBO.getPostList(userId);
		
		model.addAttribute("postList", postList);
		
		return "post/timeline";
	}

}
