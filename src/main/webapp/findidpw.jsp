<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="xyz.cofon.DB"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYBADA.COM::ID/PW찾기</title>
<style type="text/css">
.find-box {
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
	<%
	if (session.getAttribute("hashcode") != null) {
		response.sendError(HttpServletResponse.SC_FORBIDDEN);
		return;
	}
	%>
	<%@ include file="header.jsp"%>

	<div class="content">
		<div class="find-box">

			<div class="mb-3">
				<h4>
					<b>ID/PW 찾기</b>
				</h4>
			</div>

			<form action="FindIdPwServlet" method="post" id="find-id-pw-form">
				<div>
					<h6>
						<b>이메일 가입여부 확인</b>
					</h6>
				</div>
				<div class="mb-5">
					<input type="email" class="form-control pe-5" id="email"
						name="email" placeholder="Email" maxlength="50" autocomplete="off">
					<div class="d-grid gap-2 mt-2">
						<button type="button" class="btn btn-light" id="check-exist-btn">가입
							확인</button>
					</div>
				</div>

				<div>
					<h6>
						<b>비밀번호 초기화</b>
					</h6>
				</div>
				<div class="mb-2">
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
						placeholder="Your answer" maxlength="255">
				</div>
				<div class="d-grid gap-2 mb-4">
					<button type="button" class="btn btn-primary" id="reset-pw-btn">비밀번호
						초기화</button>
				</div>

			</form>
		</div>

	</div>

	<%@ include file="footer.jsp"%>


	<script type="text/javascript">
		var email = $('#email')
		var checkExistBtn = $('#check-exist-btn');
		var question = $('#question');
		var answer = $('#answer');
		var clearPwBtn = $('#reset-pw-btn');
		
		var emailCheck = false;
		function checkEmailExist(){
			if (email.val() == ''){
				alert("이메일을 입력해주세요.");
				return;
			}
			
			var re = /[a-z0-9]+@[a-z]+\.[a-z]{2,3}/;
			if (!re.test(String(email.val()))){
				alert("이메일 형식이 올바르지 않습니다!");
				return;
			}
			
			var formData = new FormData($('#find-id-pw-form')[0]);
			formData.append("action", "checkEmailExist");
			
			ajaxPost(formData, "FindIdPwServlet", 
					(status, res) => {	//success
						if (res === "not_exist") {
							emailCheck = false;
							email.css("background-color", colorRed);
						} else if (res === "exist") {
							emailCheck = true;
							email.css("background-color", colorGreen);
						}
					},
					(status, res) => { //fail
						console.log("이메일 가입여부 확인 중 오류 발생!");
					}
				);
		}
		checkExistBtn.on("click", checkEmailExist);
		
		function resetPassword(){
			if(!emailCheck){
				alert("먼저 이메일 가입여부를 확인해야합니다.");
				return;
			}
			
			if (answer.val() == ''){
				alert("질문의 정답을 입력해주세요.");
				return;
			}
			
			var formData = new FormData($('#find-id-pw-form')[0]);
			formData.append("action", "resetPassword");
			
			ajaxPost(formData, "FindIdPwServlet", 
					(status, res) => {	//success
						if (res === "fail") {
							alert("이메일 또는 질문에 대한 답이 올바르지 않습니다. 다시 시도해주세요.");
						} else if (res === "ok") {
							alert("비밀번호가 '1234'로 초기화되었습니다.\n마이페이지에서 비밀번호를 바로 변경하시길 바랍니다.");
							window.location.href = 'login.jsp';
						}
					},
					(status, res) => { //fail
						console.log("비밀번호 초기화 중 오류 발생!");
					}
				);
		}
		clearPwBtn.on("click", resetPassword);
		
		//이메일 변경을 감지하고 조건을 취소하는 함수
		function whenEmailChange() {
			emailCheck = false;
			email.css("background-color", "white");
		}
		email.on("keydown", whenEmailChange);
		
	</script>
</body>
</html>