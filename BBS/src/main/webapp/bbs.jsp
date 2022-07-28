<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import = "java.io.PrintWriter" %>
    <%@ page import = "bbs.BbsDAO" %>
    <%@ page import = "bbs.Bbs" %>
    <%@ page import = "java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<style>
a{
	color:#000000;
	text-decoration:none;
}
a:hover{
	color:blue;
}

</style>


</head>
<body>
	<%
	//메인페이지로 이동했을때 세션에 값이 담겨있는지 체크
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	int pageNumber = 1; // 기본은 1페이지 할당
	//만약 파라이터로 넘어온 오브젝트 타입 'pageNumber'가 존재한다면
	//'int' 타입으로 캐스팅을 해주소 그값을 'pageNumber' 변수에 저장한다.
	
	if(request.getParameter("pageNumber") != null){
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
	 int boardID = 0;
		if (request.getParameter("boardID") != null){
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
	
	%>
	
		<nav class="navbar navbar-default"> <!-- 네비게이션 -->
		<div class="navbar-header"> 	<!-- 네비게이션 상단 부분 -->
			<!-- 네비게이션 상단 박스 영역 -->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<!-- 이 삼줄 버튼은 화면이 좁아지면 우측에 나타난다 -->
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- 상단 바에 제목이 나타나고 클릭하면 main 페이지로 이동한다 -->
			<a class="navbar-brand" href="main.jsp">여기 맛있어</a>
		</div>
		<!-- 게시판 제목 이름 옆에 나타나는 메뉴 영역 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
			<% if(boardID == 1){ %>	
				<li class="active"><a href="bbs.jsp?boardID=1&pageNumber=1">맛집 평가</a></li>
				<li><a href="bbs.jsp?boardID=2&pageNumber=1">자유게시판</a></li>
			<% }else if (boardID == 2){%>	
				<li><a href="bbs.jsp?boardID=1&pageNumber=1">맛집 평가</a></li>
				<li class="active"><a href="bbs.jsp?boardID=2&pageNumber=1">자유게시판</a></li>
			<% } %>
			</ul>
			<%
				//로그인하지 않았을 땔 보여지는 화면
				if(userID == null){
			%>
			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<!-- 드랍다운 아이템 영역 -->	
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				//로그인이 되어 있는 상태에서 보여주는 화면
 				}else{
			%>
			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<!-- 드랍다운 아이템 영역 -->	
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
						
					</ul>
				</li>
			</ul>
			<%
 				}			
			%>
			
		</div>
	</nav>
	<!-- 네비게이션 영역 끝 -->
	<!-- 게시판 메인 페이지 영역 시작 -->
<div class="container">
<%
	if(boardID == 1){
%>
		<h1>맛집게시판<br></h1>		
		<p>맛집게시판입니다. 서로 맛집을 공유합시다!<br><br></p>
<%	}
	else if (boardID == 2){
%>
		<h1>자유게시판<br></h1>
		<p>자유롭게 글을 쓰는 곳입니다. 서로 존중하며 글과 댓글을 남깁시다.<br><br></p>	
<%
	}
%>			
	<div class="container">		
		<div class="row">
		<table class="table table-striped" 
		style="text-align:center;border:1px solid #dddddd;">
			<thead>
				<tr>
					<th style="background-color:#eeeeee;text-align:center">번호</th>
					<th style="background-color:#eeeeee;text-align:center">제목</th>
					<th style="background-color:#eeeeee;text-align:center">작성자</th>
					<th style="background-color:#eeeeee;text-align:center">작성일</th>
				</tr>
			<thead>
			<tbody>
			<%
				BbsDAO bbsDAO = new BbsDAO();
				ArrayList<Bbs> list = bbsDAO.getList(boardID, pageNumber);
				for(int i=0; i < list.size(); i++){
			%>
				<tr>
					<!-- 테스트 코드 -->
					<td><%= list.get(i).getBbsID() %></td>
					<!-- 게시글 제목을 누르면 해당 글을 볼 수 있도록 링크를 걸어둔다. -->
					<td><a href="view.jsp?boardID=<%=boardID %>&bbsID=<%= list.get(i).getBbsID() %>">
						<%= list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br/>") %>
					</a></td>
					<td><%= list.get(i).getUserID() %></td>
					<td><%= list.get(i).getBbsDate().substring(0, 11) +  list.get(i).getBbsDate().substring(11, 13) +"시"+  list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
					
				</tr>
				<%
				}
				%>
						
			</tbody>
		
		</table>
			<%
			if(pageNumber !=1 ){
		%>
		<a href="bbs.jsp?boardID=<%=boardID%>&pageNumber=<%=pageNumber - 1%>" class="btn btn-success btn-arraw-left">
			이전
		</a>
		<%
		} if(bbsDAO.nextPage(boardID, pageNumber + 1)){
		%>
		<a href="bbs.jsp?boardID=<%=boardID%>&pageNumber=<%=pageNumber + 1%>" class="btn btn-success btn-arraw-left">
			다음
		</a>
		<%
		}
		%>
		<a href="write.jsp?boardID=<%=boardID%>" class="btn btn-primary pull-right">글쓰기</a>
		<!-- 글쓰기 버튼 생성 -->
	</div>
</div>	
	<!-- 게시판 메인 페이지 영역 끝 -->
</div>	
<!-- 부트스르랩 참조영역 -->
<script src="https://code.jquery.com/jquery-3.1.1.js"></script>
<script src="js/bootstrap.js"></script>
</body>
</html>