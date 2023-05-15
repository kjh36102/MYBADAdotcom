<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- Vue.js CDN 추가 -->
<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
<!-- Axios CDN 추가 -->
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%@ include file="header.jsp"%>

	<div class="content">

		<div id="app">{{ message }}</div>

	</div>

	<%@ include file="footer.jsp"%>

	<script>
    new Vue({
      el: '#app',
      data: {
        message: 'Loading...'
      },
      created() {
        axios.get('https://jsonplaceholder.typicode.com/posts/1')
          .then(response => {
            this.message = response.data.title;
          })
          .catch(error => {
            console.log(error);
            this.message = 'Error! Could not reach the API.';
          })
      }
    })
  </script>
</body>
</html>