<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYBADA.COM::로그아웃</title>
<style type="text/css">
#logout-box {
	width: 20em;
	margin: 0 auto;
	margin-top: 2em;
}
</style>
</head>
<body>

	<%@ include file="header.jsp"%>

	<div class="content d-flex align-items-center justify-content-center">
		<div id="logout-box" class="text-center">
			<h2><strong>로그아웃 되었습니다</strong></h2>
			<div class="d-grid gap-2 mt-5">
				<a class="btn btn-primary" href="feed.jsp">피드 화면으로</a>
			</div>
		</div>
	</div>

	<%@ include file="footer.jsp"%>

<script>
	
</script>
</body>
</html>