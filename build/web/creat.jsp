<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.*"%>
        
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cadastro de usuario</title>
    </head>
    <body>
        <%
          //receber dados digitados do formulario cadpro.html
          String usuario, senha, select;
          int ID;
          ID=Integer.parseInt(request.getParameter("ID"));
          usuario=request.getParameter("usuario");
          senha=request.getParameter("senha");
          select=request.getParameter("classe");
          //fazer a conexão com o banco de dados
          try{
          Connection conecta;
          PreparedStatement st;//este objeto permite enviar vários
          // comandos SQL como um grupo unico para um banco de dados.
          Class.forName("com.mysql.cj.jdbc.Driver");//este método
          // é usado para que o servidor de aplicação faça o registro
          //do driver do Banco
          String url="jdbc:mysql://localhost:3306/db_login";
          String user="root";
          String password="root";
          
          conecta=DriverManager.getConnection(url,user,password);
          //inserindo dados na tabela do banco de dados
          String sql=("INSERT INTO tb_login VALUES (?,?,?,?)");
          st= conecta.prepareStatement(sql);
          st.setInt(1,ID);
          st.setString(2,usuario);
          st.setString(3,senha);
          st.setString(4,select);
          st.executeUpdate();// executar a instrução INSERT
          out.print("<p style='color:blue;font-size:25px'> Usuario cadastrado com sucesso...</p>");
          
            }catch (Exception x){
                String erro=x.getMessage();
                if (erro.contains("Duplicate entry")){
                    out.print("<p style='color:blue;font-size:25px'>Este produto já está cadastrado</p>");
                   }else{
                    out.print("<p style='color:red;font-size:25px'>Mensagem de erro: " + erro +"</p>");
                    }
            }
        %>
    </body>
</html>
