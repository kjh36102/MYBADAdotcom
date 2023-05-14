<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="xyz.cofon.DB"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYBADA.COM::회원가입</title>
<style type="text/css">
#register-box {
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
</style>
</head>
<body>

	<%@ include file="header.jsp"%>

	<div class="content">
		<div id="register-box">
			<div class="d-flex justify-content-between mb-2">
				<div>
					<h4>
						<b>회원가입</b>
					</h4>
				</div>
				<div>
					<img src="./static/img/cleanup.png" width="30" height="30"
						id="cleanup" onclick="clearInputValues()">
				</div>
			</div>
			<form action="RegisterServlet" method="post" id="register-form">
				<div class="mb-2">
					<input type="email" class="form-control pe-5" id="email"
						name="email" placeholder="Email" maxlength="50" autocomplete="off"
						required>
					<div class="d-grid gap-2 mt-2">
						<button type="button" class="btn btn-light" id="dupcheck-btn"
							onclick="checkEmailDup()">중복 확인</button>
					</div>
				</div>
				<div class="mb-2 mt-4">
					<input type="password" class="form-control" id="password"
						name="password" placeholder="Password" maxlength="50" required>
				</div>
				<div class="mb-2">
					<input type="password" class="form-control" id="password-check"
						placeholder="Password check" maxlength="50" required>
				</div>
				<div class="mb-4">
					<input type="text" class="form-control" id="username"
						name="username" placeholder="Name" maxlength="100" required>
				</div>

				<div class="mb-2">
					<p class="mb-1">
						<small>비밀번호 찾기 질문</small>
					</p>
					<select class="form-select" aria-label="Default select example"
						id="question" name="question">
						<%
						DB db = new DB();

						String query = "SELECT * FROM questions";
						db.stmt = db.conn.prepareStatement(query);

						db.rs = db.stmt.executeQuery();

						while (db.rs.next()) {
						%>
						<option value="<%=db.rs.getString("id")%>"><%=db.rs.getString("question")%></option>
						<%
						}

						db.close();
						%>
					</select>
				</div>

				<div class="mb-3">
					<input type="text" class="form-control" id="answer" name="answer"
						placeholder="Your answer" maxlength="255" required>
				</div>
				<div class="d-grid gap-2 mb-5">
					<button type="submit" class="btn btn-primary" id="submit">가입
						완료</button>
				</div>
			</form>
		</div>
	</div>



	<%@ include file="footer.jsp"%>

	<script type="text/javascript">
		var email = $("#email");
		var pw = $("#register-form #password");
		var pwCheck = $("#register-form #password-check");
		var username = $("#username");
		var question = $("#question");
		var answer = $("#answer");
		var submit = $("#submit");

		var emailCheck = false;

		//모든 input 태그를 초기화하는 함수
		function clearInputValues() {
			$('input').val('');
			$('input').css("background-color", "white");
		}

		//이메일 중복을 확인하는 함수
		function checkEmailDup() {
			if (email.val() == '') {
				alert("이메일을 입력한 뒤 눌러주세요.");
				return;
			}
		
			var formData = new FormData($('#register-form')[0]);
			formData.append("action", "checkEmailDup");
			
			ajaxPost(formData, "RegisterServlet", 
					(status, res) => {	//success
						if (res === "dup") {
							emailCheck = false;
							email.css("background-color", colorRed);
						} else if (res === "nodup") {
							emailCheck = true;
							email.css("background-color", colorGreen);
						}
					},
					(status, res) => { //fail
						console.log("이메일 중복확인 중 오류 발생!");
					}
				);
		}

		//이메일 변경을 감지하고 조건을 취소하는 함수
		function whenEmailChange() {
			emailCheck = false;
			email.css("background-color", "white");
		}
		email.on("keydown", whenEmailChange);

		//비밀번호 동일 확인
		function checkPassword() {
			var pwVal = pw.val();
			var pwCheckVal = pwCheck.val();

			if (pwVal.length === 0 || pwCheckVal.length === 0)
				return;

			var res = pwVal === pwCheckVal;
			pw.add(pwCheck)
					.css("background-color", res ? colorGreen : colorRed);
			return res;
		}
		pw.add(pwCheck).on("keyup", checkPassword);
		
		
		//폼 유효성 검증
		document.getElementById("register-form").addEventListener(
				"submit",
				function(event) {
					event.preventDefault(); 

					// 폼 유효성 검사 로직
					var re = /[a-z0-9]+@[a-z]+\.[a-z]{2,3}/;
					if (!re.test(String(email.val()))){
						alert("이메일 형식이 올바르지 않습니다!");
						return;
					}
					
					if (!emailCheck) {
						alert("이메일이 중복되지 않아야합니다!");
						return;
					}

					if (!checkPassword()) {
						alert("비밀번호가 서로 동일해야합니다!");
						return;
					}

					var formData = new FormData(this);
					formData.append("action", "register");
					
					ajaxPost(formData, "RegisterServlet", 
						(status, res) => {	//success
							if (res === "ok") {
								alert("회원가입이 완료되었습니다!");
								window.location.href = "login.jsp";
							} else if (res === "fail") {
								alert("회원가입이 실패했습니다.");
							}
						},
						(status, res) => { //fail
							console.log("회원가입 도중 오류가 발생했습니다!");
						}
					);
				});
		
		
	</script>
</body>
</html>