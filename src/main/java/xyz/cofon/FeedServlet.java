package xyz.cofon;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/FeedServlet")
public class FeedServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setCharacterEncoding("UTF-8");

		// session이 없으면 실패
		String hashcode = (String) request.getSession().getAttribute("hashcode");
		if (hashcode == null) {
			response.getWriter().write("no_permission");
			return;
		}

		String action = request.getParameter("action");

		if (action.equals("feedAdd")) {
			String content = request.getParameter("content");
			try {
				DB db = new DB();
				String sql = "INSERT INTO pfeed (hashcode, content) VALUES(?, ?)";
				db.stmt = db.conn.prepareStatement(sql);
				db.stmt.setString(1, hashcode);
				db.stmt.setString(2, content);
				if (db.stmt.executeUpdate() > 0) {
					response.getWriter().write("ok");
				} else {
					response.getWriter().write("fail");
				}

				db.close();
			} catch (SQLException e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				e.printStackTrace();
			}
		} else if (action.equals("feedEdit")) {
			String feedId = request.getParameter("feedId");
			String content = request.getParameter("content");
			try {
				DB db = new DB();
				String sql = "UPDATE pfeed SET content=? WHERE hashcode=? and id=?";
				db.stmt = db.conn.prepareStatement(sql);
				db.stmt.setString(1, content);
				db.stmt.setString(2, hashcode);
				db.stmt.setInt(3, Integer.parseInt(feedId));
				if (db.stmt.executeUpdate() > 0) {
					response.getWriter().write("ok");
				} else {
					response.getWriter().write("fail");
				}

				db.close();
			} catch (SQLException e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				e.printStackTrace();
			}
		} else if (action.equals("feedDelete")) {
			String feedId = request.getParameter("feedId");

			try {
				DB db = new DB();
				String sql = "DELETE FROM pfeed WHERE hashcode=? AND id=?";
				db.stmt = db.conn.prepareStatement(sql);
				db.stmt.setString(1, hashcode);
				db.stmt.setInt(2, Integer.parseInt(feedId));
				if (db.stmt.executeUpdate() > 0) {
					response.getWriter().write("ok");
				} else {
					response.getWriter().write("fail");
				}

				db.close();
			} catch (SQLException e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				e.printStackTrace();
			}
		}

	}

}
