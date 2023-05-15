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
	<%
	if (session.getAttribute("hashcode") != null) {
		response.sendError(HttpServletResponse.SC_FORBIDDEN);
		return;
	}
	%>
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
						id="cleanup" @click="clearValues">
				</div>
			</div>
			<form @submit.prevent="verifyForm" id="register-form">
				<div class="mb-2">
					<input type="email" class="form-control pe-5" v-model="email"
						:style="{ backgroundColor: emailColor }" @input="whenEmailChange"
						placeholder="Email" maxlength="50" autocomplete="off" required>
					<div class="d-grid gap-2 mt-2">
						<button type="button" class="btn btn-light" @click="checkEmailDup">중복
							확인</button>
					</div>
				</div>
				<div class="mb-2 mt-4">
					<input type="password" class="form-control" v-model="passwordInput"
						@input="checkPassword" :style="{ backgroundColor: passwordColor }"
						placeholder="Password" maxlength="50" required>
				</div>
				<div class="mb-2">
					<input type="password" class="form-control"
						v-model="passwordCheckInput"
						:style="{ backgroundColor: passwordColor }" @input="checkPassword"
						placeholder="Password check" maxlength="50" required>
				</div>
				<div class="mb-4">
					<input type="text" class="form-control" v-model="username"
						placeholder="Name" maxlength="100" required>
				</div>

				<div class="mb-2">
					<p class="mb-1">
						<small>비밀번호 찾기 질문</small>
					</p>
					<select class="form-select" aria-label="Default select example"
						v-model="selectedQuestion">
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
					<input type="text" class="form-control" v-model="questionAnswer"
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
		//폼 frontend
		new Vue({
			el: '#register-box',
			data: {
				email: '',
				emailColor: 'white',
				emailCheck: false,
				passwordInput: '',
				passwordCheckInput: '',
				passwordColor: 'white',
				passwordCheck: false,
				username: '',
				selectedQuestion: '1',
				questionAnswer: '',
			},
			methods: {
				clearValues: function() {	//input 초기화 함수
					this.email = '';
					this.emailColor = 'white';
					this.emailCheck = false;
					this.passwordInput = '';
					this.passwordCheckInput = '';
					this.passwordColor = 'white';
					this.passwordCheck = false;
					this.username = '';
					this.selectedQuestion = '1';
					this.questionAnswer = '';
				},
				checkEmailDup: function() {	//이메일 중복체크 함수
					if (this.email == ''){
						alert("이메일을 입력한 뒤 눌러주세요");
						return;
					}
					
					var re = /[a-z0-9]+@[a-z]+\.[a-z]{2,3}/;
					if (!re.test(String(this.email))){
						alert("이메일 형식이 올바르지 않습니다!");
						return;
					}
					
					let formdata = new URLSearchParams();
					formdata.append("email", this.email);
					formdata.append("action", "checkEmailDup");
					
					axios.post("RegisterServlet", formdata, {
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
						}
					})
					.then(res => {
						if (res.data === "dup"){
							this.emailCheck = false;
							this.emailColor = colorRed;
						}else if (res.data === "nodup"){
							this.emailCheck = true;
							this.emailColor = colorGreen;
						}
					})
					.catch(error => {
						alert("이메일 중복확인 중 오류 발생!");
						console.log(error);
					})
				},
				whenEmailChange: function(){	//이메일 input 값 변경시 조건취소
					this.emailCheck = false;
					this.emailColor = "white";
				},
				checkPassword: function() {		//비밀번호 같은지 확인하는 함수
					if(this.passwordInput === '' && this.passwordCheckInput === ''){
						this.passwordColor = 'white';
						this.passwordCheck = true;
						return;
					}
					
					if (this.passwordInput === this.passwordCheckInput){
						this.passwordColor = colorGreen;
						this.passwordCheck = true;
						return true;
					}else {
						this.passwordColor = colorRed;
						this.passwordCheck = false;
						return false;
					}
				},
				verifyForm: function() {	//폼 데이터 유효성 검증하는 함수
					if(this.email === ''){
						alert("이메일을 입력해주세요!");
						return;
					}else if (!this.emailCheck) {
						alert("이메일 중복 확인 버튼을 눌러주세요!");
						return;
					}
					
					if(this.passwordInput === '' && this.passwordCheckInput === ''){
						alert('비밀번호를 입력해주세요!');
						return;
					}else if (!this.checkPassword()) {
						alert("비밀번호가 서로 동일해야합니다!");
						return;
					}
					
					if(this.username === ''){
						alert("이름을 입력해주세요!");
						return;
					}
					
					if(this.questionAnswer === ''){
						alert("질문의 정답을 입력해주세요!");
						return;
					}
					
					this.submitForm();
				},
				submitForm: function(){		//폼 데이터 ajax로 전송하는 함수
					let formdata = new URLSearchParams();
					formdata.append("email", this.email);
					formdata.append("password", this.passwordInput);
					formdata.append("username", this.username);
					formdata.append("question", this.selectedQuestion);
					formdata.append("answer", this.questionAnswer);
					formdata.append("action", "register");
					
					axios.post("RegisterServlet", formdata, {
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
						}
					})
					.then(res => {
						if (res.data === "ok") {
							alert("회원가입이 완료되었습니다!");
							window.location.href = "login.jsp";
						} else if (res.data === "fail") {
							alert("회원가입이 실패했습니다.");
						}
					})
					.catch(error => {
						alert("회원가입 중 오류가 발생했습니다!");
						console.log(error);
					})
				}
				
			}
		});
		
	</script>
</body>
</html>