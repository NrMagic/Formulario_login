<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.Date" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
<%
    String telefone, nome, posnome, endereco, cidade, estado, email, cpf;
    Date data_nasc = null;
    
    nome = request.getParameter("nome");
    posnome = request.getParameter("posnome");
    endereco = request.getParameter("endereco");
    cidade = request.getParameter("cidade");
    estado = request.getParameter("estado");
    email = request.getParameter("email");
    cpf = request.getParameter("cpf");
    telefone = request.getParameter("telefone");
    String data_nasc_str = request.getParameter("data_nasc");

    if (data_nasc_str != null && !data_nasc_str.isEmpty()) {
        data_nasc = Date.valueOf(data_nasc_str);  // Conversão direta para java.sql.Date
    } else {
        out.print("<p style='color:red;'>Erro: Data de nascimento não foi fornecida.</p>");
        return; // Interrompe se não houver data
    }

    // Validação de CPF
    cpf = cpf.replaceAll("[^0-9]", ""); // Remove qualquer caractere não numérico
    boolean isValidCPF = true;

    if (cpf.length() != 11) {
        isValidCPF = false; // CPF deve ter 11 caracteres
    } else if (cpf.matches("(\\d)\\1{10}")) {
        isValidCPF = false; // CPF com todos os números iguais é inválido
    } else {
        // Cálculo do primeiro dígito verificador
        int sum = 0;
        for (int i = 0; i < 9; i++) {
            sum += (10 - i) * (cpf.charAt(i) - '0');
        }
        int firstVerifier = 11 - (sum % 11);
        if (firstVerifier > 9) firstVerifier = 0; // Se for maior que 9, o dígito é 0

        // Cálculo do segundo dígito verificador
        sum = 0;
        for (int i = 0; i < 10; i++) {
            sum += (11 - i) * (cpf.charAt(i) - '0');
        }
        int secondVerifier = 11 - (sum % 11);
        if (secondVerifier > 9) secondVerifier = 0; // Se for maior que 9, o dígito é 0

        // Verifica se os dígitos verificadores são corretos
        if (cpf.charAt(9) != (char) (firstVerifier + '0') || cpf.charAt(10) != (char) (secondVerifier + '0')) {
            isValidCPF = false; // CPF inválido
        }
    }

    // Validação do Telefone (Formato e DDD)
    boolean isValidTelefone = false;
    String regexTelefone = "^\\(?\\d{2}\\)?\\s?\\d{5}\\-?\\d{4}$"; // Novo formato

    if (telefone.matches(regexTelefone)) {
        isValidTelefone = true; // O telefone está no formato correto
    }

    // Se CPF ou telefone for inválido, mostra o erro, caso contrário, insere os dados no banco
    if (!isValidCPF) {
        out.print("<p style='color:red;'>O CPF " + cpf + " é inválido!</p>");
    } else if (!isValidTelefone) {
        out.print("<p style='color:red;'>O telefone " + telefone + " é inválido!</p>");
    } else {
        try {
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/db_wallas";
            String user = "root";
            String password = "";
            conecta = DriverManager.getConnection(url, user, password);

            String sql = "INSERT INTO tb_contato (nome, posnome, endereco, cidade, estado, telefone, email, data_nasc, cpf) VALUES (?,?,?,?,?,?,?,?,?)";
            st = conecta.prepareStatement(sql);
            st.setString(1, nome);        // nome
            st.setString(2, posnome);     // posnome
            st.setString(3, endereco);    // endereco
            st.setString(4, cidade);     // cidade
            st.setString(5, estado);     // estado
            st.setString(6, telefone);   // telefone
            st.setString(7, email);      // email
            st.setDate(8, data_nasc);    // data_nasc
            st.setString(9, cpf);        // cpf

            st.executeUpdate(); // Executa o INSERT

            out.print("<p style='color:blue;font-size:25px'>Cadastro realizado com sucesso...</p>");
        } catch (Exception x) {
            String erro = x.getMessage();
            if (erro.contains("Duplicate entry")) {
                out.print("<p style='color:blue;font-size:25px'>Este cadastro já existe.</p>");
            } else {
                out.print("<p style='color:red;font-size:25px'>Erro: " + erro + "</p>");
            }
        }
    }
%>  
    </body>
</html>
