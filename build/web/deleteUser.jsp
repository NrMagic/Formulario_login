<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Exclusão de Usuário</title>
    </head>
    <body>
        <%
            String id = request.getParameter("id");
            if (id != null) {
                try {
                    // Conectar ao banco de dados
                    Connection conecta;
                    PreparedStatement st;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/db_wallas";
                    String user = "root";
                    String password = "";
                    conecta = DriverManager.getConnection(url, user, password);

                    // SQL para excluir o usuário
                    String sql = "DELETE FROM tb_contato WHERE id = ?";
                    st = conecta.prepareStatement(sql);
                    st.setString(1, id);
                    st.executeUpdate();

                    // Redireciona de volta para a lista de usuários
                    response.sendRedirect("searchUser.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
    </body>
</html>
