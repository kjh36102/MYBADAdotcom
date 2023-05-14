<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYBADA.COM::로그인</title>
<style type="text/css">
#login-box {
	width: 20em;
	margin: 0 auto;
	margin-top: 2em;
}

#cleanup {
	margin-right: 0.5em;
	position: relative;
	top: 3em;
	cursor: pointer;
}

#form-help-outer div {
	cursor: pointer;
}
</style>

</head>
<body>

	<%@ include file="header.jsp"%>

	<div class="content">
		<div id="login-box">
			<div class="d-flex justify-content-between mb-2">
				<div>
					<h4>
						<b>로그인</b>
					</h4>
				</div>
				<div>
					<img src="./static/img/cleanup.png" width="30" height="30"
						id="cleanup" onclick="clearInputValues()">
				</div>
			</div>
			<form action="LoginServlet" method="post" id="login-form">
				<div class="mb-2">
					<input type="text" class="form-control pe-5" name="email"
						placeholder="Email" maxlength="50" required>
				</div>
				<div class="mb-3">
					<input type="password" class="form-control" name="password"
						placeholder="Password" maxlength="50" required>
				</div>
				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-primary" id="login-btn">로그인</button>
				</div>

			</form>

			<div class="mt-3" id="form-help-outer">
				<div id="find-id-pw" class="form-text cursor-pointer"
					onclick="window.location.href='findidpw.jsp'">ID/PW가 기억나지
					않습니다.</div>
				<div id="register" class="form-text user-select"
					onclick="window.location.href='register.jsp'">아직 회원이 아니십니까?
					Please join us!</div>
			</div>

			<div class="mt-5 mb-5">
				<p>
					<small>우리 웹사이트는 사용자 경험의 증진을 위해 쿠키를 사용합니다. 로그인 하는것은 쿠키 사용에
						동의한 것과 같음을 알립니다.</small>
				</p>
			</div>
		</div>
	</div>


	<%@ include file="footer.jsp"%>

	<script type="text/javascript">
		//모든 input 태그를 초기화하는 함수
		function clearInputValues() {
			$('input').val('');
		}
		
		//폼 유효성 검증
		$('#login-form').submit((event) => {
			event.preventDefault();
			
			var formData = new FormData(event.target);
			formData.append("action", "signin");
			
			ajaxPost(formData, "SignServlet", 
				    (status, res) => {  //success
				        if (res === "invalid") {
				            alert("이메일 또는 비밀번호가 올바르지 않습니다. 다시 시도해보세요.");
				        } else if (res === "valid") {
				            window.location.href="feed.jsp";
				        }
				    },
				    (status, res) => { //fail
				        console.log("로그인 중 오류 발생!");
				    }
				);
		});
		
	</script>
</body>
</html>