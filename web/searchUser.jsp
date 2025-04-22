<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listagem de produtos</title>
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <div class="pesquisa">
            <form method="get" action="listarUsuarios.jsp">
                <label for="search">Pesquisar:</label>
                <input type="text" id="search" name="search" placeholder="Digite um nome ou sobrenome">
                <input type="submit" value="Pesquisar">
            </form>
            <div class="box">
            <fieldset>
                <legend>Listagem de Usuários</legend>

            <!-- Barra de Pesquisa -->
           
            
            <%
                // Definindo as colunas válidas diretamente em uma string
                String coluna = request.getParameter("coluna");
                String ordem = request.getParameter("ordem");
                String search = request.getParameter("search");  // Recebe o valor da pesquisa

                // Verifica se a coluna é uma das colunas válidas
                if (coluna == null || (!coluna.equals("id") && !coluna.equals("nome") && !coluna.equals("cpf") && !coluna.equals("data_nasc"))) {
                    coluna = "id";  // Valor padrão se coluna for inválida
                }

                if (ordem == null) ordem = "ASC"; // Valor padrão para ordem

                // Conectar ao banco de dados
                Connection conecta;
                PreparedStatement st;
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/db_wallas";
                String user = "root";
                String password = "";
                conecta = DriverManager.getConnection(url, user, password);

                // Montar a consulta SQL, considerando a pesquisa
                String sql;
                if (search != null && !search.isEmpty()) {
                    // Busca pelo nome ou sobrenome (posnome)
                    sql = "SELECT * FROM tb_contato WHERE nome LIKE ? OR posnome LIKE ? ORDER BY " + coluna + " " + ordem;
                    st = conecta.prepareStatement(sql);
                    st.setString(1, "%" + search + "%");
                    st.setString(2, "%" + search + "%");
                } else {
                    // Caso não haja pesquisa, busca todos os registros
                    sql = "SELECT * FROM tb_contato ORDER BY " + coluna + " " + ordem;
                    st = conecta.prepareStatement(sql);
                }

                ResultSet rs = st.executeQuery();
            %>

            <table border="1">
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Endereço</th>
                    <th>Cidade</th>
                    <th>Estado</th>
                    <th>Telefone</th>
                    <th>Email</th>
                    <th>Data Nascimento</th>
                    <th>CPF</th>
                    <th>Excluir</th>
                </tr>
                
                <%
                    // Enquanto houver dados no ResultSet
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("id") %></td>
                    <td><%= rs.getString("nome") + " " + rs.getString("posnome") %></td>
                    <td><%= rs.getString("endereco") %></td>
                    <td><%= rs.getString("cidade") %></td>
                    <td><%= rs.getString("estado") %></td>
                    <td><%= rs.getString("telefone") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getDate("data_nasc") %></td>
                    <td><%= rs.getString("cpf") %></td>
                    <td>
                        <!-- Botão de Exclusão -->
                        <form method="post" action="deleteUser.jsp">
                            <input type="hidden" name="id" value="<%= rs.getString("id") %>">
                            <input type="submit" value="Excluir">
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
                </table>
             </fieldset>
            </div>
        </div>
    </body>
</html>
