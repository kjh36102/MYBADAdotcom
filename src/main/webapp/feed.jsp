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

	<div class="content" id="content">

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
							id="myfeed-only-checkbox" v-model="showMyFeedSwitch"
							@change="showMyFeedToggle"> <label
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
						@click="openAddFeedModal" data-bs-toggle="modal"
						data-bs-target="#feed-modal">

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
						@click="deleteFeed(<%=feedId%>)"> <img
						src="./static/img/edit.png" class="me-1"
						@click="openEditFeedModal(<%=feedId%>)" data-bs-toggle="modal"
						data-bs-target="#feed-modal">
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
		<!-- Feed Modal -->
		<div class="modal fade" id="feed-modal" tabindex="-1"
			aria-labelledby="feed-modal-label" aria-hidden="true">
			<div
				class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
				<div class="modal-content">
					<div class="modal-header">
						<h1 class="modal-title fs-5" id="feed-modal-label">{{
							modalTitle }}</h1>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							id="feed-btn-close" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="form-floating">
							<textarea class="form-control" placeholder="Leave a comment here"
								id="feed-content" v-model="modalContent"></textarea>
							<label for="feed-content">Content</label>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary w-100"
							id="feed-complete-btn" @click="modalSubmit">완료</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="footer.jsp"%>

	<script type="text/javascript">
		
		new Vue({
			el: '#content',
			data: {
				showMyFeedSwitch: false,
				modalMode: '',
				modalTitle: '',
				modalContent: '',
				editFeedId: '',
			},
			methods: {
				openAddFeedModal: function(){	//피드 추가 모달 여는 함수
					this.modalMode = 'add';
					this.modalTitle = '피드 추가';
					this.modalContent = '';
				},
				openEditFeedModal: function(feedId){	//피드 수정 모달 여는 함수
					this.modalMode = 'edit';
					this.modalTitle = '피드 수정';
					this.modalContent = '';
					
					this.editFeedId = feedId;
					
					this.loadEditContent();
				},
				modalSubmit: function(){	//현재 모달 모드에 따라 콜백 호출하는 함수
					if (this.modalMode === 'add')
						this.addFeed();
					else if (this.modalMode === 'edit')
						this.editFeed();
				},
				addFeed: function(){	//피드 추가하는 함수
					let formdata = new URLSearchParams();
					formdata.append("content", this.modalContent.replace(/\n/g, "<br>"));
					formdata.append("action", "feedAdd");
					
					axios.post("FeedServlet", formdata, {
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
						}
					})
					.then(res => {
						if (res.data === "ok") {
							alert("피드가 등록되었습니다!");
							window.location.href="feed.jsp";
						} else if (res.data === "fail") {
							alert("피드등록이 실패했습니다!");
						} else if (res.data === "no_permission"){
							alert("피드 작성 권한이 없습니다.");
							window.location.href="login.jsp";
						}
					})
					.catch(error => {
						alert("피드 등록 중 오류 발생!");
						console.log(error);
					})
				},
				deleteFeed: function(feedId){		//피드 제거하는 함수
					let formdata = new URLSearchParams();
					formdata.append("feedId", feedId);
					formdata.append("action", "feedDelete");
					
					axios.post("FeedServlet", formdata, {
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
						}
					})
					.then(res => {
						if (res.data === "ok") {
							alert("피드가 삭제되었습니다!");
							window.location.href="feed.jsp";
						} else if (res.data === "fail") {
							alert("피드 삭제가 실패했습니다!");
						} else if (res.data === "no_permission"){
							alert("피드 삭제 권한이 없습니다.");
							window.location.href="login.jsp";
						}
					})
					.catch(error => {
						alert("피드 삭제 중 오류 발생!");
						console.log(error);
					})
				},
				editFeed: function(){		//피드 수정하는 함수
					let formdata = new URLSearchParams();
					formdata.append("content", this.modalContent.replace(/\n/g, "<br>"));
					formdata.append("feedId", this.editFeedId);
					formdata.append("action", "feedEdit");
					
					axios.post("FeedServlet", formdata, {
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
						}
					})
					.then(res => {
						if (res.data === "ok") {
							alert("수정이 완료되었습니다!");
							window.location.href="feed.jsp";
						} else if (res.data === "fail") {
							alert("수정이 실패했습니다!");
						} else if (res.data === "no_permission"){
							alert("피드 수정 권한이 없습니다.");
							window.location.href="login.jsp";
						}
					})
					.catch(error => {
						alert("피드 수정 중 오류 발생!");
						console.log(error);
					})
				},
				loadEditContent: function(){		//수정모드로 모달 창 열때 피드 내용 불러오는 함수
					editFeedId = this.editFeedId;
					var feedContent = $('#feed-content-' + editFeedId).html();
					this.modalContent = feedContent.replace(/<br>/g, "\n");
				},
				showMyFeedToggle: function() {		//내 피드만 보이게 하는 것을 토글하는 함수
				  var headerEmail = $('.header-email').text();
				  
				  $('.feed-card').each((index, element) => {
				    var feedEmail = $(element).find('.feed-email').text();
				    var shouldHide = !(this.showMyFeedSwitch && feedEmail !== headerEmail);
				    $(element).toggle(shouldHide);
				  });
				}
			}
		})
	
	</script>
</body>
</html>