<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYBADA.COM::마이페이지</title>
<style type="text/css">
.mypage-outer {
	width: 45em;
	margin: 0 auto;
}

#mypage-leave-warn-box {
	border: 3px solid red;
	border-radius: 0.5em;
	width: 18em;
	height: 2.5em;
	margin: 0 auto;
	font-size: 0.9em;
	font-weight: bold;
	background: rgb(255, 232, 232);
}
</style>
</head>
<body>

	<%@ include file="header.jsp"%>

	<div class="content">
		<div class="mypage-outer">
			<div class="container" id="mypage-header">
				<div class="row align-items-center g-0">
					<div class="col-3">
						<h1 style="font-size: 2.5em;">
							<b>My page</b>
						</h1>
					</div>
				</div>
			</div>
			<hr class="mt-2" style="width: 45em; height: 1em; margin: 0 auto;">

			<form id="mypage-update-form" class="ps-3 pe-3">
				<h4 class="mt-1 mb-3">회원정보 수정</h4>
				<div class="mb-2 d-flex align-items-center">
					<label for="mypage-name" class="form-label col-2">이름</label> <input
						type="text" class="form-control" v-model="name" id="mypage-name" name="email"
						placeholder="Name" maxlength="50" required>
				</div>
				<div class="mb-2 d-flex align-items-center">
					<label for="mypage-password" class="form-label col-2 ">비밀번호</label>
					<input type="password" class="form-control" v-model="passwordInput" id="mypage-password"
						@input="checkPassword" :style="{ backgroundColor: passwordColor }"
						name="password" placeholder="Password" maxlength="50" required>
				</div>
				<div class="mb-3 d-flex align-items-center">
					<label for="mypage-password-check" class="form-label col-2 ">비밀번호</label>
					<input type="password" class="form-control" id="mypage-password-check"
						v-model="passwordCheckInput" @input="checkPassword"
						:style="{ backgroundColor: passwordColor }" name="password"
						placeholder="Password check" maxlength="50" required>
				</div>
				<div class="d-grid gap-2">
					<button type="button" class="btn btn-primary" @click="editUserInfo">수정</button>
				</div>
			</form>

			<form id="mypage-leave-form" class="ps-3 pe-3 mt-5">
				<h4 class="mt-1 mb-3">회원 탈퇴</h4>
				<p class="mt-1 mb-3 small">회원 탈퇴를 하게 되면 되돌릴 수 없으며, 피드 내용을 포함한 모든
					데이터가 삭제됩니다. 계속하기를 원하시면 아래 내용을 입력해주세요.</p>
				<div id="mypage-leave-warn-box"
					class="d-flex justify-content-center align-items-center mb-4">
					<p class="mb-0" id="mypage-leave-warn-text">회원 탈퇴를 희망합니다</p>
				</div>
				<div class="mb-2 d-flex align-items-center">
					<input type="text" class="form-control mb-2" v-model="leaveConfirm"
						name="email" placeholder="확인을 위해 위 문장을 따라 적어주세요" maxlength="50"
						autocomplete="off" required>
				</div>
				<div class="d-grid gap-2">
					<button type="button" class="btn btn-danger" @click="leaveOut">회원
						탈퇴</button>
				</div>
			</form>
		</div>



	</div>
	<%@ include file="footer.jsp"%>

	<script type="text/javascript">
	
	new Vue({
		el: '#mypage-update-form',
		data: {
			name: '<%=session.getAttribute("name")%>',
			passwordInput: '',
			passwordCheckInput: '',
			passwordColor: 'white',
			passwordCheck: true,
		},
		methods: {
			editUserInfo: function(){
				
				if (this.name === ""){
					alert("빈 이름을 설정할 수 없습니다!");
					this.name = '<%=session.getAttribute("name")%>';
					return;
				}
				
				if (!this.checkPassword()) {
					alert("비밀번호가 서로 동일해야합니다!");
					return;
				}
				
				let formdata = new URLSearchParams();
				formdata.append("name", this.name);
				formdata.append("password", this.passwordInput);
				formdata.append("action", "update");
				
				axios.post("MypageServlet", formdata, {
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
					}
				})
				.then(res => {
					if (res.data === "ok") {
						alert("유저정보 수정이 완료되었습니다!");
						window.location.href="mypage.jsp";
					} else if (res.data === "fail") {
						alert("유저정보 수정이 실패했습니다!");
					} else if (res.data === "no_permission"){
						alert("유저정보를 수정할 권한이 없습니다.");
						window.location.href="login.jsp";
					}
				})
				.catch(error => {
					alert("유저정보 수정 중 오류발생!");
					console.log(error);
				})
				
			},
			checkPassword: function() {		//비밀번호 같은지 확인하는 함수
				if(this.passwordInput === '' && this.passwordCheckInput === ''){
					this.passwordColor = 'white';
					return true;
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
			}
		}
	});
	
	new Vue({
		el: '#mypage-leave-form',
		data: {
			leaveConfirm: '',
		},
		methods: {
			leaveOut: function(){
				if (this.leaveConfirm !== $('#mypage-leave-warn-text').text()){
					alert("입력에 오타가 있는 것 같습니다. 다시 확인해보세요.")
					return;
				}
				
				let formdata = new URLSearchParams();
				formdata.append("action", "leaveOut");
				
				axios.post("MypageServlet", formdata, {
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
					}
				})
				.then(res => {
					if (res.data === "ok") {
						alert("회원탈퇴가 완료되었습니다!");
						window.location.href="login.jsp";
					} else if (res.data === "fail") {
						alert("회원탈퇴가 실패했습니다!");
					} else if (res.data === "no_permission"){
						alert("회원탈퇴 권한이 없습니다.");
						window.location.href="login.jsp";
					}
				})
				.catch(error => {
					alert("회원탈퇴 중 오류발생!");
					console.log(error);
				})
			}
		}
	});
	
	</script>
</body>
</html>