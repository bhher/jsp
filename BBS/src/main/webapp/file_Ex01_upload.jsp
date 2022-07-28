<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
	   //String location = request.getRealPath("upload");
		String location = "C:\\eclipse\\work\\BBS\\src\\main\\webapp\\upload"; 
		int maxSize = 1024 * 1024 * 5;// 키로바이트 * 메가바이트 * 기가바이트
		MultipartRequest multi = new MultipartRequest(request,
				location, maxSize, "utf-8", new DefaultFileRenamePolicy());
		String userName = multi.getParameter("userName");
		String element = "";
		String filesystemName = "";
		String originalFileName = "";
		String contentType = "";
		long length = 0;
	
		Enumeration<?> files = multi.getFileNames(); // <input type="file">인 모든 파라메타를 반환	
	if (files.hasMoreElements()) { 
			
			element = (String)files.nextElement(); 
			
			filesystemName 			= multi.getFilesystemName(element); 
			originalFileName 		= multi.getOriginalFileName(element); 
			contentType 			= multi.getContentType(element);	
			length 					= multi.getFile(element).length(); 
		
		}
		
		%>
		<p>사용자 이름 : <%=userName %></p>
		<p>파라메타 이름 : <%=element %></p>
		<p>서버에 업로드된 파일이름 : <%=filesystemName %></p>
		<p>유저가 업로드한 파일 이름 : <%=originalFileName %></p>
		<p>파일 타입: <%=contentType %></p>
		<p>파일 크기 : <%=length%></p>
	

</body>
</html>