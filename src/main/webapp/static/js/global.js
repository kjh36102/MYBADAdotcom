/**
 * 
 */

//비동기로 form 데이터를 전송하는 함수
function ajaxPost(formData, targetUrl, successCallback, errorCallback) {
	// Convert FormData to URL-encoded string
	var encodedData = Array.from(formData.entries()).map(function(pair) {
		return encodeURIComponent(pair[0]) + '=' + encodeURIComponent(pair[1]);
	}).join('&');

	// AJAX request
	var xhr = new XMLHttpRequest();
	xhr.open("POST", targetUrl, true);
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

	xhr.onload = function() {
		if (this.status === 200) {
			successCallback(this.status, this.responseText);
		} else {
			errorCallback(this.status, this.responseText);
		}
	};

	xhr.onerror = function() {
		errorCallback(this.status, this.statusText);
	};

	xhr.send(encodedData);
}
