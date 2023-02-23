<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>타임라인</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">

<link rel="stylesheet" href="/static/css/style.css" type="text/css">
<body>

	<div class="container">
		<c:import url="/WEB-INF/jsp/include/header.jsp" />
		<section class="d-flex justify-content-center">
			<!-- 타임라인 -->
			<div class="timeline-box">
				<!-- 입력 박스 -->
				<div class="input-box border rounded">
					<textarea class="form-control border-0" rows="5" id="contentInput"></textarea>
					
					<div class="d-flex justify-content-between">
						<input type="file" id="fileInput" class="d-none" id="fileInput">
						<div class="upload-icon text-info ml-2" id="imageUploadBtn"><i class="bi bi-card-image"></i> </div>
						<button type="button" class="btn btn-info" id="uploadBtn">업로드</button>
					</div>
				</div>
				<!-- /입력 박스 -->
				
				<!-- 카드 들 -->
				<div class="card-list">
					<c:forEach var="post" items="${postList }" >
					<!-- 카드 -->
					<div class="card mt-4">
						<div class="d-flex justify-content-between p-2">
							<div>${post.userName }</div>
							
							<%-- 로그인한 userId와 해당 게시글의 작성자 userId 가 일치하는 경우만 more-btn을 보여줘라 --%>
							<c:if test="${userId eq post.userId }">
								<!--   -->
								<div class="more-btn" data-toggle="modal" data-target="#moreMenuModal" data-post-id="${post.id }"><i class="bi bi-three-dots"></i></div>
							</c:if>
						</div>
						<div>
							<img width="100%" src="${post.imagePath }">
						</div>
						
						<div class="p-2">
							<c:choose>
								<c:when test="${post.like }">
									<i class="bi bi-heart-fill text-danger heart-fill-btn" data-post-id="${post.id }"></i>
								</c:when>
								<c:otherwise>
									<i class="bi bi-heart heart-btn" data-post-id="${post.id }"></i>
								</c:otherwise>

							</c:choose>
							 좋아요 ${post.likeCount }개
						</div>
						
						<div class="p-2">
							<b>${post.userName }</b> ${post.content }
						</div>
						
						<!--  댓글 들 -->
						<div class="commnet-box p-2">
							<div>댓글</div>
							<hr>
							
							<c:forEach var="comment" items="${post.commentList }" >
							<div><b>${comment.userName }</b> ${comment.content }</div>
							</c:forEach>
							
							<div class="d-flex">
								<input type="text" class="form-control" id="commentInput${post.id }">
								<button type="button" class="btn btn-primary comment-btn" data-post-id="${post.id }">게시</button>
							</div>
						</div>
						
						<!--  /댓글 들 -->
						
					
					</div>
					<!-- /카드 -->
					
					</c:forEach>
					
					
				
				</div>
				<!-- /카드 들 -->
				
				
			</div>
			<!-- /타임라인 -->
		</section>
		<c:import url="/WEB-INF/jsp/include/footer.jsp" />
		

	
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="moreMenuModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered" role="document">
	    <div class="modal-content">
	     
	      <div class="modal-body text-center">
	        	<a href="#" id="deleteBtn">삭제하기</a>
	      </div>
	      
	    </div>
	  </div>
	</div>
	
	<script>
		$(document).ready(function() {
			
			$(".more-btn").on("click", function() {
				// 해당 more-btn 태그에있는 post-id를 모달의 a태그에 넣는다. 
				let postId = $(this).data("post-id");
				
				
				// data-post-id=""
				$("#deleteBtn").data("post-id", postId);
				
				
			});
			
			$("#deleteBtn").on("click", function() {
				let postId = $(this).data("post-id");
				
				$.ajax({
					type:"get"
					, url:"/post/delete"
					, data:{"postId":postId}
					, success:function(data) {
						if(data.result == "success") {
							location.reload();
						} else {
							alert("삭제 실패");
						}
						
					}
					, error :function() {
						alert("삭제 에러");
					}
				});
			});
			
			$(".heart-fill-btn").on("click", function() {
				let postId = $(this).data("post-id");
				
				$.ajax({
					type:"get"
					, url:"/post/unlike"
					, data:{"postId":postId}
					, success:function(data) {
						if(data.result == "success") {
							location.reload();
						} else {
							
							alert("좋아요 취소 실패");
						}
						
					}
					, error:function() {
						alert("좋아요 취소 에러");
					}
				});
				
			});
			
			
			$(".comment-btn").on("click", function() {
				
				// post id, 작성한 댓글내용. 
				let postId = $(this).data("post-id");
				
				// 버튼의 이전 태그를 객체화 
				//let comment = $(this).prev().val();
				//alert(comment);
				
				// id 셀렉터를 문자열 연산으로 완성
				let comment = $("#commentInput" + postId).val();
				
				$.ajax({
					type:"post"
					, url:"/post/comment/create"
					, data:{"postId":postId, "content":comment}
					, success:function(data) {
						if(data.result == "success") {
							location.reload();
						} else {
							
							alert("댓글 작성 실패");
						}
					}
					, error:function() {
						alert("댓글 작성 에러");
					}
				});
				
				
			});
			
			
			$(".heart-btn").on("click", function() {
				
				// 해당하는 버튼에 대응되는 post id 를 얻어와야한다. 
				let id = $(this).data("post-id");
				
				$.ajax({
					type:"get"
					, url:"/post/like"
					, data:{"postId":id}
					, success:function(data) {
						if(data.result == "success") {
							location.reload();
						} else {
							alert("좋아요 실패");
						}
					}
					, error:function() {
						alert("좋아요 에러");
					}
				});
				
			});
			
			$("#uploadBtn").on("click", function() {
				
				let content = $("#contentInput").val();
				if(content == "") {
					
					alert("내용을 입력하세요");
					return;
				}
				
				// 파일이 선택되지 않았을때
				if($("#fileInput")[0].files.length == 0) {
					alert("파일을 선택해주세요");
					return;
				}
				
				var formData = new FormData();
				formData.append("content", content);
				formData.append("file", $("#fileInput")[0].files[0]);
				
				$.ajax({
					type:"post"
					, url:"/post/create"
					, data:formData
					, enctype:"multipart/form-data"
					, processData:false
					, contentType:false
					, success:function(data) {
						if(data.result = "success") {
							location.reload();
						} else {
							alert("업로드 실패");
						}
						
					}
					, error:function() {
						alert("업로드 에러");
					}
				});
				
				
				
			});
			
			
			
			$("#imageUploadBtn").on("click", function() {
				// 파일 인풋을 클릭한 효과
				$("#fileInput").click();
			});
			
		})
	
	
	</script>

</body>
</html>