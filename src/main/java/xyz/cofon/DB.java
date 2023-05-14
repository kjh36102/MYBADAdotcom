package xyz.cofon;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DB {
	public Connection conn = null;
	public PreparedStatement stmt = null;
	public ResultSet rs = null;

	private static DataSource dataSource;

	static {
		try {
			dataSource = (DataSource) new InitialContext().lookup("java:comp/env/jdbc/mybada");
		} catch (NamingException e) {
			e.printStackTrace();
		}

	}

	public DB() {
		this.connect();
	}

	public boolean connect() {
		try {
			this.conn = DB.dataSource.getConnection();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean close() {
		try {
			if (this.rs != null) {
				this.rs.close();
				this.rs = null;
			}
			if (this.stmt != null) {
				this.stmt.close();
				this.stmt = null;
			}
			if (this.conn != null) {
				this.conn.close();
				this.conn = null;
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

}
