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
	margin-bottom: 2.5em;
}

.profile-img {
	width: 4.5em;
	height: 4.5em;
	object-fit: cover;
	border-radius: 50%;
	border: 2px solid gray;
	margin-top: 1em;
	margin-left: 1em;
}

.feed-controler-box {
	float: right;
	margin-top: 0.25em;
	margin-right: 0.5em;
}

.feed-profile-box {
	width: 25em;
}

.feed-controler-box img {
	width: 2.2em;
	height: 2.2em;
	cursor: pointer;
	margin-top: 0.6em;
}

.feed-timestamp {
	font-size: 1.15em;
	color: rgb(127, 127, 127);
}

.feed-content-box {
	margin: 0 2em;
	margin-top: 1em;
	width: 41em;
	height: auto;
	width: 41em;
}

.feed-content-text {
	color: rgb(51, 51, 51);
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

		<%
		DB db = new DB();

		String query = "SELECT puser.name, puser.email, pfeed.content, pfeed.timestamp, pfeed.hashcode FROM pfeed INNER JOIN puser ON pfeed.hashcode = puser.hashcode";
		db.stmt = db.conn.prepareStatement(query);

		db.rs = db.stmt.executeQuery();

		while (db.rs.next()) {
		%>

		<div class="feed-card">
			<div class="feed-controler-box">
				<b class="feed-timestamp"><%=db.rs.getString("pfeed.timestamp")%></b>
				<div class="d-flex justify-content-end">
					<%
					if (((String) db.rs.getString("pfeed.hashcode")).equals(hashcode)) {
					%>
					<img src="./static/img/delete.png" class="me-1"> <img
						src="./static/img/edit.png" class="me-1">
					<%
					}
					%>

				</div>
			</div>
			<div class="d-flex align-items-center">
				<div class="d-flex align-items-center feed-profile-box">
					<img src="./static/img/unknown_user.png" class="mr-3 profile-img">
					<div class="ms-2">
						<h5 class="mb-0">
							<strong><%=db.rs.getString("puser.name")%></strong>
						</h5>
						<p class="mb-0 ms-2"><%=db.rs.getString("puser.email")%></p>
					</div>
				</div>
			</div>
			<div class="feed-content-box">
				<p class="feed-content-text"><%=db.rs.getString("pfeed.content")%></p>
			</div>
		</div>


		<%
		}
		%>


	</div>
</body>
</html>