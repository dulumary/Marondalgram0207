<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Marondalgram</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

<link rel="stylesheet" href="/static/css/style.css" type="text/css">
</head>
<body>

	<div class="container">
		<section class="content d-flex justify-content-center my-5">
			<div>
				<div class="login-box d-flex justify-content-center align-items-start bg-white  border rounded">
					<div class="w-100 p-5">
						<h2 class="text-center">Marondalgram</h2>
						<br>
						<div class="text-center">
							<b class="text-secondary">친구들의 사진과 동영상을 보려면<br> 가입하세요.</b>
						</div>
						
						<div class="d-flex  mt-3">
							<input type="text" id="loginIdInput" class="form-control" placeholder="아이디">
							<button type="button" class="btn btn-info btn-sm ml-2" id="isDuplicateBtn">중복확인</button>
						</div>
						
						<div class="small text-success d-none" id="availableText">사용가능한 아이디 입니다</div>
						<div class="small text-danger d-none" id="duplicateText">중복된 아이디 입니다</div>
					
						<input type="password" id="passwordInput" class="form-control mt-3" placeholder="패스워드">
						<input type="password" id="passwordConfirmInput" class="form-control mt-3" placeholder="패스워드 확인">
						
						<input type="text" id="nameInput" class="form-control mt-3" placeholder="이름">
						<input type="text" id="emailInput" class="form-control mt-3" placeholder="이메일">
						
						<button type="button" id="signUpBtn" class="btn btn-info btn-block mt-3">회원가입</button>
				
					</div>
					
				</div>
				<div class="mt-4 p-3 d-flex justify-content-center align-items-start bg-white  border rounded">
					계정이 있으신가요? <a href="/user/signin/view">로그인</a>
				</div>
			</div>
		</section>
		<c:import url="/WEB-INF/jsp/include/footer.jsp" />
	
	</div>
	<script>
		$(document).ready(function() {
			
			var isDuplicateCheck = false;
			var isDuplicateId = true;
			
			
			
			$("#isDuplicateBtn").on("click", function() {
				let id = $("#loginIdInput").val();
				
				if(id == "") {
					alert("아이디를 입력하세요");
					return;
				}
				
				$.ajax({
					type:"get"
					, url:"/user/duplicate_id"
					, data:{"loginId":id}
					, success:function(data) {
						isDuplicateCheck = true;
						
						if(data.is_duplicate) {  // 중복된 상태
							
							isDuplicateId = true;
							$("#duplicateText").removeClass("d-none");
							$("#availableText").addClass("d-none");
						} else { // 중복 안된 상태
							
							isDuplicateId = false;
							$("#availableText").removeClass("d-none");
							$("#duplicateText").addClass("d-none");
						}
						
					}
					, error:function() {
						alert("중복확인 에러");
					}
				});
				
			});
			
			
			$("#signUpBtn").on("click", function() {
				let id = $("#loginIdInput").val();
				let password = $("#passwordInput").val();
				let passwordConfirm = $("#passwordConfirmInput").val();
				let name = $("#nameInput").val();
				let email = $("#emailInput").val();
				
				if(id == "") {
					alert("아이디를 입력하세요");
					return;
				}
				
				// 중복체크 여부 유효성 검사 
				//if(isDuplicateCheck == false) {
				if(!isDuplicateCheck) {
					alert("아이디 중복확인을 해주세요");
					return ;
				}
				
				// 아이디 중복여부 유효성 검사 
				// 중복된 상태인 경우 얼럿창 노출
				if(isDuplicateId) {
					alert("중복된 아이디 입니다");
					return ;
				}
				
				if(password == "") {
					alert("비밀번호를 입력하세요");
					retrun;
				}
				
				if(password != passwordConfirm) {
					alert("비밀번호 일치여부를 확인하세요");
					return ;
				}
				
				if(name == "") {
					alert("이름을 입력하세요");
					return ;
				}
				
				if(email == "") {
					alert("이메일을 입력하세요");
					return ;
				}
				
				
				$.ajax({
					type:"post"
					, url:"/user/signup"
					, data:{"loginId":id, "password":password, "name":name, "email":email}
					, success:function(data) {
						if(data.result == "success") {
							location.href = "/user/signin/view";
						} else {
							alert("회원가입 실패");
						}
					}
					, error:function() {
						alert("회원가입 에러");
					}
				});
				
				
			});
		
			
		});
	
	</script>
	
	

</body>
</html>