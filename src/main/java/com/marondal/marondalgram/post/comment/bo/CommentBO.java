package com.marondal.marondalgram.post.comment.bo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.marondal.marondalgram.post.comment.dao.CommentDAO;
import com.marondal.marondalgram.post.comment.model.Comment;
import com.marondal.marondalgram.post.comment.model.CommentDetail;
import com.marondal.marondalgram.user.bo.UserBO;
import com.marondal.marondalgram.user.model.User;

@Service
public class CommentBO {
	
	@Autowired
	private CommentDAO commentDAO;
	
	@Autowired
	private UserBO userBO;
	
	public int addComment(int userId, int postId, String content) {
		return commentDAO.insertComment(userId, postId, content);
	}
	
	// 특정 post의 댓글 목록을 조회하는 기능
	public List<CommentDetail> getCommentList(int postId) {
		
		// 댓글 조회 결과를 기반으로 댓글 마다 작성자 정보를 조회한다.
		List<Comment> commentList = commentDAO.selectCommentList(postId);
		
		List<CommentDetail> commentDetailList = new ArrayList<>();
		
		for(Comment comment:commentList) {
			CommentDetail commentDetail = new CommentDetail();
			
			User user = userBO.getUserById(comment.getUserId());
			
			commentDetail.setId(comment.getId());
			commentDetail.setPostId(comment.getPostId());
			commentDetail.setUserId(comment.getUserId());
			commentDetail.setContent(comment.getContent());
			commentDetail.setUserName(user.getName());
			
			commentDetailList.add(commentDetail);
			
		}
		
		return commentDetailList;
	}
	
	// postId 를 기반으로 댓글 삭제 기능
	public int deleteCommentByPostId(int postId) {
		
		return commentDAO.deleteCommentByPostId(postId);
		
	}
	

}
