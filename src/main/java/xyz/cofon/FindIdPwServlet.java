package xyz.cofon;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/FindIdPwServlet")
public class FindIdPwServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public FindIdPwServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	private boolean checkEmailExist(String email) throws IOException, SQLException {

		DB db = new DB();

		String query = "SELECT email FROM puser WHERE email = ?";
		db.stmt = db.conn.prepareStatement(query);
		db.stmt.setString(1, email);

		db.rs = db.stmt.executeQuery();

		// 중복 결과 확인
		boolean ret = false;
		if (db.rs.next()) {
			ret = true;
		}

		db.close();

		return ret;
	}

	protected void resetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
		try {
			String email = request.getParameter("email").trim();
			String question = request.getParameter("question");
			String answer = request.getParameter("answer").trim();

			if (!checkEmailExist(email)) {
				response.getWriter().write("fail");
				return;
			}

			DB db = new DB();

			String sql = "UPDATE puser SET password=? WHERE email=? and question_id=? and answer=?";
			PreparedStatement statement = db.conn.prepareStatement(sql);
			statement.setString(1, "1234");
			statement.setString(2, email);
			statement.setInt(3, Integer.parseInt(question));
			statement.setString(4, answer);
			int rowsInserted = statement.executeUpdate();

			if (rowsInserted > 0) {
				response.getWriter().write("ok");
			} else {
				response.getWriter().write("fail");
			}

			db.close();

		} catch (Exception e) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "회원가입 중 오류발생!");
			e.printStackTrace();
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");

		if (action.equals("checkEmailExist")) {
			String email = request.getParameter("email");
			try {
				if (checkEmailExist(email)) {
					response.getWriter().write("exist");
				} else {
					response.getWriter().write("not_exist");
				}
			} catch (IOException | SQLException e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "이메일 가입여부확인 중 오류발생!");
				e.printStackTrace();
			}

		} else if (action.equals("resetPassword")) {
			resetPassword(request, response);
		}
	}
}
