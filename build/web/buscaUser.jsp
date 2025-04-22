<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="style.css">

    <title>Buscar e Alterar Funcionário</title>
</head>
<body>
    <section class="box-pesquisa">
    <div class="pesquisa">
        <!-- Caixa de Pesquisa -->
        <h2>Buscar Funcionário</h2>
        <form action="buscaUser.jsp" method="get">
            <label for="search" id="labalInput">Digite o nome do funcionário:</label>
            <input type="text" id="search" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button type="submit" id="buscar">Buscar</button>
        </form>
    </div>
    
    <div class="caixa">
        <!-- Resultados da Pesquisa -->
        <fieldset>
        <legend>Resultados da Pesquisa:</legend>
        <%
            String searchTerm = request.getParameter("search");
            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;
            
            try{
                // Conectar ao banco de dados
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/db_wallas";
                String user = "root";
                String password = "";
                conecta = DriverManager.getConnection(url, user, password);

                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                    // Query para buscar funcionários com nome que contenham o termo de pesquisa
                    String sql = "SELECT * FROM tb_contato WHERE nome LIKE ? OR posnome LIKE ?";
                    st = conecta.prepareStatement(sql);
                    st.setString(1, "%" + searchTerm + "%");
                    st.setString(2, "%" + searchTerm + "%");

                    rs = st.executeQuery();

                    if (rs.next()) {
                        // Exibir resultados da pesquisa em uma tabela%>
                        
                        <table border='1'>
                        <tr>
                            <th>ID</th>
                            <th>Nome</th>
                            <th>Endereço</th>
                            <th>Cidade</th>
                            <th>Estado</th>
                            <th>Telefone</th>
                            <th>Email</th>
                            <th>Data Nacimento</th>
                            <th>CPF</th>
                            <th>Ações</th>
                        </tr>
                     <%   do {
                         %>
                            <tr>
                            <td><%= rs.getString("id")%></td>
                            <td><%=rs.getString("nome") + " " + rs.getString("posnome")%></td>
                            <td><%=rs.getString("endereco")%></td>
                            <td><%=rs.getString("cidade")%></td>
                            <td><%=rs.getString("estado")%></td>
                            <td><%=rs.getString("telefone")%></td>
                            <td><%=rs.getString("email")%></td>
                            <td><%=rs.getString("data_nasc")%></td>
                            <td><%=rs.getString("cpf")%></td>
                         <% out.println("<td><a href='buscaUser.jsp?search=" + searchTerm + "&id=" + rs.getInt("id") + "'>Selecionar</a></td>"); %>
                            </tr>
                      <%  } while (rs.next());
                        out.println("</table>");
                    } else {
                        out.println("<p>Nenhum funcionário encontrado.</p>");
                    }
                }

                // Exibir dados do funcionário selecionado
                String id = request.getParameter("id");
                if (id != null) {
                    // Consultar o funcionário pelo ID
                    String sql = "SELECT * FROM tb_contato WHERE id = ?";
                    PreparedStatement st2 = conecta.prepareStatement(sql);
                    st2.setInt(1, Integer.parseInt(id));
                    ResultSet rs2 = st2.executeQuery();

                    if (rs2.next()) {
        %>
</div>
        <div class="alt">
        <form action="altUser.jsp" method="post">
        <fieldset>
        <legend>Alterar Dados do Funcionário</legend>
        
            <div class="inputbox">
            <input type="hidden" name="id" value="<%= rs2.getString("id") %>">
            </div>
            <div class="line">
                <div class="inputbox">
                    <input type="text" id="new-nome" name="new-nome" class="inputUser" value="<%= rs2.getString("nome") %>" required>
                    <label class="labelInput">Novo Nome:</label>
                </div>
                <div class="inputbox">
                    <input type="text" id="new-posnome" name="new-posnome" class="inputUser" value="<%= rs2.getString("posnome") %>" required>
                    <label for="new-posnome" class="labelInput">Novo Sobrenome:</label>
                </div>
            </div>
            <div class="line">
                <div class="inputbox">
                    <input type="text" id="new-endereco" name="new-endereco" class="inputUser" value="<%= rs2.getString("endereco") %>" required>
                    <label for="new-endereco" class="labelInput">Novo Endereço:</label>
                </div>
                    <div class="inputbox">
                    <input type="text" id="new-cidade" name="new-cidade" class="inputUser" value="<%= rs2.getString("cidade") %>" required>
                <label for="new-cidade" class="labelInput">Nova Cidade:</label>
                </div>
                <div class="inputbox">
                    <input type="text" id="new-estado" name="new-estado" class="inputUser" value="<%= rs2.getString("estado") %>" required>
                    <label for="new-estado" class="labelInput">Novo Estado:</label>
                </div>
            </div>
            <div class="line">
                <div class="inputbox">
                    <input type="tel" id="new-telefone" name="new-telefone" class="inputUser" value="<%= rs2.getString("telefone") %>" required>
                 <label for="new-telefone" class="labelInput">Novo Telefone:</label>
                </div>
                <div class="inputbox">
                    <input type="email" id="new-email" name="new-email" class="inputUser" value="<%= rs2.getString("email") %>" required>
                    <label for="new-email" class="labelInput">Novo Email:</label>
                </div>
            </div>
            <div class="line">
                    <label for="new-data" id="labelData">Data de Nascimento:</label>
                    <input type="date" id="new-data_nasc" name="new-data_nasc"  value="<%= rs2.getString("data_nasc") %>" required>
                <div class="inputbox">
                    <input type="text" id="new-cpf" name="new-cpf" class="inputUser" value="<%= rs2.getString("cpf") %>" required>
                    <label for="new-cpf" class="labelInput">Novo CPF:</label>
                </div>
            </div>
            <button type="submit" id="submit" name="submit">Salvar Alterações</button>
        
        </fieldset>
       </form>
        </div>
            </section>

        <%
                    } else {
                        out.println("<p>Funcionário não encontrado.</p>");
                    }
                }
            }catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Erro ao conectar ao banco de dados: " + e.getMessage() + "</p>");
            } finally {
                // Fechar recursos
                try {
                    if (rs != null) rs.close();
                    if (st != null) st.close();
                    if (conecta != null) conecta.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        
    
</body>
</html>
