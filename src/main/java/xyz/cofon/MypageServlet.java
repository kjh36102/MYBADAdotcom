package xyz.cofon;

import java.io.IOException;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/MypageServlet")
public class MypageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession();
		String hashcode = (String) session.getAttribute("hashcode");

		if (hashcode == null) {
			response.getWriter().write("no_permission");
			return;
		}

		String action = request.getParameter("action");

		if (action.equals("update")) {
			String name = request.getParameter("name").trim();
			String pw = request.getParameter("password").trim();

			DB db = new DB();

			try {
				String sql;
				PreparedStatement statement;
				if (pw.equals("")) {
					sql = "UPDATE puser SET name=? WHERE hashcode=?";
					statement = db.conn.prepareStatement(sql);
					statement.setString(1, name);
					statement.setString(2, hashcode);
				}

				else {
					sql = "UPDATE puser SET password=?, name=? WHERE hashcode=?";
					statement = db.conn.prepareStatement(sql);
					statement.setString(1, pw);
					statement.setString(2, name);
					statement.setString(3, hashcode);
				}

				int rowsUpdated = statement.executeUpdate();

				if (rowsUpdated > 0) {
					response.getWriter().write("ok");
					session.setAttribute("name", name);
				} else {
					response.getWriter().write("fail");
				}

				db.close();
			} catch (Exception e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "회원정보 업데이트 중 오류 발생!");
				e.printStackTrace();
			}

		} else if (action.equals("leaveOut")) {
			DB db = new DB();

			try {

				// 피드 모두 삭제
				String sql = "DELETE FROM pfeed WHERE hashcode=?";
				PreparedStatement statement = db.conn.prepareStatement(sql);
				statement.setString(1, hashcode);

				//유저 정보 삭제
				sql = "DELETE FROM puser WHERE hashcode=?";
				statement = db.conn.prepareStatement(sql);
				statement.setString(1, hashcode);
				int deleteUserState = statement.executeUpdate();

				if (deleteUserState > 0) {
					response.getWriter().write("ok");
					session.invalidate();
				} else {
					response.getWriter().write("fail");
				}

				db.close();
			} catch (Exception e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "회원정보 업데이트 중 오류 발생!");
				e.printStackTrace();
			}
		}
	}

}
