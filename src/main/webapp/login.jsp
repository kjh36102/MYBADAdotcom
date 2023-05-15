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

			<form @submit.prevent="submitForm" id="login-form">
				<div class="mb-2">
					<input type="text" class="form-control pe-5" v-model="email"
						placeholder="Email" maxlength="50" required>
				</div>
				<div class="mb-3">
					<input type="password" class="form-control" v-model="password"
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
		</div>
	</div>


	<%@ include file="footer.jsp"%>

	<script type="text/javascript">
	
	new Vue({
		el: '#login-box',
		data: {
			email: '',
			password: '',
		},
		methods: {
			submitForm: function(){		//form을 제출하고 로그인하는 함수
				let formdata = new URLSearchParams();
				formdata.append("email", this.email);
				formdata.append("password", this.password);
				formdata.append("action", "signin");
				
				axios.post("SignServlet", formdata, {
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
					}
				})
				.then(response => {
					if (response.data === "invalid") {
						alert("이메일 또는 비밀번호가 올바르지 않습니다. 다시 시도해보세요.");
					} else if (response.data === "valid") {
						window.location.href="feed.jsp";
					} else if (response.data === "already_login"){
						alert("이미 로그인 된 상태입니다! 피드 페이지로 돌아갑니다.");
						window.location.href="feed.jsp";
					}
				})
				.catch(error => {
					alert("로그인 중 오류발생!");
					console.log(error);
				})

			}
		}
	})
	</script>
</body>
</html>