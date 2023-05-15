<%@page import="xyz.cofon.DB"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">

<script src="https://cdn.jsdelivr.net/npm/vue@2.6.0"></script>
<script src="https://unpkg.com/axios@1.4.0/dist/axios.min.js"></script>

<style type="text/css">
:root { 
	--header-height: 4.2em;
	--footer-height: 3.5em;
	--content-height: calc(100vh - var(--header-height) - var(--footer-height));
}

body {
	overflow: hidden;
}

#header {
	background: rgb(190, 190, 190);
	height: var(--header-height);
}

#logo {
	font-size: 1.7em;
	margin-left: 0.5em;
	padding: 0.25em 0.7em;
	width: auto;
}

.header-btn {
	background: rgb(64, 64, 64);
	border-radius: 0.5em;
	color: white;
	font-weight: bold;
	padding: 0.5em 0.5em;
	font-size: 1.1em;
	width: 6em;
	text-align: center;
}

.header-btn:hover {
	color: rgb(94, 172, 226);
}

.content {
	height: var(--content-height);
	padding: 1em 0;
	overflow-y: auto;
}
</style>
</head>
<body>

	<%
	//로그인 hashcode 쿠키검색
	String hashcode = (String) session.getAttribute("hashcode");
	%>
	<nav class="navbar navbar-expand navbar-light" id="header">
		<a class="navbar-brand header-btn" href="feed.jsp" id="logo">MYBADA.COM</a>

		<%
		if (hashcode != null) {
		%>

		<div class="d-flex align-items-center" style="width: 18rem;">
			<img src="./static/img/unknown_user.png" class="mr-3"
				style="width: 3.5em; height: 3.5em; object-fit: cover; border-radius: 50%; border: 2px solid gray;"
				alt="Profile Picture">
			<div class="ms-2">
				<h5 class="mb-0">
					<strong class="header-name"><%=session.getAttribute("name")%></strong>
				</h5>
				<p class="mb-0 header-email"><%=session.getAttribute("email")%></p>
			</div>
		</div>

		<%
		}
		%>


		<div class="collapse navbar-collapse justify-content-end"
			id="navbarNav">
			<ul class="navbar-nav">

				<%
				if (hashcode == null) {
				%>
				<li class="nav-item me-2"><a class="nav-link header-btn"
					href="register.jsp">회원가입</a></li>
				<li class="nav-item me-2"><a class="nav-link header-btn"
					href="login.jsp">로그인</a></li>

				<%
				} else {
				%>

				<li class="nav-item me-2"><a class="nav-link header-btn"
					href="mypage.jsp">마이페이지</a></li>
				<li class="nav-item me-2"><p class="nav-link header-btn mb-0"
						id="logout-btn" @click="logout" style="cursor: pointer;">로그아웃</p></li>

				<%
				}
				%>
			</ul>
		</div>
	</nav>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
	
	var colorGreen = 'rgb(147, 235, 117, 0.7)';
	var colorRed = 'rgb(235, 164, 117, 0.7)';
	
		//페이지 내 모든 input 태그를 초기화하는 함수
		function clearInputValues() {
			$('input').val('');
			$('input').css("background-color", "white");
		}
		
		//로그아웃
		new Vue({
			el: '#navbarNav',
			methods: {
				logout: function() {	//로그아웃 하는 함수
					let formdata = new URLSearchParams();
					formdata.append("action", "signout");
					
					axios.post("SignServlet", formdata, {
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
						}
					})
					.then(res => {
						if(res.data === "ok"){
							window.location.href = "logout.jsp";
						}
					})
					.catch(error => {
						alert("로그아웃 중 오류 발생!");
						console.log(error);
					})
				}
			}
		})
		
	</script>
</body>
</html>