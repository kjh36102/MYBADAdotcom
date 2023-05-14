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
					<label for="mypage-name" class="form-label col-2 ">이름</label> <input
						type="text" class="form-control" id="mypage-name" name="email"
						placeholder="Name" maxlength="50" required>
				</div>
				<div class="mb-2 d-flex align-items-center">
					<label for="mypage-password" class="form-label col-2 ">비밀번호</label>
					<input type="password" class="form-control" id="mypage-password"
						name="password" placeholder="Password" maxlength="50" required>
				</div>
				<div class="mb-3 d-flex align-items-center">
					<label for="mypage-password-check" class="form-label col-2 ">비밀번호</label>
					<input type="password" class="form-control"
						id="mypage-password-check" name="password"
						placeholder="Password check" maxlength="50" required>
				</div>
				<div class="d-grid gap-2">
					<button type="button" class="btn btn-primary" id="login-btn">수정</button>
				</div>
			</form>

			<form id="mypage-leave-form" class="ps-3 pe-3 mt-5">
				<h4 class="mt-1 mb-3">회원 탈퇴</h4>
				<p class="mt-1 mb-3 small">
					회원 탈퇴를 하게 되면 되돌릴 수 없으며, 피드 내용을 포함한 모든 데이터가 삭제됩니다. 계속하기를
					원하시면 아래 내용을 입력해주세요.
				</p>
				<div id="mypage-leave-warn-box"
					class="d-flex justify-content-center align-items-center mb-4">회원
					탈퇴를 희망합니다</div>
				<div class="mb-2 d-flex align-items-center">
					<input type="text" class="form-control mb-2" id="mypage-name"
						name="email" placeholder="확인을 위해 위 문장을 따라 적어주세요" maxlength="50"
						required>
				</div>
				<div class="d-grid gap-2">
					<button type="button" class="btn btn-danger" id="login-btn">회원
						탈퇴</button>
				</div>
			</form>
		</div>



	</div>
	<%@ include file="footer.jsp"%>

	<script type="text/javascript">
		
	</script>
</body>
</html>