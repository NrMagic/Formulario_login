<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <%
            String usuario = request.getParameter("usuario");
            String senha = request.getParameter("senha");

            try {
                // Conectar ao banco de dados
                Connection conecta;
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/db_login";
                String user = "root";
                String password = "";
                conecta = DriverManager.getConnection(url, user, password);

                // Preparar a consulta SQL para buscar o usuário com a senha correta
                String sql = "SELECT * FROM tb_login WHERE usuario = ? AND senha = ?";
                PreparedStatement st = conecta.prepareStatement(sql);
                st.setString(1, usuario);
                st.setString(2, senha);

                // Executar a consulta
                ResultSet rs = st.executeQuery();

                if (rs.next()) {
                    // Verificar se o usuário é administrador
                    String classe = rs.getString("classe");
                    
                    if ("admin".equals(classe)) {
                        // Se for admin, redirecionar para a página de admin
                        response.sendRedirect("centerpageAdm.html");
                    } else {
                        // Se for usuário comum, redirecionar para a página de usuário
                        response.sendRedirect("centerpageUsuario.html");
                    }
                } else {
                    // Se não encontrar o usuário ou senha no banco
                    out.println("Usuário ou senha incorretos.");
                }

                // Fechar o PreparedStatement e a conexão
                st.close();
                conecta.close();

            } catch (Exception e) {
                e.printStackTrace();
                out.println("Erro ao conectar ao banco de dados.");
            }
        %>
    </body>
</html>
