package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mariadb://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "123456";
			Class.forName("org.mariadb.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	//작성일자 메소드
	public String getDate() {
		String sql = "select now()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return "";
		
	}
	
	
	//게시글번호
		public int getNext() {
			//현재 게시글을 내림차순으로 조회하여 가장 마지막 글의 번호를 구한다.
			String sql = "select bbsID from bbs order by  bbsID desc";
			try {
				PreparedStatement pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					return rs.getInt(1) + 1;
				}
				return 1;  //첫번째 게시물인 경우
				
			}catch (Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터 베이스 오류
			
		}
	
	//글쓰기 메소드
	
	public int write(int boardID, String bbsTitle, String userID, String bbsContent) {
		String sql = "insert into bbs values(?,?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardID);
			pstmt.setInt(2, getNext());
			pstmt.setString(3, bbsTitle);
			pstmt.setString(4, userID);
			pstmt.setString(5, getDate());
			pstmt.setString(6, bbsContent);
			pstmt.setInt(7, 1); //글의 유효번호
			return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류
	
	}	
	
	//게시글 리스트 메소드
	public ArrayList<Bbs> getList(int boardID, int pageNumber){
		String sql = "select * from bbs where boardID =? AND bbsID < ? and bbsAvailable = 1 order by bbsID desc limit 10";
		//모든 게시글조회합니다. 현재 유효번호가 존재하고 새롭게 작성될 게시글 번호보다 작은 모든 게시글번호를 
		//내림차순으로 정렬 최대 10개까지 조회 합니다.
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardID);
			pstmt.setInt(2, getNext() - (pageNumber -1 ) * 10);
			rs = pstmt.executeQuery();
	        while(rs.next()) {
	        	Bbs bbs = new Bbs();
	        	bbs.setBoardID(rs.getInt(1));
	        	bbs.setBbsID(rs.getInt(2));
	        	bbs.setBbsTitle(rs.getString(3));
	        	bbs.setUserID(rs.getString(4));
	        	bbs.setBbsDate(rs.getString(5));
	        	bbs.setBbsContent(rs.getString(6));
	        	bbs.setBbsAvailable(rs.getInt(7));
	        	list.add(bbs);
	        }
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
		
	}
	
	//페이징 처리 메소드
	public boolean nextPage (int boardID, int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE boardID = ? AND bbsID < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			pstmt.setInt(2,  getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false; //�����ͺ��̽� ����
	}
	// 특정한 페이지가 존재하는지 조회하는 메소드
	//게시글이 10개에서 11개로 넘어갈때 '다음' 버튼을 만드렁 페이징 처리를 위한 기능 
	
	
	
	//하나의 게시글을 보는 메소드
	 public Bbs getBbs(int boardID, int bbsID) {
		   String sql = "select * from bbs where boardID = ? && bbsID = ?";
		   try {
		      PreparedStatement pstmt = conn.prepareStatement(sql);
		      pstmt.setInt(1, boardID);
		      pstmt.setInt(2, bbsID);
		      rs = pstmt.executeQuery();
		      if(rs.next()) {
		         Bbs bbs = new Bbs();
		         bbs.setBoardID(rs.getInt(1));
		         bbs.setBbsID(rs.getInt(2));
		         bbs.setBbsTitle(rs.getString(3));
		         bbs.setUserID(rs.getString(4));
		         bbs.setBbsDate(rs.getString(5));
		         bbs.setBbsContent(rs.getString(6));
		         bbs.setBbsAvailable(rs.getInt(7));
		            
		         return bbs;
		      }
		      
		      
		   }catch (Exception e){
		      e.printStackTrace();
		   }
		    return null;
		   }
	//게시글 수정 메소드
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String sql = "update bbs set bbsTitle = ?, bbscontent = ?  where bbsID =? ";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류
	}
	
	//게시글 삭제 메소드
	public int delete(int bbsID) {
		String sql = "update bbs set bbsAvailable = 0 where bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			return  pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	//매개변수로 게시글 번호를 받아와 해당 게시글 번호에 해당하는 게시글의
	//유효숫자를 '0'으로 변경하여 유효하지 않은 글로 수정합니다. 실제로 데이터를
	// 삭제하지는 않는 로직입니다.
	
}

