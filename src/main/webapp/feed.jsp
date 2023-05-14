<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
#feed-list-header {
	width: 45em;
}

#feed-add-btn {
	border: 4px solid rgb(190, 190, 190);
	border-radius: 0.5em;
	height: 3em;
	cursor: pointer;
}

.feed-card {
	border: 4px solid rgb(190, 190, 190);
	border-radius: 0.5em;
	width: 45em;
	min-height: 10em;
	margin: 0 auto;
}

.feed-card img {
	width: 4.5em;
	height: 4.5em;
	object-fit: cover;
	border-radius: 50%;
	border: 2px solid gray;
	margin-top: 1em;
	margin-left: 1em;
}

.feed-timestamp {
	float: right;
	margin-top: 0.25em;
	margin-right: 0.5em;
}
</style>
</head>
<body>
	<%
	if (session.getAttribute("hashcode") == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>

	<%@ include file="header.jsp"%>

	<div class="content">


		<div class="container" id="feed-list-header">
			<div class="row align-items-center g-0">
				<div class="col-6">
					<h1 style="font-size: 2.5em;">
						<b>Feeds</b>
					</h1>
				</div>
				<div class="col-6">
					<div id="feed-add-btn"
						class="d-flex align-items-center justify-content-center">
						<img src="./static/img/add.png" width=25 height=25>
					</div>
				</div>
			</div>
		</div>
		<hr class="mt-2" style="width: 45em; height: 1em; margin: 0 auto;">
		<div class="feed-card">
			<div class="feed-timestamp">2023-05-12 12:33</div>
			<div class="d-flex align-items-center" style="width: 18rem;">
				<img src="./static/img/unknown_user.png" class="mr-3"
					alt="Profile Picture">
				<div class="ms-2">
					<h5 class="mb-0">
						<strong><%=session.getAttribute("name")%></strong>
					</h5>
					<p class="mb-0"><%=session.getAttribute("email")%></p>
				</div>
			</div>
		</div>
	</div>
</body>
</html>