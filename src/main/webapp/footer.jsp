<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style type="text/css">
#footer {
	background: rgb(94, 94, 94);
	color: rgb(224, 224, 224);
	height: var(--footer-height);
}

</style>
</head>
<body>

	<%
	HttpServletRequest httpServletRequest = (HttpServletRequest) request;
	String callingPage = httpServletRequest.getRequestURI();
	String callingPageName = callingPage.substring(callingPage.lastIndexOf("/") + 1);
	%>

	<footer>
		<div id="footer" class="d-flex align-items-center justify-content-center flex-column">
			<p class="mb-0"><strong>20184356 김주현</strong></p>
			<p class="mb-0"><strong><%=callingPageName%></strong></p>
		</div>
	</footer>

</body>
</html>