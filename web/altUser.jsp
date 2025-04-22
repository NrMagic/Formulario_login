<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.Date" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Atualizar Contato</title>
</head>
<body>
<%
    String telefone, nome, posnome, endereco, cidade, estado, email, cpf;
    Date data_nasc = null;

    nome = request.getParameter("new-nome");
    posnome = request.getParameter("new-posnome");
    endereco = request.getParameter("new-endereco");
    cidade = request.getParameter("new-cidade");
    estado = request.getParameter("new-estado");
    email = request.getParameter("new-email");
    cpf = request.getParameter("new-cpf"); // CPF será usado como identificador único
    telefone = request.getParameter("new-telefone");
    String data_nasc_str = request.getParameter("new-data_nasc");

    if (data_nasc_str != null && !data_nasc_str.isEmpty()) {
        data_nasc = Date.valueOf(data_nasc_str);
    } else {
        out.print("<p style='color:red;'>Erro: Data de nascimento não foi fornecida.</p>");
        return;
    }

    try {
        Connection conecta;
        PreparedStatement st;
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db_wallas";
        String user = "root";
        String password = "";
        conecta = DriverManager.getConnection(url, user, password);

        String sql = "UPDATE tb_contato SET nome=?, posnome=?, endereco=?, cidade=?, estado=?, telefone=?, email=?, data_nasc=? WHERE cpf=?";
        st = conecta.prepareStatement(sql);
        st.setString(1, nome);
        st.setString(2, posnome);
        st.setString(3, endereco);
        st.setString(4, cidade);
        st.setString(5, estado);
        st.setString(6, telefone);
        st.setString(7, email);
        st.setDate(8, data_nasc);
        st.setString(9, cpf); // CPF é usado na cláusula WHERE

        int rowsUpdated = st.executeUpdate();

        if (rowsUpdated > 0) {
            out.print("<p style='color:green;font-size:25px'>Dados atualizados com sucesso!</p>");
        } else {
            out.print("<p style='color:orange;font-size:25px'>Nenhum registro foi atualizado. Verifique o CPF informado.</p>");
        }

    } catch (Exception x) {
        out.print("<p style='color:red;font-size:25px'>Erro: " + x.getMessage() + "</p>");
    }
%>  
</body>
</html>
