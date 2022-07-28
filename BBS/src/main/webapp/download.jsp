<%@page import="java.io.FileInputStream" %>
<%@page import="java.io.File" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<%
String fileName = request.getParameter("fileName");
ServletContext  context = getServletContext(); 
String downloadPath = context.getRealPath("upload");
//String downloadPath ="C:\\eclipse\\work\\BBS\\src\\main\\webapp\\upload";
String filePath = downloadPath + "\\" + fileName;
File file = new File(filePath);

//MIMETUPE 설정 - 문서의 다양성을 알려준다. -파일변환
String mimeType = getServletContext().getMimeType(filePath);
if (mimeType == null)
	mimeType = "application/octet-stream";
response.setContentType(mimeType);

//다운로드 설정 및 한글 파일명 깨지는 것 방지
String encoding = new String(fileName.getBytes("utf-8"),"8859_1");
response.setHeader("Content-Disposition", "attachment; filename= " + encoding);

// 요청파일을 읽어서 클라이언트에 전송
FileInputStream in = new FileInputStream(file);
ServletOutputStream outStream = response.getOutputStream();

byte b[] = new byte[4096];
int data = 0;
while ((data = in.read(b, 0, b.length)) != -1) {
	outStream.write(b, 0, data);
}

outStream.flush();
outStream.close();
in.close();

%>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>