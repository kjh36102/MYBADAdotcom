<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">

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
	String hashcode = (String)session.getAttribute("hashcode");

%>
	<nav class="navbar navbar-expand navbar-light" id="header">
		<a class="navbar-brand header-btn" href="feed.jsp" id="logo">MYBADA.COM</a>
		<div class="collapse navbar-collapse justify-content-end"
			id="navbarNav">
			<ul class="navbar-nav">

				<%
				if (hashcode == null){
				%>
					<li class="nav-item me-2"><a class="nav-link header-btn"
					href="register.jsp">회원가입</a></li>
					<li class="nav-item me-2"><a class="nav-link header-btn"
					href="login.jsp">로그인</a></li>
					
				<%
				}
				else{
				%>
				
					<li class="nav-item me-2"><a class="nav-link header-btn"
					href="mypage.jsp">마이페이지</a></li>
					<li class="nav-item me-2"><a class="nav-link header-btn"
					href="logout.jsp" id="logout-btn" onclick="logout()">로그아웃</a></li>
				
				<%
				}
				%>
			</ul>
		</div>
	</nav>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="./static/js/global.js"></script>
	<script type="text/javascript">
		var colorGreen = "rgb(147, 235, 117, 0.7)";
		var colorRed = "rgb(235, 164, 117, 0.7)";
		
		//로그아웃
		function logout(){
			var formData = new FormData();
			formData.append("action", "signout");
			formData.append("hashcode", "<%=session.getAttribute("hashcode")%>")
			
			ajaxPost(formData, "SignServlet", 
					(status, res) => {	//success
						//pass
					},
					(status, res) => { //fail
						console.log("로그아웃 중 오류 발생!");
					}
				);
		}
			
	</script>
</body>
</html>