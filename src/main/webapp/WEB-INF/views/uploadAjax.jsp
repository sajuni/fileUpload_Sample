<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
.fileDrop {
	width: 100%;
	height: 200px;
	border: 1px dotted blue;
}
small {
	margin-left: 3px;
	font-weight: bold;
	color: gray;
}
</style>
	<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>
<body>

	<h3>Ajax File Upload</h3>
	<div class="fileDrop"></div>
	
	<div class="uploadedList"></div>
	

	<script>
	$(".fileDrop").on("dragenter dragover", function(event) {
		event.preventDefault();
	});

	$(".fileDrop").on("drop", function(event){
		event.preventDefault();
		
		var files = event.originalEvent.dataTransfer.files;
		
		var file = files[0];

		var formData = new FormData();

		formData.append("file", file);

		$.ajax({
			url: '/uploadAjax',
			data: formData,
			dataType: 'text',
			processData: false,
			contentType: false,
			type: 'POST',
			success: function(data){
				
				var str = "";

				console.log(data);
				console.log(checkImageType(data));
				
				if(checkImageType(data)){
					str ="<div><a href=displayFile?fileName="+getImageLink(data)+">"
						+"<img src='displayFile?fileName="+data+"'/>"
						+"</a><small data-src="+ data +">X</small></div>";
					}else{
					str = "<div><a href='displayFile?fileName=" + data +"'>" 
					+getOriginalName(data)+"</a>"
					+"<small data-src="+data+">X</small></div></div>";
				}
				
				$(".uploadedList").append(str);
				}	
		});
	});

	function checkImageType(fileName){
		var pattern = /jpg|gif|png|jpeg/i;
		return fileName.match(pattern);
	}

	function getOriginalName(fileName){
		if (checkImageType(fileName)) {
			return;
		}

		var idx = fileName.indexOf("_") + 1;
		return fileName.substr(idx);
	}

	// 이미지 파일 이름을 날짜 빼고 리턴
	function getImageLink(fileName){
		if(!checkImageType(fileName)) {
			return;
		}

		var front = fileName.substr(0,12);
		var end = fileName.substr(14);
		console.log('front',front);
		console.log('end',end)
		return front + end;		
	}

	$(".uploadedList").on("click", "small", function(event){
		var that = $(this);

		$.ajax({
			url:"deleteFile",
			type:"post",
			data: {fileName:$(this).attr("data-src")},
			dataType:"text",
			success:function(result) {
				if(result == 'deleted') {
						alert("deleted");
						that.parent("div").remove();
					}
				}
			});
		});
	
	</script>
</body>
</html>