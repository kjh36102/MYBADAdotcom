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

@WebServlet("/SignServlet")
public class SignServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public SignServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");

		if (action.equals("signin")) {
			String email = request.getParameter("email");
			String password = request.getParameter("password");

			try {
				DB db = new DB();
				String sql = "SELECT hashcode, email, name FROM puser WHERE email=? and password=?";

				db.stmt = db.conn.prepareStatement(sql);
				db.stmt.setString(1, email);
				db.stmt.setString(2, password);

				db.rs = db.stmt.executeQuery();

				// 검색 결과 확인
				if (db.rs.next()) {
					HttpSession session = request.getSession();
					session.setAttribute("hashcode", db.rs.getString("hashcode"));
					session.setMaxInactiveInterval(60 * 20);	//유휴 20분 세션종료
					response.getWriter().write("valid");
				} else {
					response.getWriter().write("invalid");
				}

				db.close();

			} catch (Exception e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "회원가입 중 오류발생!");
				System.out.println("error");
				e.printStackTrace();
			}
		} else if (action.equals("signout")) {
			HttpSession session = request.getSession();
			session.removeAttribute("hashcode");
		}

	}

}