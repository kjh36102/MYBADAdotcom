<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYBADA.COM::피드</title>
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

.modal-dialog {
	width: 30em;
}

#myfeed-only-box input, #myfeed-only-box label {
	cursor: pointer;
}
</style>
</head>
<body>

	<%@ include file="header.jsp"%>

	<div class="content">


		<div class="container" id="feed-list-header">
			<div class="row align-items-center g-0">
				<div class="col-3">
					<h1 style="font-size: 2.5em;">
						<b>Feeds</b>
					</h1>
				</div>
				<div class="col-4 d-flex justify-content-end">
					<%
					if (hashcode != null) {
					%>
					<div class="form-check form-switch me-3" id="myfeed-only-box">
						<input class="form-check-input" type="checkbox" role="switch"
							id="myfeed-only-checkbox"> <label
							class="form-check-label" for="myfeed-only-checkbox">내 피드만</label>
					</div>
					<%
					}
					%>

				</div>
				<div class="col-5">
					<%
					if (hashcode != null) {
					%>

					<div id="feed-add-btn"
						class="d-flex align-items-center justify-content-center"
						data-bs-toggle="modal" data-bs-target="#feed-add-modal">

						<img src="./static/img/add.png" width=25 height=25>
					</div>
					<%
					}
					%>

				</div>
			</div>
		</div>
		<hr class="mt-2" style="width: 45em; height: 1em; margin: 0 auto;">

		<%
		DB db = new DB();

		String query = "SELECT puser.name, puser.email, pfeed.content, pfeed.timestamp, pfeed.hashcode, pfeed.id FROM pfeed INNER JOIN puser ON pfeed.hashcode = puser.hashcode ORDER BY pfeed.id DESC;";
		db.stmt = db.conn.prepareStatement(query);

		db.rs = db.stmt.executeQuery();

		while (db.rs.next()) {
			String feedId = db.rs.getString("pfeed.id");
		%>

		<div class="feed-card">
			<div class="feed-controler-box">
				<b class="feed-timestamp"><%=db.rs.getString("pfeed.timestamp")%></b>
				<div class="d-flex justify-content-end">
					<%
					if (((String) db.rs.getString("pfeed.hashcode")).equals(hashcode)) {
					%>
					<img src="./static/img/delete.png" class="me-1"
						onclick="ajaxDeleteFeed(<%=feedId%>)"> <img
						src="./static/img/edit.png" class="me-1"
						onclick="loadEditModal(<%=feedId%>)" data-bs-toggle="modal"
						data-bs-target="#feed-edit-modal">
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
							<strong class="feed-name"><%=db.rs.getString("puser.name")%></strong>
						</h5>
						<p class="mb-0 ms-2 feed-email"><%=db.rs.getString("puser.email")%></p>
					</div>
				</div>
			</div>
			<div class="feed-content-box">
				<p class="feed-content-text" id="feed-content-<%=feedId%>"><%=db.rs.getString("pfeed.content")%></p>
			</div>
		</div>


		<%
		}
		%>

	</div>

	<%@ include file="footer.jsp"%>


	<!-- Feed add Modal -->
	<div class="modal fade" id="feed-add-modal" tabindex="-1"
		aria-labelledby="feed-add-modal-label" aria-hidden="true">
		<div
			class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="feed-add-modal-label">피드 추가</h1>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						id="feed-add-btn-close" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="form-floating">
						<textarea class="form-control" placeholder="Leave a comment here"
							id="feed-add-content"></textarea>
						<label for="feed-add-content">Content</label>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary w-100"
						id="feed-add-complete-btn">완료</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Feed Edit Modal -->
	<div class="modal fade" id="feed-edit-modal" tabindex="-1"
		aria-labelledby="feed-edit-modal-label" aria-hidden="true">
		<div
			class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="feed-edit-modal-label">피드 수정</h1>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						id="feed-edit-btn-close" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="form-floating">
						<textarea class="form-control" placeholder="Leave a comment here"
							id="feed-edit-content"></textarea>
						<label for="feed-edit-content">Content</label>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary w-100"
						id="feed-edit-complete-btn">완료</button>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		
		//피드추가 ajax
		function ajaxAddFeed(){
			var feedAddContent = $('#feed-add-content');
			
			if(feedAddContent.val() === ""){
				alert("내용을 입력해주세요.");
				return;
			}
			
			var formData = new FormData();
			formData.append("action", "feedAdd");
			formData.append("content", feedAddContent.val().replace(/\n/g, "<br>"));
			
			ajaxPost(formData, "FeedServlet", 
					(status, res) => {	//success
						if (res === "ok") {
							alert("등록이 완료되었습니다!");
							window.location.href="feed.jsp";
						} else if (res === "fail") {
							alert("등록이 실패했습니다!");
						} else if (res === "no_permission"){
							alert("피드 작성 권한이 없습니다.");
							window.location.href="login.jsp";
						}
							
					},
					(status, res) => { //fail
						console.log("피드 등록 중 오류 발생!");
					}
				);
		}
		$('#feed-add-complete-btn').on("click", ajaxAddFeed);
		
		//피드삭제 ajax
		function ajaxDeleteFeed(feedId){
			var formData = new FormData();
			formData.append("action", "feedDelete");
			formData.append("feedId", feedId);
			
			ajaxPost(formData, "FeedServlet", 
					(status, res) => {	//success
						if (res === "ok") {
							alert("피드가 삭제되었습니다!");
							window.location.href="feed.jsp";
						} else if (res === "fail") {
							alert("피드 삭제가 실패했습니다!");
						} else if (res === "no_permission"){
							alert("피드 삭제 권한이 없습니다.");
							window.location.href="login.jsp";
						}
					},
					(status, res) => { //fail
						console.log("피드 삭제 중 오류 발생!");
					}
				);
		}
		
		var editFeedId = null;
		//피드수정 데이터 로드
		function loadEditModal(feedId){
			editFeedId = feedId;
			var feedContent = $('#feed-content-' + feedId).html();
			feedContent = feedContent.replace(/<br>/g, "\n");
			
			var feedTextArea = $('#feed-edit-content')
			feedTextArea.val(feedContent);
		}
		
		//피드수정 ajax
		function ajaxEditFeed(){
			var feedEditContent = $('#feed-edit-content');
			
			if(feedEditContent.val() === ""){
				alert("내용을 입력해주세요.");
				return;
			}
			
			var formData = new FormData();
			formData.append("action", "feedEdit");
			formData.append("feedId", editFeedId);
			formData.append("content", feedEditContent.val().replace(/\n/g, "<br>"));
			
			ajaxPost(formData, "FeedServlet", 
					(status, res) => {	//success
						if (res === "ok") {
							alert("수정이 완료되었습니다!");
							window.location.href="feed.jsp";
						} else if (res === "fail") {
							alert("수정이 실패했습니다!");
						} else if (res === "no_permission"){
							alert("피드 수정 권한이 없습니다.");
							window.location.href="login.jsp";
						}
					},
					(status, res) => { //fail
						console.log("피드 등록 중 오류 발생!");
					}
				);
		}
		$('#feed-edit-complete-btn').on("click", ajaxEditFeed);
		
		//내 피드만 보기
		$("#myfeed-only-checkbox").on("change", function() {
			var headerEmail = $('.header-email').text();
			var isMyFeedOnly = this.checked;
		
			$('.feed-card').each(function() {
				var feedEmail = $(this).find('.feed-email').text();
				var shouldHide = (isMyFeedOnly && feedEmail !== headerEmail);
				$(this).toggle(!shouldHide);
			});
		});

	</script>
</body>
</html>